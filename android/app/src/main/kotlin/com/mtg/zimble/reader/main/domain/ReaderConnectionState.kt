package com.example.untitled.reader.main.domain

import android.util.Log

import com.uk.tsl.rfid.asciiprotocol.device.Reader
import com.uk.tsl.rfid.asciiprotocol.device.ReaderManager

/**
 * Activity demonstrating the ReaderManager class and how to auto detect ePop-Loq Readers
 * and use the DeviceListActivity to select BT Readers
 */
class ReaderConnectionState ()
{
    var TAG = "ReaderConnectionState"

    // The Reader currently in use
    private var mReader: Reader? = null

    /*
    // ReaderList Observers
    var mAddedObserver = object Observable.Observer<Reader>() {
        override fun update(observable: Observable<Reader>?, reader: Reader?) {
            // See if this newly added Reader should be used
            AutoSelectReader(true)
        }
    }

    var mUpdatedObserver = object Observable.Observer<Reader>() {
        override fun update(observable: Observable<Reader>, reader: Reader) {
        }
    }

    var mRemovedObserver = object Observable.Observer<Reader>(
    ) {
        override fun update(observable:Observable<Reader>, reader:Reader) {
            // Was the current Reader removed
            if (reader === mReader) {
                mReader = null

                // Stop using the old Reader
                getCommander()?.setReader(mReader)
            }
        }
    }

     */


    init {
        Log.d(TAG, "${ReaderManager.sharedInstance().getReaderList().readerAddedEvent()}")
    }

        /*

        ReaderManager.sharedInstance().getReaderList().readerAddedEvent().addObserver(mAddedObserver)
        ReaderManager.sharedInstance().getReaderList().readerUpdatedEvent().addObserver(mUpdatedObserver)
        ReaderManager.sharedInstance().getReaderList().readerRemovedEvent().addObserver(mRemovedObserver)


    }



    protected fun close() {
        // Remove observers for changes
        ReaderManager.sharedInstance().getReaderList().readerAddedEvent().removeObserver(mAddedObserver)
        ReaderManager.sharedInstance().getReaderList().readerUpdatedEvent().removeObserver(mUpdatedObserver)
        ReaderManager.sharedInstance().getReaderList().readerRemovedEvent().removeObserver(mRemovedObserver)
    }



    //
    // Select the Reader to use and reconnect to it as needed
    //
    private fun AutoSelectReader(attemptReconnect:Boolean) {
        val readerList:ObservableReaderList? = ReaderManager.sharedInstance().getReaderList()
        var usbReader: Reader? = null
        if (readerList?.list()?.size >= 1) {
            // Currently only support a single USB connected device so we can safely take the
            // first CONNECTED reader if there is one
            for (reader:Reader? in readerList?.list())  {
                if (reader?.hasTransportOfType(TransportType.USB)) {
                    usbReader = reader
                    break
                }
            }
        }

        if (mReader == null) {
            if (usbReader != null) {
                // Use the Reader found, if any
                mReader = usbReader
                getCommander()?.setReader(mReader)
            }
        }
        else {
            // If already connected to a Reader by anything other than USB then
            // switch to the USB Reader
            val activeTransport: IAsciiTransport? = mReader.getActiveTransport()
            if ((activeTransport != null) && (activeTransport.type() !== TransportType.USB) && (usbReader != null)) {
                mReader.disconnect()
                mReader = usbReader

                // Use the Reader found, if any
                getCommander()?.setReader(mReader)
            }
        }

        // Reconnect to the chosen Reader
        if (((mReader != null
                    ) && !mReader.isConnecting()
                    && (mReader.getActiveTransport() == null || mReader.getActiveTransport().connectionStatus().value() === ConnectionState.DISCONNECTED))) {
            // Attempt to reconnect on the last used transport unless the ReaderManager is cause of OnPause (USB device connecting)
            if (attemptReconnect) {
                if (mReader.allowMultipleTransports() || mReader.getLastTransportType() == null) {
                    // Reader allows multiple transports or has not yet been connected so connect to it over any available transport
                    mReader.connect()
                }
                else {
                    // Reader supports only a single active transport so connect to it over the transport that was last in use
                   mReader.connect(mReader.getLastTransportType())
                }
            }
        }
    }





    /**
     * @return the current AsciiCommander
     */
    protected fun getCommander(): AsciiCommander? {
        return AsciiCommander.sharedInstance()
    }
*/



}
