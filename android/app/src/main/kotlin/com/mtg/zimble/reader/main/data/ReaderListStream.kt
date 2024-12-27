package com.mtg.zimble.reader.main.data

import io.flutter.plugin.common.EventChannel

import com.uk.tsl.rfid.asciiprotocol.AsciiCommander


class ReaderListStream(): EventChannel.StreamHandler {

    private var _btListEventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        println("stream Handler - onListen")
        _btListEventSink = events;
        //getBTReaderList()
    }

    override fun onCancel(arguments: Any?) {
        println("stream handler - onCancel")
        _btListEventSink = null;
    }


    /**
     * @return the current AsciiCommander
     */
    fun getCommander(): AsciiCommander? {
        return AsciiCommander.sharedInstance()
    }

}