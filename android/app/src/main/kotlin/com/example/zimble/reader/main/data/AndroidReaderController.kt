package com.example.zimble.reader.main.data

import android.content.Context
import android.util.Log

import com.example.zimble.reader.main.domain.ReaderController
import com.example.zimble.connection.bluetooth.domain.BluetoothDeviceEntity

import com.uk.tsl.rfid.asciiprotocol.AsciiCommander
import com.uk.tsl.rfid.asciiprotocol.device.ObservableReaderList
import com.uk.tsl.rfid.asciiprotocol.device.Reader
import com.uk.tsl.rfid.asciiprotocol.device.ReaderManager
import com.uk.tsl.rfid.asciiprotocol.device.TransportType

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel


class AndroidReaderController() : ReaderController {
    //define Method and Event Channel variables
    private val EVENT_CHANNEL_READER_BT_LIST = "mtg_rfid_event/reader/bt_list"
    private var _eventChannelBTList: EventChannel? = null
    private var _btListStreamHandler: ReaderListStream? = null

    private val TAG = "AndroidReaderController"
    private val D = true

    // Intent request codes
    val SELECT_DEVICE_REQUEST = 0x5344


    /// Return Intent extra
    var EXTRA_DEVICE_INDEX = "tsl_device_index"
    var EXTRA_DEVICE_ACTION = "tsl_device_action"

    /// Actions requested for the chosen device
    var DEVICE_CONNECT = 1
    var DEVICE_CHANGE = 2
    var DEVICE_DISCONNECT = 3


    override public fun getBTReaderList() {
        var readerList: ObservableReaderList = ReaderManager.sharedInstance().getReaderList()
        var selectedReader: Reader = Reader()
        var tempReader : Reader = Reader()

        Log.d(TAG, "ReaderList - ${readerList.list()}")
        //Log.d("LOGGER", "ReaderList.list().size - ${readerList}")

        Log.d(TAG, "ReaderListSize - ${readerList.list().size}")
        if (readerList.list().size > 0) {
            for (x in (0..readerList.list().size - 1)) {
                tempReader = readerList.list().get(x)
                Log.d(TAG, "${x} - ${tempReader.getDisplayName()}")
                Log.d(TAG, "${x} - ${tempReader.getDeviceProperties()}")
                Log.d(TAG, "${x} - ${tempReader.getDisplayInfoLine()}")
                Log.d(TAG, "${x} - ${tempReader.getSerialNumber()}")
                Log.d(TAG, "${x} - ${tempReader.getDisplayTransportLine()}")
                Log.d(TAG, "${x} - ${tempReader.isConnected()}")
            }
        }
    }

    override fun getReaderInfoByMAC(device: BluetoothDeviceEntity): Map<String, Any?> {
        var readerList: ObservableReaderList = ReaderManager.sharedInstance().getReaderList()
        var tempReader : Reader = Reader()
        var readerInfo = mutableMapOf<String, Any?>()

        if (readerList.list().size > 0) {
            for (x in (0..readerList.list().size - 1)) {
                tempReader = readerList.list().get(x)

                if (tempReader.getDisplayInfoLine().replace("MAC: ", "") == device.address) {
                    readerInfo["DisplayName"] = tempReader.getDisplayName()
                    readerInfo["DeviceProperties"] = tempReader.getDeviceProperties()
                    readerInfo["DisplayInfoLine"] = tempReader.getDisplayInfoLine()
                    readerInfo["SerialNumber"] = tempReader.getSerialNumber()
                    readerInfo["DisplayTransportLine"] = tempReader.getDisplayTransportLine()
                    readerInfo["isConnected"] = tempReader.isConnected()
                }
            }
        }

        return readerInfo
    }

    override fun getReaderInfoByIndex(deviceIndex: Int): Map<String, Any?> {
        var readerList: ObservableReaderList = ReaderManager.sharedInstance().getReaderList()
        var tempReader : Reader = Reader()
        var readerInfo = mutableMapOf<String, Any?>()

        if (readerList.list().size >= deviceIndex) {
            tempReader = readerList.list().get(deviceIndex)

            readerInfo["DisplayName"] = tempReader.getDisplayName()
            readerInfo["DeviceProperties"] = tempReader.getDeviceProperties()
            readerInfo["DisplayInfoLine"] = tempReader.getDisplayInfoLine()
            readerInfo["SerialNumber"] = tempReader.getSerialNumber()
            readerInfo["DisplayTransportLine"] = tempReader.getDisplayTransportLine()
            readerInfo["isConnected"] = tempReader.isConnected()
        }

        return readerInfo
    }

    override fun getReaderIndexByMAC(device: BluetoothDeviceEntity): Int? {
        var readerList: ObservableReaderList = ReaderManager.sharedInstance().getReaderList()
        var tempReader : Reader = Reader()
        var readerIndex: Int? = null

        if (readerList.list().size > 0) {
            for (x in (0..readerList.list().size - 1)) {
                tempReader = readerList.list().get(x)
                if (tempReader.getDisplayInfoLine().replace("MAC: ", "") == device.address) {
                    readerIndex = x
                }
            }
        }

        return readerIndex
    }

    override fun connectToSDKReader(device: BluetoothDeviceEntity) : Boolean {
        Log.d(TAG, "In connectToSDKReader")
        Log.d(TAG, "${device.address}")

        var readerIndex: Int? = getReaderIndexByMAC(device)
        var readerToConnect: Reader = ReaderManager.sharedInstance().getReaderList().list().get(readerIndex!!)
        if(readerToConnect.connect() == true) {
            getCommander()?.setReader(readerToConnect)

            //wait for DeviceProperties to be set by the reader
            while (getCommander()?.getDeviceProperties()?.getModel() == null) {
                Thread.sleep(500)
            }

            Log.d(TAG, "${getCommander()?.getDeviceProperties()?.getModel()}")
            return true
        } else {
            return false
        }
    }

    override public fun disconnectFromReader(device: BluetoothDeviceEntity) : Boolean{
        var readerIndex: Int? = getReaderIndexByMAC(device)
        var readerToDisconnect: Reader = ReaderManager.sharedInstance().getReaderList().list().get(readerIndex!!)

        readerToDisconnect.disconnect()
        return true
    }

    override fun getConnectedReaderName(): String? {
        var connectedDeviceName = getCommander()?.getConnectedDeviceName()

        return connectedDeviceName
    }

    override fun getAllDeviceProperties(): Map<String, Any?> {
        var devicePropertiesMap = mutableMapOf<String, Any?>()

        var commander: AsciiCommander? = getCommander()

        devicePropertiesMap["linkProfile"] = commander?.getDeviceProperties()?.getLinkProfile()
        devicePropertiesMap["maximumCarrierPower"] = commander?.getDeviceProperties()?.getMaximumCarrierPower()
        devicePropertiesMap["minimumCarrierPower"] = commander?.getDeviceProperties()?.getMinimumCarrierPower()
        devicePropertiesMap["model"] = commander?.getDeviceProperties()?.getModel()
        devicePropertiesMap["isFastIdSupported"] = commander?.getDeviceProperties()?.isFastIdSupported()
        devicePropertiesMap["isQTModeSupported"] = commander?.getDeviceProperties()?.isQTModeSupported()

        return devicePropertiesMap
    }

    override fun getReaderDeviceProperties(): ReaderDevicePropertiesData {
        var commander: AsciiCommander? = getCommander()

        var devicePropertiesMap = ReaderDevicePropertiesData(
            linkProfile = commander?.getDeviceProperties()?.getLinkProfile(),
            maximumCarrierPower = commander?.getDeviceProperties()?.getMaximumCarrierPower(),
            minimumCarrierPower = commander?.getDeviceProperties()?.getMinimumCarrierPower() ,
            model = commander?.getDeviceProperties()?.getModel(),
            isFastIdSupported = commander?.getDeviceProperties()?.isFastIdSupported(),
            isQTModeSupported = commander?.getDeviceProperties()?.isQTModeSupported(),
        );
        return devicePropertiesMap
    }




    override public fun setupReaderManager(context: Context, messenger: BinaryMessenger) {
        //var mAddedObserver = addedObserver(selectedReader)
        //var mUpdatedObserver = updatedObserver(selectedReader)
        //var mRemovedObserver = removedObserver(selectedReader)

        var commander = AsciiCommander.sharedInstance();

        var selectedReader: Reader = Reader()
        var tempReader : Reader = Reader()

        Log.d(TAG, "RM applicationContext - ${context.applicationContext}");

        Log.d(TAG, "in reader manager")


        //ReaderManager.sharedInstance().initialiseList()

        Log.d(TAG, "in reader manager - 2")

        _eventChannelBTList = EventChannel(messenger, EVENT_CHANNEL_READER_BT_LIST)
        _btListStreamHandler = ReaderListStream()
        _eventChannelBTList!!.setStreamHandler(_btListStreamHandler)


        Log.d(TAG, "_btListStreamHandler")
        Log.d(TAG, "${_btListStreamHandler}")


        Log.d(TAG, "readerList start")

        var readerList = ReaderManager.sharedInstance().getReaderList().list()

        Log.d(TAG, "${readerList::class.simpleName}")


        println(readerList.size)

        if(readerList.size > 0) {
            for (x in (0..readerList.size - 1)) {
                tempReader = readerList.get(x)
                Log.d(TAG, "${x} - ${tempReader.getDisplayName()}")
            }
            selectedReader = readerList.get(0)

            selectedReader.connect(TransportType.BLUETOOTH)

            Log.d(TAG, "Selected Reader SerialNo - ${selectedReader.getSerialNumber()}")

            Log.d(TAG, "Selected Reader isConnected - ${selectedReader.isConnected()}")
        }

    }

    override public fun setupReaderChannels(context: Context, messenger: BinaryMessenger) {
        var readerListStream = ReaderListStream()
    }

    override  public fun teardownReaderHandlers() {
        //readerEventChannel = null
    }

    /**
     * @return the current AsciiCommander
     */
    fun getCommander(): AsciiCommander? {
        return AsciiCommander.sharedInstance()
    }

    fun addReader(device: BluetoothDeviceEntity): Unit {
        var readerList = ReaderManager.sharedInstance()

    }

}