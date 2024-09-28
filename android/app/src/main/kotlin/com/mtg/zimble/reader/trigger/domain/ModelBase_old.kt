

package com.mtg.zimble.reader.trigger.domain
/*
//import kotlinx.coroutines.GlobalScope
//import kotlinx.coroutines.flow.StateFlow
import android.os.AsyncTask
import android.util.Log

import kotlinx.datetime.Clock
import kotlinx.datetime.Instant

import com.uk.tsl.rfid.asciiprotocol.AsciiCommander


class ModelBase {
    //
    private var TAG = "ModelBase"

    private var commander: AsciiCommander? = getCommander()
    private var taskRunner: Job = null
    private var mLastTaskExecutionDuration: Double = 0.0

    val clock: Clock = Clock.System
    private var mTaskStartTime: Instant? = null


    private fun getCommander(): AsciiCommander {
        return AsciiCommander.sharedInstance()
    }


/**
     * @return the error as an exception or null if none
     */
    fun error(): Exception? {
        return mException
    }

    /**
     * @param e the error as an exception
     */
    protected fun setError(e: Exception?) {
        mException = e
    }

    val taskExecutionDuration: Double
        /**
         * @return the current execution duration if a task is running otherwise the duration of the last task
         */
        get() {
            if (mLastTaskExecutionDuration >= 0.0) {
                return mLastTaskExecutionDuration
            } else {
                val now: Instant = clock.now()
                return (now - mTaskStartTime) / 1000.0
            }
        }

    /**
     * Execute the given task
     *
     * The busy state is notified to the client
     *
     * Tasks should throw an exception to indicate (and return) error
     *
     * @param task the Runnable task to be performed
     */
    @Throws(ModelException::class)
    fun performTask(task: Runnable) {
        val rTask = task

        if (commander == null) {
            throw (ModelException("There is no AsciiCommander set for this model!"))
        } else {
            mLastTaskExecutionDuration = -1.0
            mTaskStartTime = clock.now()

            taskRunner = async {
                try {
                    taskException = null

                    rTask.run()
                } catch (e: Exception) {
                    taskException = e
                }
                return null
            }

            val taskResult = taskRunner.await()

                    override fun onPostExecute(result: Void?) {
                        super.onPostExecute(result)
                        taskRunner = null
                        this.isBusy = false


                        // Update the time taken
                        val finishTime: Instant = clock.now()
                        mLastTaskExecutionDuration =
                            (finishTime - mTaskStartTime) / 1000.0

                        if (D) Log.i(
                            javaClass.name,
                            java.lang.String.format(
                                "Time taken (ms): %d %.2f",
                                finishTime.getTime() - mTaskStartTime.time,
                                mLastTaskExecutionDuration
                            )
                        )
                    }
                }

                try {

                        // Ensure the tasks are executed serially whatever newer API versions may choose by default
                        taskRunner.executeOnExecutor(
                            AsyncTask.SERIAL_EXECUTOR,
                            *null as Array<Void?>?
                        )
                        // Tasks will be executed concurrently on API < 11
                        taskRunner.execute(*null as Array<Void?>?)
                } catch (e: Exception) {
                    mException = e
                }
            }
        }
    }

    companion object {
        // Debugging
        internal val D: Boolean = BuildConfig.DEBUG

        // Model busy state changed message
        const val BUSY_STATE_CHANGED_NOTIFICATION: Int = 1
        const val MESSAGE_NOTIFICATION: Int = 2
    }
}

/*
fun <P, R> CoroutineScope.executeAsyncTask(
    onPreExecute: () -> Unit,
    doInBackground: () -> R,
    onPostExecute: (R) -> Unit,
    onProgressUpdate: (P) -> Unit
) = launch {
    onPreExecute() // runs in Main Thread
    val result = withContext(Dispatchers.IO) {
        doInBackground() // runs in background thread without blocking the Main Thread
    }
    onPostExecute(result) // runs in Main Thread
}
*/
*/