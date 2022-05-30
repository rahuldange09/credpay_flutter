package com.fraazo.credpay

//import android.support.annotation.NonNull
import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.util.Log
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultCallback
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry

/** CredpayPlugin */
class CredpayPlugin : FlutterPlugin, MethodCallHandler, PluginRegistry.ActivityResultListener,
    ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private val CRED_PAY_CODE: Int = 3824
    private lateinit var context: Context
    private var activity: Activity? = null
    private var flutterResult: MethodChannel.Result? = null


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "credpay")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        // activity = flutterPluginBinding.binaryMessenger.a
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)

    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)

    }

    override fun onDetachedFromActivity() {
        activity = null
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        flutterResult = result
        when (call.method) {
            "launchCredPay" -> launchCredPay(call!!.argument("url")!!)
            "isAppInstalled" -> isAppInstalled(call!!.argument("packageName")!!)
            else -> result.notImplemented()
        }
    }

    private fun launchCredPay(uri: String) {
        try {
            val intent = Intent(Intent.ACTION_VIEW).apply {
                data = Uri.parse(uri)
            }
            activity?.startActivityForResult(intent, CRED_PAY_CODE)
        } catch (activityNotFound: ActivityNotFoundException) {
            flutterResult?.error("", null, null)
        } catch (e: Exception) {
            flutterResult?.error("", null, null)
        }
    }

    private fun isAppInstalled(packageName: String) {
        try {
            context.packageManager.getApplicationInfo(packageName, 0)
            flutterResult?.success(true)
        } catch (e: PackageManager.NameNotFoundException) {
            flutterResult?.success(false)
        }
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {

        if (requestCode == CRED_PAY_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                if (data != null) {
                    flutterResult?.success("success")
                } else {
                    flutterResult?.success("fail")
                }
            } else {
                flutterResult?.success("fail")
            }
            return true
        }
        return true
    }
}


