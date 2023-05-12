//package `in`.fello.felloapp
//
//import android.content.Context
//import android.net.Uri
//import android.os.RemoteException
//import com.android.installreferrer.api.InstallReferrerClient
//import com.android.installreferrer.api.InstallReferrerStateListener
//import com.android.installreferrer.api.ReferrerDetails
//import io.flutter.embedding.engine.plugins.FlutterPlugin
//import io.flutter.plugin.common.MethodCall
//import io.flutter.plugin.common.MethodChannel
//import io.flutter.plugin.common.MethodChannel.Result
//import io.flutter.plugin.common.PluginRegistry.Registrar
//
//class MyPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
//    private lateinit var channel: MethodChannel
//    private lateinit var context: Context
//    private var referrerClient: InstallReferrerClient? = null
//
//    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//        channel = MethodChannel(binding.binaryMessenger, "my_plugin")
//        channel.setMethodCallHandler(this)
//        context = binding.applicationContext
//    }
//
//    override fun onMethodCall(call: MethodCall, result: Result) {
//        when (call.method) {
//            "getInstallReferrer" -> getInstallReferrer(result)
//            else -> result.notImplemented()
//        }
//    }
//
//    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//        channel.setMethodCallHandler(null)
//        referrerClient?.endConnection()
//    }
//
//    private fun getInstallReferrer(result: Result) {
//        referrerClient = InstallReferrerClient.newBuilder(context).build()
//        referrerClient!!.startConnection(object : InstallReferrerStateListener {
//            override fun onInstallReferrerSetupFinished(responseCode: Int) {
//                when (responseCode) {
//                    InstallReferrerClient.InstallReferrerResponse.OK -> {
//                        try {
//                            val response: ReferrerDetails = referrerClient!!.installReferrer
//                            val referrerUrl: String = response.installReferrer
//                            val referrerClickTime: Long = response.referrerClickTimestampSeconds
//                            val appInstallTime: Long = response.installBeginTimestampSeconds
//                            val instantExperienceLaunched: Boolean = response.googlePlayInstantParam
//                            val referrerUri: Uri = Uri.parse(referrerUrl)
//                            val utmSource: String? = referrerUri.getQueryParameter("utm_source")
//                            val utmMedium: String? = referrerUri.getQueryParameter("utm_medium")
//                            val utmCampaign: String? = referrerUri.getQueryParameter("utm_campaign")
//                            val utmContent: String? = referrerUri.getQueryParameter("utm_content")
//
//                            result.success( referrerUrl + utmSource + utmMedium + utmCampaign + utmContent+ referrerClickTime.toString()+appInstallTime.toString()+instantExperienceLaunched.toString())
//                        } catch (e: RemoteException) {
//                            result.error("REMOTE_EXCEPTION", e.message, null)
//                        }
//                    }
//                    InstallReferrerClient.InstallReferrerResponse.FEATURE_NOT_SUPPORTED -> {
//                        result.error("FEATURE_NOT_SUPPORTED", "InstallReferrer API not supported", null)
//                    }
//                    InstallReferrerClient.InstallReferrerResponse.SERVICE_UNAVAILABLE -> {
//                        result.error("SERVICE_UNAVAILABLE", "InstallReferrer service unavailable", null)
//                    }
//                }
//            }
//
//            override fun onInstallReferrerServiceDisconnected() {
//                // Try to restart the connection on the next method call
//            }
//        })
//    }
//
//
//
//    companion object {
//        @JvmStatic
//        fun registerWith(registrar: Registrar) {
//            val channel = MethodChannel(registrar.messenger(), "my_plugin")
//            channel.setMethodCallHandler(MyPlugin())
//        }
//    }
//}
