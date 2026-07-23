package com.bankyar.bankyar

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterCallbackInformation

/**
 * Android Foreground Service to maintain active background synchronization
 * and secure local processing of banking SMS streams.
 */
class BackgroundService : Service() {
    companion object {
        private const val TAG = "BackgroundService"
        private const val NOTIFICATION_ID = 101
        private const val CHANNEL_ID = "bankyar_sync_channel"

        const val ACTION_PROCESS_SMS = "com.bankyar.app.PROCESS_SMS"
        const val ACTION_INITIALIZE_STATUS = "com.bankyar.app.INITIALIZE_STATUS"
    }

    private var backgroundEngine: FlutterEngine? = null
    private var backgroundChannel: MethodChannel? = null

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Creating BackgroundService")
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "BackgroundService onStartCommand: action = ${intent?.action}")

        // Promotes the service to a foreground service to guarantee execution safety
        startForeground(NOTIFICATION_ID, buildNotification())

        if (intent != null) {
            when (intent.action) {
                ACTION_PROCESS_SMS -> {
                    val sender = intent.getStringExtra("sender") ?: ""
                    val body = intent.getStringExtra("body") ?: ""
                    val timestamp = intent.getLongExtra("timestamp", 0L)
                    Log.d(TAG, "Processing background SMS from $sender: length = ${body.length}")

                    // Securely forward processing parameters to active background Flutter isolate
                    dispatchSmsToBackgroundIsolate(sender, body, timestamp)
                }
                ACTION_INITIALIZE_STATUS -> {
                    Log.d(TAG, "Initializing back-end resilience status.")
                }
            }
        }

        // REDELIVER_INTENT provides robust protection against OS-initiated process terminations
        return START_REDELIVER_INTENT
    }

    override fun onDestroy() {
        backgroundEngine?.destroy()
        backgroundEngine = null
        backgroundChannel = null
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun dispatchSmsToBackgroundIsolate(sender: String, body: String, timestamp: Long) {
        val prefs = getSharedPreferences("bankyar_bg_prefs", Context.MODE_PRIVATE)
        val handle = prefs.getLong("bg_callback_handle", 0L)
        if (handle == 0L) {
            Log.w(TAG, "No background callback handle registered from Dart. Ignoring dispatch.")
            return
        }

        try {
            if (backgroundEngine == null) {
                backgroundEngine = FlutterEngine(applicationContext)
                val callbackInfo = FlutterCallbackInformation.lookupCallbackInformation(handle)
                if (callbackInfo == null) {
                    Log.e(TAG, "Failed to find callback information for handle: $handle")
                    return
                }

                backgroundChannel = MethodChannel(backgroundEngine!!.dartExecutor.binaryMessenger, "com.bankyar.app/background_channel")

                val loader = FlutterInjector.instance().flutterLoader()
                loader.startInitialization(applicationContext)
                loader.ensureInitializationComplete(applicationContext, null)
                val bundlePath = loader.findAppBundlePath() ?: ""

                val args = DartExecutor.DartCallback(
                    assets,
                    bundlePath,
                    callbackInfo
                )
                backgroundEngine!!.dartExecutor.executeDartCallback(args)
            }

            // Dispatch SMS payload to background isolate via MethodChannel
            val payload = mapOf(
                "sender" to sender,
                "body" to body,
                "timestamp" to timestamp
            )
            backgroundChannel?.invokeMethod("onBackgroundSms", payload)
            Log.i(TAG, "SMS payload dispatched to background isolate method channel successfully.")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize or dispatch to background Flutter isolate: ${e.message}", e)
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "پشتیبان پس‌زمینه بانک‌یار"
            val descriptionText = "تضمین فعالیت پس‌زمینه تحلیل تراکنش‌ها"
            val importance = NotificationManager.IMPORTANCE_MIN
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun buildNotification(): Notification {
        val title = "بانک‌یار فعال است"
        val text = "پایش امن و آفلاین تراکنش‌های بانکی در پس‌زمینه"

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }

        return builder
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setOngoing(true)
            .build()
    }
}
