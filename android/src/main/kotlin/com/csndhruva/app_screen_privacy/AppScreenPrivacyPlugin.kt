package com.csndhruva.app_screen_privacy

import io.flutter.embedding.engine.plugins.FlutterPlugin
import android.graphics.Color
import android.widget.ImageView
import android.widget.FrameLayout
import android.graphics.drawable.Drawable
import android.util.Log
import java.io.IOException
import java.io.InputStream
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AppScreenPrivacyPlugin */
class AppScreenPrivacyPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var privacyScreen: ImageView? = null
    private var activity: android.app.Activity? = null
    private var binding: FlutterPlugin.FlutterPluginBinding? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_screen_privacy")
        channel.setMethodCallHandler(this)
        binding = flutterPluginBinding
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        else if(call.method == "showPrivacyScreen"){
            val logo = call.argument<String?>("logo")
            val bgColor = call.argument<String?>("backgroundColor")
            showPrivacyScreen(logo, bgColor)
            result.success("success")
        } else if(call.method == "hidePrivacyScreen"){
            hidePrivacyScreen()
            result.success(null)
        }
        else {
            result.notImplemented()
        }
    }

    // Required ActivityAware implementation
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    private fun showPrivacyScreen(logo: String?, bgColor: String? ) {
        activity?.runOnUiThread {
            if (privacyScreen == null) {
                val localBinding = this.binding
                privacyScreen = ImageView(activity).apply {
                    if(logo!=null && localBinding!=null){
                        var inputStream: InputStream? = null
                        try {
                            val flutterAssets = localBinding.flutterAssets
                            val assetPath = flutterAssets.getAssetFilePathBySubpath(logo)

                            Log.d("PrivacyScreen", "Loading asset at logical key: $logo -> physical path: $assetPath")

                            inputStream = localBinding.applicationContext.assets?.open(assetPath)

                            if (inputStream != null) {
                                val drawable = Drawable.createFromStream(inputStream, null)
                                setImageDrawable(drawable)
                            } else {
                                Log.e("PrivacyScreen", "Failed to get input stream for asset: $logo")
                                setImageResource(android.R.drawable.ic_lock_idle_lock)
                            }
                        } catch (e: IOException) {
                            Log.e("PrivacyScreen", "Exception occurred while loading image ${e.message}")
                            setImageResource(android.R.drawable.ic_lock_idle_lock)
                        }
                    }
                    scaleType = ImageView.ScaleType.FIT_CENTER
                    setBackgroundColor(if(bgColor!=null) Color.parseColor(bgColor) else Color.WHITE)
                    layoutParams = FrameLayout.LayoutParams(
                        FrameLayout.LayoutParams.MATCH_PARENT,
                        FrameLayout.LayoutParams.MATCH_PARENT
                    )
                }
                (activity?.window?.decorView as FrameLayout).addView(privacyScreen)
            }
        }

    }

    private fun hidePrivacyScreen() {
        activity?.runOnUiThread {
            privacyScreen?.let {
                (activity?.window?.decorView as FrameLayout).removeView(privacyScreen)
                privacyScreen = null
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        this.binding = null
    }
}
