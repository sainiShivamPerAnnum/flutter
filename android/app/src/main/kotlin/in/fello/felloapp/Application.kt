package `in`.fello.felloapp

import android.util.Log
import com.freshchat.consumer.sdk.flutter.FreshchatSdkPlugin
import com.google.firebase.messaging.FirebaseMessaging
import com.webengage.sdk.android.LocationTrackingStrategy
import com.webengage.sdk.android.WebEngage
import com.webengage.sdk.android.WebEngageConfig
import com.webengage.webengage_plugin.WebengageInitializer
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        val webEngageConfig = WebEngageConfig.Builder()
                .setWebEngageKey(getString(R.string.webengage_code))
                .setAutoGCMRegistrationFlag(false)
                .setLocationTrackingStrategy(LocationTrackingStrategy.ACCURACY_BEST)
                .setDebugMode(true) // only in development mode
                .build()

        WebengageInitializer.initialize(this, webEngageConfig)


        FirebaseMessaging.getInstance().token.addOnCompleteListener {
            if (!it.isSuccessful) {
                Log.d("Native Error", "Fetching FCM registration token failed", it.exception)
                return@addOnCompleteListener;
            }

            val token = it.result
            WebEngage.get().setRegistrationID(token)
        }

    }

    override fun registerWith(registry: PluginRegistry) {
        FreshchatSdkPlugin.register(registry)
    }
}
