
//----------------------------------------------------------------------------------------------
// Copyright (c) 2013 Technology Solutions UK Ltd. All rights reserved.
//----------------------------------------------------------------------------------------------
package com.mtg.zimble.reader.trigger.data

import com.mtg.zimble.reader.trigger.domain.TriggerController

import com.uk.tsl.rfid.asciiprotocol.commands.SwitchActionCommand
import com.uk.tsl.rfid.asciiprotocol.AsciiCommander

import kotlinx.coroutines.*

import android.util.Log

class AndroidTriggerController(): TriggerController {

    private val TAG = "TriggerController"

    /**
     *  Set time interval for polling trigger reporting.
     */
    private val POLL_INTERVAL_IN_MS = 300L

    /**
     * Grab the current shared instance on AsciiCommander
     *
     * @return Reader sharedInstance, or false if no reader available
     */
    private fun getCommander(): AsciiCommander {
        return AsciiCommander.sharedInstance() // return current sharedInstance of AsciiCommander
    }

    /**
    * Get all the current trigger settings
    */

    override fun getReaderTriggerSettingsProperties(): ReaderTriggerSettingsData {
        var saCommand: SwitchActionCommand? = SwitchActionCommand.synchronousCommand()

        var triggerSettingsMap = ReaderTriggerSettingsData(
            asyncReportingEnabled = saCommand?.getAsynchronousReportingEnabled(),
            pollingReportingEnabled = false,
            doublePressAction = saCommand?.getDoublePressAction(),
            doublePressRepeatDelay = saCommand?.getDoublePressRepeatDelay(),
            hapticFeedbackEnabled = saCommand?.getHapticFeedbackEnabled(),
            readParameters = saCommand?.getReadParameters(),
            resetParameters = saCommand?.getResetParameters(),
            singlePressAction = saCommand?.getSinglePressAction(),
            singlePressRepeatDelay = saCommand?.getSinglePressRepeatDelay(),
            takeNoAction = saCommand?.getTakeNoAction(),
            implementsReadParameters = saCommand?.implementsReadParameters(),
            implementsResetParameters = saCommand?.implementsResetParameters(),
            implementsTakeNoAction = saCommand?.implementsTakeNoAction(),
            //maximumRepeatDelay = saCommand?.maximumRepeatDelay(),
            //minimumRepeatDelay = saCommand?.minimumRepeatDelay(),
        )

        return triggerSettingsMap
    }

    /*

    /**
     * Change the asynchronous reporting state and adjust switch action accordingly
     * This may fail if the reader cannot be configured
     *
     * @param isEnabled true if asynchronous reporting is to be enabled
     * @return true if the command succeeded
     */
    fun setAsyncReportingEnabled(isEnabled: Boolean): Boolean {
        var succeeded = false
        // Configure the switch actions
        val saCommand: SwitchActionCommand = SwitchActionCommand.synchronousCommand()  //switchActionCommand instance

        /**
         * Sets saCommand and resets Default
         */
        if (isEnabled) {
            /// Enable asynchronous switch state reporting
            saCommand.setAsynchronousReportingEnabled(TriState.YES)

            // Disable the default switch actions
            saCommand.setSinglePressAction(SwitchAction.OFF)
            saCommand.setDoublePressAction(SwitchAction.OFF)
        } else {
            if (!isPolledReportingEnabled) {
                // Reset default switch actions
                saCommand.setResetParameters(TriState.YES)

                resetReaderAlert()
            } else {
                // Just turn the asynchronous reporting off
                saCommand.setAsynchronousReportingEnabled(TriState.NO)
            }
        }


        try {
            // Executes command to switch to Asynchronous Reporting
            getCommander().executeCommand(saCommand)

            isAsyncReportingEnabled = isEnabled
            succeeded = true
        } catch (e: Exception) {
            // Unable to change the state
        }
        return succeeded
    }

    /**
     * Getter for asynchronous reporting state enabled
     */
    var isAsyncReportingEnabled: Boolean = false
        private set

    /**
     * Change the polled reporting state and adjust switch action accordingly
     * This may fail if the reader cannot be configure
     *
     * @param isEnabled true if polled reporting is to be enabled
     * @return true if the command succeeded
     */
    fun setPolledReportingEnabled(isEnabled: Boolean): Boolean {
        var succeeded = false
        // Configure the switch actions
        val saCommand: SwitchActionCommand = SwitchActionCommand.synchronousCommand()

        if (isEnabled) {
            // Disable the default switch actions
            saCommand.setSinglePressAction(SwitchAction.OFF)
            saCommand.setDoublePressAction(SwitchAction.OFF)

            CoroutineScope(Dispatchers.IO).launch {
                delay(POLL_INTERVAL_IN_MS)
                pollingUpdateCoroutine()
            }
        } else {
            if (!isAsyncReportingEnabled) {
                // Reset default switch actions
                saCommand.setResetParameters(TriState.YES)

                resetReaderAlert()
            }
        }

        try {
            getCommander().executeCommand(saCommand)

            isPolledReportingEnabled = isEnabled
            succeeded = true
        } catch (e: Exception) {
         //Failed -> Implement exception here
        }
        return succeeded
    }

    /**
     * Getter for the polled reporting enabled
     */
    var isPolledReportingEnabled: Boolean = false
        private set

    /**
     * Reset's the reader's switch and audible alert back to default settings
     */
    private fun resetReaderAlert() {
        // aCommand set to an insatance of AlertCommand
        val aCommand: AlertCommand = AlertCommand()

        aCommand.setResetParameters(TriState.YES)
        aCommand.setTakeNoAction(TriState.YES)
        try {
            getCommander().executeCommand(aCommand)
        } catch (e:Exception) {
            //Failure to reset - implement here
        }
    }

    /**
     * Prepare the model for first use
     */
    fun initialise() {
        // Use the SwitchResponder to monitor asynchronous switch reports
        val switchResponder: SwitchResponder = SwitchResponder()
        switchResponder.setSwitchStateReceivedDelegate(mSwitchDelegate)
        getCommander().addResponder(switchResponder)
    }

    // Forward the state changes to the current Handler (UI thread)
    private val mSwitchDelegate: ISwitchStateReceivedDelegate =
        object : ISwitchStateReceivedDelegate() {
            fun switchStateReceived(state: SwitchState?) {
                sendStatusNotification(state, true)

                // Use the alert command to indicate the type of asynchronous switch press
                // No vibration just vary the tone & duration
                if (!SwitchState.OFF.equals(state)) {
                    val aCommand: AlertCommand = AlertCommand()
                    aCommand.setResetParameters(TriState.YES)
                    aCommand.setEnableVibrator(TriState.NO)
                    aCommand.setDuration(AlertDuration.SHORT)
                    if (SwitchState.SINGLE.equals(state)) {
                        aCommand.setTone(BuzzerTone.HIGH)
                    } else if (SwitchState.DOUBLE.equals(state)) {
                        aCommand.setTone(BuzzerTone.MEDIUM)
                    }

                    // Avoid AsciiCommander execution conflicts
                    CoroutineScope(Dispatchers.IO).launch {
                        getCommander().executeCommand(aCommand)
                    }
                }
            }
        }


    private suspend fun pollingUpdateCoroutine() {
        try {
            val ssCommand: SwitchStateCommand = SwitchStateCommand.synchronousCommand()
            getCommander().executeCommand(ssCommand)
            sendStatusNotification(ssCommand.getState(), false)
        } catch (e:Exception) {
            /* failed to read - ignore */
        }

        // Schedule the next poll
        CoroutineScope(Dispatchers.IO).launch {
            delay(POLL_INTERVAL_IN_MS)
            this
        }
    }


    /**
     * Send a switch state message to the client using the current Handler
     *
     * @param switchState the state of the switch
     * @param isAsync true if the message was received asynchronously (otherwise it was from polling)
     */
    private fun sendStatusNotification(switchState: SwitchState?, isAsync: Boolean) {

        val msg: Message = mHandler.obtainMessage(
            if (isAsync) ASYNC_SWITCH_STATE_NOTIFICATION else POLLED_SWITCH_STATE_NOTIFICATION,
            switchState
        )
           //SEND TO MESSAGE HANDLERS
        if
        }
    }


    companion object {
        /**
         * Message id for an asynchronous switch state notification
         */
        const val ASYNC_SWITCH_STATE_NOTIFICATION: Int = 100

        /**
         * Message id for a polled switch state notification
         */
        const val POLLED_SWITCH_STATE_NOTIFICATION: Int = 101
    }

*/
}