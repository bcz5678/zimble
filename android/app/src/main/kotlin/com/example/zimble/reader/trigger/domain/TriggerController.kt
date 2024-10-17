package com.mtg.zimble.reader.trigger.domain

import com.mtg.zimble.reader.trigger.data.ReaderTriggerSettingsData

interface TriggerController {

    fun getReaderTriggerSettingsProperties(): ReaderTriggerSettingsData

    /*
    fun setAsyncReportingEnabled(isEnabled: Boolean): Boolean

    fun setPolledReportingEnabled(isEnabled: Boolean): Boolean

    fun resetReaderAlert(): Unit

    fun pollingUpdateCoroutine()

    fun sendStatusNotification(switchState: SwitchState?, isAsync: Boolean)
    */

}
