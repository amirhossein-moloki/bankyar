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
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.provider.DocumentsContract
import android.net.Uri
import java.io.OutputStream
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val PLATFORM_CHANNEL = "com.bankyar.app/platform"
    private val SMS_EVENT_CHANNEL = "com.bankyar.app/sms_events"
    private var pendingResult: MethodChannel.Result? = null
    private var pendingFileName: String? = null
    private var pendingContent: String? = null
    private val REQUEST_CODE_PICK_DIRECTORY = 1003

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_PICK_DIRECTORY) {
            val result = pendingResult
            val filename = pendingFileName
            val content = pendingContent

            pendingResult = null
            pendingFileName = null
            pendingContent = null

            if (result == null) return

            if (resultCode == RESULT_OK && data != null) {
                val treeUri = data.data
                if (treeUri != null) {
                    try {
                        val takeFlags = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                        contentResolver.takePersistableUriPermission(treeUri, takeFlags)

                        val docUri = DocumentsContract.buildDocumentUriUsingTree(
                            treeUri,
                            DocumentsContract.getTreeDocumentId(treeUri)
                        )
                        val fileUri = DocumentsContract.createDocument(
                            contentResolver,
                            docUri,
                            "application/json",
                            filename ?: "bankyar_export.json"
                        )

                        if (fileUri != null) {
                            contentResolver.openOutputStream(fileUri)?.use { outputStream ->
                                outputStream.write((content ?: "").toByteArray(Charsets.UTF_8))
                            }
                            val decodedPath = Uri.decode(fileUri.toString())
                            result.success(decodedPath)
                        } else {
                            result.error("EXPORT_FAILED", "Failed to create document in selected folder", null)
                        }
                    } catch (e: Exception) {
                        result.error("EXPORT_FAILED", e.message, null)
                    }
                } else {
                    result.error("EXPORT_CANCELLED", "No directory was selected", null)
                }
            } else {
                result.error("EXPORT_CANCELLED", "Export was cancelled by user", null)
            }
        }
    }

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
                    val handle = getSafeLongArgument(call, "handle") ?: 0L
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
                    val intervalMinutes = getSafeLongArgument(call, "intervalMinutes") ?: 15L
                    val requiresCharging = call.argument<Boolean>("requiresCharging") ?: false
                    val requiresDeviceIdle = call.argument<Boolean>("requiresDeviceIdle") ?: false
                    val requiresBatteryNotLow = call.argument<Boolean>("requiresBatteryNotLow") ?: true
                    val backoffPolicyStr = call.argument<String>("backoffPolicy") ?: "exponential"
                    val backoffDelaySeconds = getSafeLongArgument(call, "backoffDelaySeconds") ?: 30L

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
                    val sinceTimestamp = getSafeLongArgument(call, "since") ?: 0L
                    val messages = querySmsInbox(sinceTimestamp)
                    result.success(messages)
                }
                "exportJsonViaSAF" -> {
                    val filename = call.argument<String>("filename") ?: "bankyar_export.json"
                    val content = call.argument<String>("content") ?: ""
                    pendingFileName = filename
                    pendingContent = content
                    pendingResult = result

                    try {
                        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
                        startActivityForResult(intent, REQUEST_CODE_PICK_DIRECTORY)
                    } catch (e: Exception) {
                        pendingResult = null
                        pendingFileName = null
                        pendingContent = null
                        result.error("SAF_ERROR", e.message, null)
                    }
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
            Telephony.Sms.Inbox._ID,
            Telephony.Sms.Inbox.ADDRESS,
            Telephony.Sms.Inbox.BODY,
            Telephony.Sms.Inbox.DATE
        )
        val selection = "${Telephony.Sms.Inbox.DATE} > ?"
        val selectionArgs = arrayOf(since.toString())
        val sortOrder = "${Telephony.Sms.Inbox.DATE} ASC"

        contentResolver.query(uri, projection, selection, selectionArgs, sortOrder)?.use { cursor ->
            val idIdx = cursor.getColumnIndexOrThrow(Telephony.Sms.Inbox._ID)
            val addressIdx = cursor.getColumnIndexOrThrow(Telephony.Sms.Inbox.ADDRESS)
            val bodyIdx = cursor.getColumnIndexOrThrow(Telephony.Sms.Inbox.BODY)
            val dateIdx = cursor.getColumnIndexOrThrow(Telephony.Sms.Inbox.DATE)

            while (cursor.moveToNext()) {
                val id = if (cursor.isNull(idIdx)) 0L else cursor.getLong(idIdx)
                val address = if (cursor.isNull(addressIdx)) "" else cursor.getString(addressIdx)
                val body = if (cursor.isNull(bodyIdx)) "" else cursor.getString(bodyIdx)
                val date = if (cursor.isNull(dateIdx)) 0L else cursor.getLong(dateIdx)
                list.add(mapOf(
                    "id" to id.toString(),
                    "sender" to address,
                    "body" to body,
                    "timestamp" to date
                ))
            }
        }
        return list
    }

    private fun getSafeLongArgument(call: MethodCall, key: String): Long? {
        val value = call.argument<Any>(key) ?: return null
        return when (value) {
            is Number -> value.toLong()
            is String -> value.toLongOrNull()
            else -> null
        }
    }

    private fun getSafeIntArgument(call: MethodCall, key: String): Int? {
        val value = call.argument<Any>(key) ?: return null
        return when (value) {
            is Number -> value.toInt()
            is String -> value.toIntOrNull()
            else -> null
        }
    }
}
