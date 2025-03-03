package com.mtg.zimble.reader.tags.data

import android.util.Log

import kotlinx.coroutines.CoroutineScope
//import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

import com.mtg.zimble.reader.tags.data.TagData as TagData
import com.mtg.zimble.reader.tags.domain.TagController

import com.uk.tsl.rfid.asciiprotocol.AsciiCommander
import com.uk.tsl.rfid.asciiprotocol.commands.AbortCommand
import com.uk.tsl.rfid.asciiprotocol.commands.AlertCommand
import com.uk.tsl.rfid.asciiprotocol.commands.BarcodeCommand
import com.uk.tsl.rfid.asciiprotocol.commands.FactoryDefaultsCommand
import com.uk.tsl.rfid.asciiprotocol.commands.InventoryCommand
import com.uk.tsl.rfid.asciiprotocol.commands.LinkProfileCommand
import com.uk.tsl.rfid.asciiprotocol.commands.ReadLogFileCommand
import com.uk.tsl.rfid.asciiprotocol.enumerations.AlertDuration
import com.uk.tsl.rfid.asciiprotocol.enumerations.TriState
import com.uk.tsl.rfid.asciiprotocol.responders.IBarcodeReceivedDelegate
import com.uk.tsl.rfid.asciiprotocol.responders.ICommandResponseLifecycleDelegate
import com.uk.tsl.rfid.asciiprotocol.responders.ITransponderReceivedDelegate
import com.uk.tsl.rfid.asciiprotocol.responders.TransponderData
import com.uk.tsl.utils.HexEncoding

import java.util.HashMap
import java.util.Locale


class AndroidTagController() : TagController {
    val TAG = "AndroidTagController"


    private var anyTagSeen: Boolean = false
    private var enabled: Boolean  = false
    private var continuousScanEnabled: Boolean = false

    private var uniquesOnly: Boolean = false
    private var tagsSeen: Int = 0

    private var alertLastIssueTime: Long = System.nanoTime()
    private var alertRepeatDelayInMs: Long = (400 * 1000 * 1000).toLong()
    private var alertCommand: AlertCommand = AlertCommand()

    private var isInfoRequested: Boolean = false
    private var linkProfile: Int = 0

    private var maximumTagsPerScan: Int = 0

    // The command to use as a responder to capture incoming inventory responses
    private var inventoryResponder: InventoryCommand = InventoryCommand()

    // The command used to issue commands
    private var inventoryCommand: InventoryCommand= InventoryCommand()

    // The command to use as a responder to capture incoming barcode responses
    private var barcodeResponder: BarcodeCommand = BarcodeCommand()

    // A 'Dictionary' lookup for the unique transponders seen
    private var uniqueTransponders: MutableMap<String, TransponderData> =
       mutableMapOf<String, TransponderData>()

    // A MutableMap to gather the current scanned tag info,
    // Used to build the TagData object using the fromMap method
    private var newTagDataMap: MutableMap<String, Any?> = mutableMapOf<String, Any?>()

    //Scan tracking time variables to calculate Read Rate
    private var startTime: Long = 0
    private var finishTime: Long = 0
    private var firstTagTime: Long = 0
    private var lastTagTime: Long = 0
    private var inventoryTagCount: Long = 0

    // Stateflows for Scan Stream
    private var _tagDataScanState = MutableStateFlow<List<TagData>>(emptyList())

    override val tagDataScanState: StateFlow<List<TagData>>
        get() = _tagDataScanState.asStateFlow()


    init {
            initializeTagScan()
    }

     fun initializeTagScan() {

        //Set Audible Alert (Beep) duration - can be modified to use saved preferences
        alertCommand = AlertCommand()
        alertCommand.setDuration(AlertDuration.SHORT)

        // This is the command that will be used to perform configuration changes and inventories
        inventoryCommand.setResetParameters(TriState.YES)

        // Handle the alerts in the App - Not wrking correctly
        inventoryCommand.setUseAlert(TriState.NO)

        // Use an InventoryCommand as a responder to capture all incoming inventory responses
        // Also capture the responses that were not from App commands
        inventoryResponder.setCaptureNonLibraryResponses(true)

        // Defining the delegate to notify when each transponder is seen
        inventoryResponder.setTransponderReceivedDelegate(object: ITransponderReceivedDelegate {
            override fun transponderReceived(transponder: TransponderData, moreAvailable: Boolean) {
                // Clear the newTagDataMap from previous tags
                newTagDataMap.clear()

                // If tagCount set to 0
                if (!anyTagSeen) {
                    firstTagTime = System.nanoTime()
                }
                inventoryTagCount += 1

                // Transponder with EPC seen to capture
                if (transponder.getEpc() != null) {
                    anyTagSeen = true

                    if (!(uniquesOnly && uniqueTransponders.containsKey(transponder.getEpc()))) {
                        newTagDataMap.put("epc", transponder.getEpc())

                        if (transponder.getTidData() != null) {
                            newTagDataMap.put("tidData", HexEncoding.bytesToString(transponder.getTidData()))
                        }

                        if (isInfoRequested) {
                            newTagDataMap.put("rssi", transponder.getRssi())
                            newTagDataMap.put("rssiPercent", transponder.getRssiPercent())
                            newTagDataMap.put("pc", transponder.getPc())
                            newTagDataMap.put("crc", transponder.getCrc())
                            newTagDataMap.put("phase", transponder.getPhase())
                            newTagDataMap.put("channelFrequency", transponder.getChannelFrequency())
                        }

                        //Create a TagData Object from newTagMap for uniformity
                        var tagData = TagData.fromMap(newTagDataMap)

                        Log.d(TAG, "in TransponderReceivedDelegate = ${tagData.toString()}")

                        // If new tagdata is not in the mutableState flow already,
                        // add the tag to the mutable state flow for the stream collector
                        _tagDataScanState.update{
                                tags -> if(tagData in tags) tags else tags + tagData
                        }

                        // Remember this transponder as it has not been seen before
                        if (uniquesOnly) {
                            uniqueTransponders.put(newTagDataMap["epc"].toString(), transponder)
                        }
                    }
                }
                if (!moreAvailable) {
                    lastTagTime = System.nanoTime()
                    Log.d("TagCount", String.format("Tags seen: %s", tagsSeen))
                }
            }
        })

        inventoryResponder.setResponseLifecycleDelegate(object : ICommandResponseLifecycleDelegate {
            override fun responseBegan() {
                //ReInitializing the tagSeen, times, and taCount to start a new scan
                anyTagSeen = false
                startTime = System.nanoTime()
                // Default to inventory start time until a Tag is actually seen
                firstTagTime = System.nanoTime()
                inventoryTagCount = 0

            }

            override fun responseEnded() {
                finishTime = System.nanoTime()

                if(anyTagSeen) {
                    // To avoid continuously running the buzzer on 11xx series Readers
                    // Ensure no new sound until after least (short) tone has finished
                    // Note: 21xx series readers do not need this
                    if(System.nanoTime() - alertLastIssueTime > alertRepeatDelayInMs) {
                        getCommander().executeCommand(alertCommand)
                        alertLastIssueTime = System.nanoTime()
                    }
                } else {
                    // No tags were seen but a value is needed to calculate read rate
                    lastTagTime = System.nanoTime()
                }

                // Send on any messages
                for (msg in inventoryResponder.getMessages()) {
                    /// [TODO]  Collector goes here
                    Log.d(TAG, "InventoryResponder message - ${msg.toString()}")
                }

                if(continuousScanEnabled) {
                    // Issue another asynchronous scan
                    getCommander().executeCommand(inventoryCommand)
                } else {
                    if(!anyTagSeen && inventoryCommand.getTakeNoAction() !== TriState.YES) {
                        /// [TODO]  CoRoutine handler goes here

                    }
                    inventoryCommand.setTakeNoAction(TriState.NO)
                }

                if(inventoryTagCount > 0) {
                    val tagDuration = (lastTagTime - firstTagTime).toDouble()
                    val tagDurationNs = tagDuration / 1.0e9
                    val tagReadRate = inventoryTagCount / tagDurationNs

                    /// [TODO]  CoRoutine handler goes here
                    Log.d(TAG, "InventoryResponder - tagReadRate - ${tagReadRate.toString()}")

                }
            }
        })

        // This command is used to capture barcode responses
        barcodeResponder.setCaptureNonLibraryResponses(true)
        barcodeResponder.setUseEscapeCharacter(TriState.YES)
        barcodeResponder.setBarcodeReceivedDelegate(object : IBarcodeReceivedDelegate {
            override fun barcodeReceived(barcode: String?) {

                /// [TODO]  Collector goes here
                var msg: String? = "BC: " + barcodeResponder.getData()

                // Include additional information when present - Series 3 readers only
                if (barcodeResponder.getSymbology() != null) {
                    msg = java.lang.String.format(
                        Locale.US,
                        "BC: %s (%s%s)",
                        barcodeResponder.getSymbology().getName(),
                        barcodeResponder.getSymbology().getCode(),
                        barcodeResponder.getSymbology().getModifier()
                    )
                    /// [TODO]  Collector goes here
                }
            }
        })
    }


    override fun getCommander(): AsciiCommander {
        return AsciiCommander.sharedInstance()
    }


    override fun isConnected(): Boolean {
        return getCommander().isConnected()
    }


    override fun isEnabled(): Boolean {
        return enabled
    }


    override fun setEnabled(state: Boolean) {
        val previousState = enabled
        enabled = state

        Log.d(TAG, "in setEnabled -> ${previousState} - ${enabled}")

        // Update the commander for state changes
        if(previousState != state) {
            Log.d(TAG, "in setEnabled -> differing states")
            if( enabled ) {
                Log.d(TAG, "in setEnabled ->  if -> enabled")
                // Listen for transponders
                getCommander().addResponder(inventoryResponder)
                // Listen for barcodes
                getCommander().addResponder(barcodeResponder)
                Log.d(TAG, "in setEnabled ->  if -> enabled post responders")
            } else {
                if (continuousScanEnabled) {
                    scanStop();
                }
                // Stop listening for transponders
                getCommander().removeResponder(inventoryResponder)
                // Stop listening for barcodes
                getCommander().removeResponder(barcodeResponder)
            }
        }
    }

    override fun uniquesOnly(): Boolean {
        return uniquesOnly
    }

    override fun setUniquesOnly(value: Boolean) {
        uniquesOnly = value
    }

    /**
     * @return true if the tag info (CRC, etc...) will be requested
     */
    override fun isInfoRequested(): Boolean {
        return isInfoRequested
    }

    /**
     * Controls the tag info requested
     * @param infoRequested true to request the tag info (CRC, etc...)
     */
    override fun setInfoRequested(infoRequested: Boolean) {
        isInfoRequested = infoRequested
    }

    /**
     * The current link profile
     * @return the link profile number
     */
    override fun getLinkProfile(): Int {
        return linkProfile
    }

    /**
     * Set the link profile
     * @param linkProfile the link profile number
     */
    override fun setLinkProfile(newLinkProfile: Int) {
        linkProfile = newLinkProfile
    }

    /**
     * @return the maximum number of tags per inventory action
     */
    override fun getMaximumTagsPerScan(): Int {
        return maximumTagsPerScan
    }

    /**
     * Set the maximum number of tags per inventory action
     * @param maximumTagsPerInventory the maximum tags to set
     */
    override fun setMaximumTagsPerScan(newMaximumTagsPerScan: Int) {
        maximumTagsPerScan = newMaximumTagsPerScan
    }

    // The inventory command configuration
    override fun getCommand(): InventoryCommand {
        return inventoryCommand
    }

    //
    // Reset the reader configuration to default command values
    //
    override fun resetDevice() {
        if(getCommander().isConnected()) {
            var fdCommand: FactoryDefaultsCommand = FactoryDefaultsCommand()
            fdCommand.setResetParameters(TriState.YES);
            getCommander().executeCommand(fdCommand);
        }
    }

    //
    // Perform an inventory scan with the current command parameters
    //
    override fun scan() {
        testForAntenna()
        if (getCommander().isConnected()) {
            inventoryCommand.setTakeNoAction(TriState.NO)
            getCommander().executeCommand(inventoryCommand)
        }
    }

    //
    // Start the continuous inventory scan with the current command parameters
    //
    override fun scanStart() {
        testForAntenna()
        if(getCommander().isConnected()) {

            continuousScanEnabled = true
            inventoryCommand.setTakeNoAction(TriState.NO)
            continuousScanJob = CoroutineScope(Dispatchers.IO).launch {
                try {
                    getCommander().executeCommand(inventoryCommand)
                    while (continuousScanEnabled) {
                        Log.d(TAG, "continuousScanEbaled: true")
                    }
                } catch (e:CancellationException) {
                    Log.d(TAG, "Scan Job was cancelled - ${e}")
                    throw e
                } catch (e:Exception) {
                    Log.d(TAG, "Scan Job Message: ${e}")
                }
            }
        }
    }

    //
    // Stop the continuous inventory scan
    //
    override fun scanStop() {

        //Set scan setting for reader
        continuousScanEnabled = false

        //Collaboritively Cancel Scan Coroutine
        continuousScanJob.cancel()
        inventoryCommand.setTakeNoAction(TriState.YES)

        //Abort current Scan
        if(getCommander().isConnected()) {
            getCommander().executeCommand(AbortCommand())
        }
    }

    //
    // Update the reader configuration from the command
    // Call this after each change to the model's command
    //
    override fun updateConfiguration() {
        if(getCommander().isConnected()) {
            try {
                inventoryCommand.setTakeNoAction(TriState.YES)

                // configure the type of scan reports
                inventoryCommand.setIncludeTransponderRssi(TriState.from(isInfoRequested()))
                inventoryCommand.setIncludeChecksum(TriState.from(isInfoRequested()))
                inventoryCommand.setIncludePC(TriState.from(isInfoRequested()))
                inventoryCommand.setIncludeDateTime(TriState.from(isInfoRequested()))

                // Only Series 3 readers - older readers will ignore this parameter
                inventoryCommand.setHaltOnTags(maximumTagsPerScan)

                Log.d(TAG, "AndroidTagController -> updateConfiguration -> post executeCommand")

                // Configure the link profile if needed
                if (getCommander().getDeviceProperties().getLinkProfile() != linkProfile) {
                    Log.d(TAG, "AndroidTagController -> updateConfiguration -> pre LinkProfileCommand -1")

                    var lpCommand : LinkProfileCommand = LinkProfileCommand.synchronousCommand()

                    Log.d(TAG, "AndroidTagController -> updateConfiguration -> pre LinkProfileCommand -2")

                    lpCommand.setProfile(linkProfile)

                    Log.d(TAG, "AndroidTagController -> updateConfiguration -> pre LinkProfileCommand -3")

                    getCommander().executeCommand(lpCommand)

                    Log.d(TAG, "AndroidTagController -> updateConfiguration -> pre LinkProfileCommand -4")

                    // Refresh Device Properties with new linkProfile
                    getCommander().updateDeviceProperties()
                }

                if (getCommander().getDeviceProperties().getInformationCommand().getAsciiProtocol().startsWith(("3"))) {
                    // Workaround for slow performance due to SD-Card logging issues in early Series 3 firmware
                    // Turn off the logging!
                    val rlCommand: ReadLogFileCommand = ReadLogFileCommand.synchronousCommand()
                    rlCommand.setTakeNoAction(TriState.YES)
                    rlCommand.setCommandLoggingEnabled(TriState.NO)
                    getCommander().executeCommand(rlCommand)
                }
            } catch (e: Exception) {
                Log.d(TAG, "Exception: ${e.message.toString()}")
            }
        }
    }

    //
    // Test for the presence of the antenna
    //
    override fun testForAntenna() {
        try {
            if(getCommander().isConnected()) {
                Log.d(TAG, "in testForAntenna")

                val testCommand: InventoryCommand = InventoryCommand.synchronousCommand()
                testCommand.setTakeNoAction(TriState.YES)
                getCommander().executeCommand(testCommand)

                Log.d(TAG, "in testForAntenna - executeCommand")
                if (!testCommand.isSuccessful()) {
                   Log.d(TAG, "testForAntenna Error - code:${testCommand.getErrorCode()} - type: ${testCommand.getMessages().toString()}")
                }
            }
        } catch (e: Exception) {
            Log.d(TAG, "Exception: ${e.message.toString()}")
        }
    }

    // Reset the unique transponder list
    override fun clearUniques() {
        tagsSeen = 0;
        uniqueTransponders.clear();
    }
}