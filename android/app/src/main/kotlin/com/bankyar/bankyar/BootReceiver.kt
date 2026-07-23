package com.bankyar.bankyar

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * Recovers background capabilities and work scheduling when the device boots
 * or the package is updated/reinstalled.
 */
class BootReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "BootReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(TAG, "Boot Completed or Package Replaced received: $action")

        if (Intent.ACTION_BOOT_COMPLETED == action || Intent.ACTION_MY_PACKAGE_REPLACED == action) {
            try {
                // Self-healing: Start background daemon service to restore observation status
                val serviceIntent = Intent(context, BackgroundService::class.java).apply {
                    this.action = BackgroundService.ACTION_INITIALIZE_STATUS
                }
                context.startService(serviceIntent)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start service on boot: ${e.message}", e)
            }
        }
    }
}
