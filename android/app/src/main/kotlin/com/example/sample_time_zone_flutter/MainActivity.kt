package com.example.sample_time_zone_flutter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity(), MethodChannel.MethodCallHandler {
    private val channel = "sample_time_zone_flutter_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "get_native_time_zone" -> {
                val timezone = TimeZone.getDefault()
                val timezoneName = timezone.id
                val now = Date()
                val offsetFromUtc = timezone.getOffset(now.time) / 1000
                val resultMap = mapOf("timezone" to timezoneName, "gmt_offset" to offsetFromUtc)
                result.success(resultMap)
            }
        }
    }
}
