package com.mtg.zimble.reader.tags.data

import android.util.Log

import com.mtg.zimble.reader.tags.data.TransponderData as TransponderDataModel
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
import java.util.Locale


class AndroidTagController() : TagController {

    val TAG = "AndroidTagController"

    private var anyTagSeen: Boolean = false
    private var isEnabled: Boolean  = false
    private var continuousScanEnabled: Boolean = false
    private var uniquesOnly: Boolean = false
    private var tagsSeen: Int = 0

    private var alertLastIssueTime: Long = System.nanoTime()
    private val alertRepeatDelayInMs: Long = (400 * 1000 * 1000).toLong()
    private var alertCommand: AlertCommand = AlertCommand()

    private var isInfoRequested: Boolean = false
    private var linkProfile: Int = 0

    private var maximumTagsPerScan: Int = 0

    // The command to use as a responder to capture incoming inventory responses
    private var inventoryResponder: InventoryCommand

    // The command used to issue commands
    private var inventoryCommand: InventoryCommand

    // The command to use as a responder to capture incoming barcode responses
    private var barcodeResponder: BarcodeCommand

    // A 'Dictionary' lookup for the unique transponders seen
    private val uniqueTransponders: HashMap<String, TransponderData> =
        HashMap<String, TransponderData>()

    private var startTime: Long = 0
    private var finishTime: Long = 0
    private var firstTagTime: Long = 0
    private var lastTagTime: Long = 0
    private var inventoryTagCount: Long = 0

    private var epc: String = ""
    private var tidData: String? = null
    private var rssi: Int? = null
    private var rssiPercent: Int? = null
    private var pc: Int? = null
    private var crc: Int? = null
    private var qt: Int? = null
    private var didKill: Boolean? = null
    private var didLock: Boolean? = null
    private var channelFrequency: Int? = null
    private var phase: Int? = null
    private var timestamp: String? = null
    private var index: Int? = null
    private var accessErrorCode: String? = null
    private var backscatterErrorCode: String? = null
    private var readData: String? = null
    private var wordsWritten: Int? = null
    private var isDuplicate: Boolean? = null

    init {
        alertCommand = AlertCommand()
        alertCommand.setDuration(AlertDuration.SHORT)

        // This is the command that will be used to perform configuration changes and inventories
        inventoryCommand = InventoryCommand()
        inventoryCommand.setResetParameters(TriState.YES)

        // Handle the alerts in the App
        inventoryCommand.setUseAlert(TriState.NO)

        // Use an InventoryCommand as a responder to capture all incoming inventory responses
        inventoryResponder = InventoryCommand()

        // Also capture the responses that were not from App commands
        inventoryResponder.setCaptureNonLibraryResponses(true)

        // Notify when each transponder is seen
        inventoryResponder.setTransponderReceivedDelegate(object: ITransponderReceivedDelegate {
            override fun transponderReceived(transponder: TransponderData, moreAvailable: Boolean) {
                // If tagCount set to 0
                if (!anyTagSeen) {
                    firstTagTime = System.nanoTime()
                }
                inventoryTagCount += 1

                if (transponder.getEpc() != null) {
                    anyTagSeen = true

                    if (!(uniquesOnly && uniqueTransponders.containsKey(transponder.getEpc()))) {

                        epc = transponder.getEpc()

                        if (transponder.getTidData() != null) {
                            tidData = HexEncoding.bytesToString(transponder.getTidData())
                        }

                        if (isInfoRequested) {
                            rssi = transponder.getRssi()
                            rssiPercent = transponder.getRssiPercent()
                            pc = transponder.getPc()
                            crc = transponder.getCrc()
                            phase =  transponder.getPhase()
                            channelFrequency = transponder.getChannelFrequency()
                        }

                        var transponderData = TransponderDataModel(
                            epc = epc,
                            tidData = tidData,
                            rssi = rssi,
                            rssiPercent = rssi,
                            pc = pc,
                            crc = crc,
                            qt = qt,
                            didKill = didKill,
                            didLock = didLock,
                            channelFrequency = channelFrequency,
                            phase = phase,
                            timestamp = timestamp,
                            index = index,
                            accessErrorCode = accessErrorCode,
                            backscatterErrorCode = backscatterErrorCode,
                            readData = readData,
                            wordsWritten = wordsWritten,
                            isDuplicate = isDuplicate,
                        )

                        //// [TODO] CoRoutine handler goes here
                        Log.d(TAG, "in TransponderReceivedDelegate = ${transponderData.toString()}")


                        // Remember this transponder as it has not been seen before
                        if (uniquesOnly) {
                            uniqueTransponders[transponder.getEpc()] = transponder
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
                    /// [TODO]  CoRoutine handler goes here

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

                }
            }
        })

        // This command is used to capture barcode responses
        barcodeResponder = BarcodeCommand()
        barcodeResponder.setCaptureNonLibraryResponses(true)
        barcodeResponder.setUseEscapeCharacter(TriState.YES)
        barcodeResponder.setBarcodeReceivedDelegate(object : IBarcodeReceivedDelegate {
            override fun barcodeReceived(barcode: String?) {

                /// [TODO]  CoRoutine handler goes here
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
                    /// [TODO]  CoRoutine handler goes here
                }
            }
        })

    }


    override fun getCommander(): AsciiCommander {
        return AsciiCommander.sharedInstance()
    }

    override fun isEnabled(): Boolean {
        return isEnabled
    }

    override fun setEnabled(state: Boolean) {
        val previousState = isEnabled
        isEnabled = state

        // Update the commander for state changes
        if(previousState != state) {
            if( isEnabled ) {
                // Listen for transponders
                getCommander().addResponder(inventoryResponder)
                // Listen for barcodes
                getCommander().addResponder(barcodeResponder)
            } else {
                if (continuousScanEnabled)
                {
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

    override fun isInfoRequested(): Boolean {
        return isInfoRequested
    }

    override fun setInfoRequested(infoRequested: Boolean) {
        isInfoRequested = infoRequested
    }

    override fun getLinkProfile(): Int {
        return linkProfile
    }

    override fun setLinkProfile(newLinkProfile: Int) {
        linkProfile = newLinkProfile
    }

    override fun getMaximumTagsPerScan(): Int {
        return maximumTagsPerScan
    }

    override fun setMaximumTagsPerScan(newMaximumTagsPerScan: Int) {
        maximumTagsPerScan = newMaximumTagsPerScan
    }

    override fun getCommand(): InventoryCommand {
        return inventoryCommand
    }

    override fun resetDevice() {
        if(getCommander().isConnected()) {
            var fdCommand: FactoryDefaultsCommand = FactoryDefaultsCommand()
            fdCommand.setResetParameters(TriState.YES);
            getCommander().executeCommand(fdCommand);
        }
    }

    override fun scanStart() {
        testForAntenna()
        if(getCommander().isConnected()) {
            continuousScanEnabled = true
            inventoryCommand.setTakeNoAction(TriState.NO)

        }
    }

    override fun scanStop() {
        continuousScanEnabled = false
        inventoryCommand.setTakeNoAction(TriState.YES)

        if(getCommander().isConnected()) {
            getCommander().executeCommand(AbortCommand())
        }

    }

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

                // Configure the link profile if needed
                if (getCommander().getDeviceProperties().getLinkProfile() != linkProfile) {
                    var lpCommand : LinkProfileCommand = LinkProfileCommand.synchronousCommand()
                    lpCommand.setProfile(linkProfile)
                    getCommander().executeCommand(lpCommand)

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

    // Test for the presence of the antenna
    override fun testForAntenna() {
        if(getCommander().isConnected()) {
            val testCommand: InventoryCommand = InventoryCommand.synchronousCommand()
            testCommand.setTakeNoAction(TriState.YES)
            getCommander().executeCommand(testCommand)
            if (!testCommand.isSuccessful) {
               Log.d(TAG, "testForAntenna Error - code:${testCommand.getErrorCode()} - type: ${testCommand.getMessages().toString()}")
            }
        }
    }

    override fun clearUniques() {
        tagsSeen = 0;
        uniqueTransponders.clear();
    }
}