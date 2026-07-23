package com.bankyar.bankyar

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.util.Log

/**
 * Intercepts incoming SMS broadcasts on Android.
 * Securely extracts raw message parameters and forwards them to MainActivity
 * or BackgroundService for synchronized parsing and ingestion.
 */
class SmsReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "SmsReceiver"
        const val ACTION_SMS_RECEIVED_EVENT = "com.bankyar.app.SMS_RECEIVED_EVENT"
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            try {
                val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
                if (messages.isEmpty()) return

                // Group multi-part SMS parts by sender ID
                val sender = messages[0].displayOriginatingAddress ?: ""
                val bodyBuilder = StringBuilder()
                for (msg in messages) {
                    bodyBuilder.append(msg.displayMessageBody ?: "")
                }
                val body = bodyBuilder.toString()
                val timestamp = messages[0].timestampMillis

                Log.d(TAG, "Incoming SMS intercepted from $sender at $timestamp")

                // Broadcaster to live listeners or service
                val eventIntent = Intent(ACTION_SMS_RECEIVED_EVENT).apply {
                    putExtra("sender", sender)
                    putExtra("body", body)
                    putExtra("timestamp", timestamp)
                    setPackage(context.packageName) // Secure communication
                }
                context.sendBroadcast(eventIntent)

                // If app is not in memory, ensure BackgroundService starts to process it
                val serviceIntent = Intent(context, BackgroundService::class.java).apply {
                    action = BackgroundService.ACTION_PROCESS_SMS
                    putExtra("sender", sender)
                    putExtra("body", body)
                    putExtra("timestamp", timestamp)
                }
                context.startService(serviceIntent)
            } catch (e: Exception) {
                Log.e(TAG, "Exception parsing incoming SMS broadcast: ${e.message}", e)
            }
        }
    }
}
