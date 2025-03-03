package com.mtg.zimble.reader.tags.domain

import com.mtg.zimble.reader.tags.data.TagData
import com.uk.tsl.rfid.asciiprotocol.commands.InventoryCommand
import com.uk.tsl.rfid.asciiprotocol.AsciiCommander
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.Job

interface TagController {
    val tagDataList: StateFlow<List<TagData>>

    fun getCommander(): AsciiCommander

    fun isConnected(): Boolean

    fun isEnabled(): Boolean
    fun setEnabled(state: Boolean) : Unit

    fun uniquesOnly(): Boolean
    fun setUniquesOnly(value: Boolean) : Unit

    fun isInfoRequested(): Boolean
    fun setInfoRequested(infoRequested: Boolean): Unit

    fun getLinkProfile(): Int
    fun setLinkProfile(newLinkProfile: Int): Unit

    fun getMaximumTagsPerScan(): Int
    fun setMaximumTagsPerScan(newMaximumTagsPerScan: Int): Unit

    fun getCommand(): InventoryCommand

    fun resetDevice(): Unit

    fun updateConfiguration(): Unit

    fun scan(): Unit

    fun scanStart(): Unit
    fun scanStop(): Unit

    fun testForAntenna(): Unit

    fun clearUniques(): Unit

}