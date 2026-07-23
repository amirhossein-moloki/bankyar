package com.bankyar.bankyar

import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters

/**
 * Background WorkManager Worker scheduled to run periodic incremental synchronizations
 * of SMS inboxes and restore resilience layers.
 */
class SmsSyncWorker(context: Context, params: WorkerParameters) : CoroutineWorker(context, params) {
    companion object {
        private const val TAG = "SmsSyncWorker"
    }

    override suspend fun doWork(): Result {
        Log.d(TAG, "WorkManager periodic background SMS sync trigger initiated.")
        try {
            // Trigger self-healing background synchronization by launching the foreground service
            val intent = Intent(applicationContext, BackgroundService::class.java).apply {
                action = BackgroundService.ACTION_INITIALIZE_STATUS
            }
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                applicationContext.startForegroundService(intent)
            } else {
                applicationContext.startService(intent)
            }
            return Result.success()
        } catch (e: Exception) {
            Log.e(TAG, "Background sync worker failed: ${e.message}", e)
            return Result.retry()
        }
    }
}
