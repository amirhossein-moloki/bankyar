package com.bankyar.bankyar

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.provider.Telephony
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.work.Constraints
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.BackoffPolicy
import java.util.concurrent.TimeUnit
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val PLATFORM_CHANNEL = "com.bankyar.app/platform"
    private val SMS_EVENT_CHANNEL = "com.bankyar.app/sms_events"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up MethodChannel for core platform integrations
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PLATFORM_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceInfo" -> {
                    val info = mapOf(
                        "manufacturer" to Build.MANUFACTURER,
                        "model" to Build.MODEL,
                        "brand" to Build.BRAND,
                        "sdkVersion" to Build.VERSION.SDK_INT,
                        "releaseVersion" to Build.VERSION.RELEASE
                    )
                    result.success(info)
                }
                "checkPermission" -> {
                    val permissionName = call.argument<String>("permission") ?: ""
                    val status = checkPermissionStatus(permissionName)
                    result.success(status)
                }
                "requestPermission" -> {
                    val permissionName = call.argument<String>("permission") ?: ""
                    requestPermission(permissionName, result)
                }
                "openSettings" -> {
                    try {
                        val intent = Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                            data = android.net.Uri.fromParts("package", packageName, null)
                        }
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SETTINGS_ERROR", e.message, null)
                    }
                }
                "registerBackgroundCallback" -> {
                    val handle = call.argument<Long>("handle") ?: 0L
                    val prefs = getSharedPreferences("bankyar_bg_prefs", Context.MODE_PRIVATE)
                    prefs.edit().putLong("bg_callback_handle", handle).apply()
                    result.success(true)
                }
                "startBackgroundService" -> {
                    try {
                        val intent = Intent(this, BackgroundService::class.java).apply {
                            action = BackgroundService.ACTION_INITIALIZE_STATUS
                        }
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startForegroundService(intent)
                        } else {
                            startService(intent)
                        }
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SERVICE_ERROR", e.message, null)
                    }
                }
                "stopBackgroundService" -> {
                    try {
                        val intent = Intent(this, BackgroundService::class.java)
                        stopService(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SERVICE_ERROR", e.message, null)
                    }
                }
                "scheduleWork" -> {
                    val taskName = call.argument<String>("taskName") ?: "SyncTask"
                    val intervalMinutes = call.argument<Int>("intervalMinutes")?.toLong() ?: 15L
                    val requiresCharging = call.argument<Boolean>("requiresCharging") ?: false
                    val requiresDeviceIdle = call.argument<Boolean>("requiresDeviceIdle") ?: false
                    val requiresBatteryNotLow = call.argument<Boolean>("requiresBatteryNotLow") ?: true
                    val backoffPolicyStr = call.argument<String>("backoffPolicy") ?: "exponential"
                    val backoffDelaySeconds = call.argument<Int>("backoffDelaySeconds")?.toLong() ?: 30L

                    try {
                        val constraints = Constraints.Builder().apply {
                            setRequiresCharging(requiresCharging)
                            setRequiresBatteryNotLow(requiresBatteryNotLow)
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                setRequiresDeviceIdle(requiresDeviceIdle)
                            }
                        }.build()

                        val backoffPolicy = if (backoffPolicyStr == "linear") {
                            BackoffPolicy.LINEAR
                        } else {
                            BackoffPolicy.EXPONENTIAL
                        }

                        val workRequest = PeriodicWorkRequestBuilder<SmsSyncWorker>(intervalMinutes, TimeUnit.MINUTES)
                            .setConstraints(constraints)
                            .setBackoffCriteria(backoffPolicy, backoffDelaySeconds, TimeUnit.SECONDS)
                            .build()

                        WorkManager.getInstance(applicationContext).enqueueUniquePeriodicWork(
                            taskName,
                            ExistingPeriodicWorkPolicy.UPDATE,
                            workRequest
                        )

                        result.success(true)
                    } catch (e: Exception) {
                        result.error("WORK_SCHEDULER_ERROR", e.message, null)
                    }
                }
                "cancelAllTasks" -> {
                    try {
                        WorkManager.getInstance(applicationContext).cancelAllWork()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("WORK_CANCEL_ERROR", e.message, null)
                    }
                }
                "queryHistoricalSms" -> {
                    val sinceTimestamp = call.argument<Long>("since") ?: 0L
                    val messages = querySmsInbox(sinceTimestamp)
                    result.success(messages)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Set up EventChannel for real-time incoming SMS observation
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                private var receiver: BroadcastReceiver? = null

                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    receiver = object : BroadcastReceiver() {
                        override fun onReceive(context: Context, intent: Intent) {
                            val sender = intent.getStringExtra("sender") ?: ""
                            val body = intent.getStringExtra("body") ?: ""
                            val timestamp = intent.getLongExtra("timestamp", 0L)

                            val data = mapOf(
                                "sender" to sender,
                                "body" to body,
                                "timestamp" to timestamp
                            )
                            events?.success(data)
                        }
                    }
                    val filter = IntentFilter(SmsReceiver.ACTION_SMS_RECEIVED_EVENT)

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        registerReceiver(receiver, filter, Context.RECEIVER_NOT_EXPORTED)
                    } else {
                        @Suppress("UnspecifiedRegisterReceiverFlag")
                        registerReceiver(receiver, filter)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    if (receiver != null) {
                        unregisterReceiver(receiver)
                        receiver = null
                    }
                }
            }
        )
    }

    private fun checkPermissionStatus(permission: String): String {
        val systemPermission = mapPermission(permission) ?: return "granted"
        val status = ContextCompat.checkSelfPermission(this, systemPermission)
        return if (status == PackageManager.PERMISSION_GRANTED) {
            "granted"
        } else {
            // Checks if user denied permanently
            val deniedOnce = ActivityCompat.shouldShowRequestPermissionRationale(this, systemPermission)
            if (deniedOnce) "denied" else "permanentlyDenied"
        }
    }

    private fun requestPermission(permission: String, result: MethodChannel.Result) {
        val systemPermission = mapPermission(permission)
        if (systemPermission == null) {
            result.success("granted")
            return
        }

        val currentStatus = checkPermissionStatus(permission)
        if (currentStatus == "granted") {
            result.success("granted")
            return
        }

        // Simulates native permission request by directly mapping ContextCompat
        ActivityCompat.requestPermissions(this, arrayOf(systemPermission), 102)
        // Since we are running headless, we can mock/return current status or trigger request
        result.success(checkPermissionStatus(permission))
    }

    private fun mapPermission(permission: String): String? {
        return when (permission) {
            "smsRead" -> android.Manifest.permission.READ_SMS
            "smsReceive" -> android.Manifest.permission.RECEIVE_SMS
            "notifications" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                android.Manifest.permission.POST_NOTIFICATIONS
            } else {
                null
            }
            "batteryExclusion" -> android.Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
            else -> null
        }
    }

    private fun querySmsInbox(since: Long): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        val uri = Telephony.Sms.Inbox.CONTENT_URI
        val projection = arrayOf(
            Telephony.Sms.Inbox.ADDRESS,
            Telephony.Sms.Inbox.BODY,
            Telephony.Sms.Inbox.DATE
        )
        val selection = "${Telephony.Sms.Inbox.DATE} > ?"
        val selectionArgs = arrayOf(since.toString())
        val sortOrder = "${Telephony.Sms.Inbox.DATE} ASC"

        contentResolver.query(uri, projection, selection, selectionArgs, sortOrder)?.use { cursor ->
            val addressIdx = cursor.getColumnIndexOrThrow(Telephony.Sms.Inbox.ADDRESS)
            val bodyIdx = cursor.getColumnIndexOrThrow(Telephony.Sms.Inbox.BODY)
            val dateIdx = cursor.getColumnIndexOrThrow(Telephony.Sms.Inbox.DATE)

            while (cursor.moveToNext()) {
                val address = cursor.getString(addressIdx)
                val body = cursor.getString(bodyIdx)
                val date = cursor.getLong(dateIdx)
                list.add(mapOf(
                    "sender" to address,
                    "body" to body,
                    "timestamp" to date
                ))
            }
        }
        return list
    }
}
