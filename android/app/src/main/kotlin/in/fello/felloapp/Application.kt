package `in`.fello.felloapp

import com.freshchat.consumer.sdk.flutter.FreshchatSdkPlugin
import com.webengage.sdk.android.LocationTrackingStrategy
import com.webengage.sdk.android.WebEngageConfig
import com.webengage.webengage_plugin.WebengageInitializer
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback

class Application: FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate();
        val webEngageConfig = WebEngageConfig.Builder()
                .setWebEngageKey(getString(R.string.webengage_code))
                .setAutoGCMRegistrationFlag(false)
                .setLocationTrackingStrategy(LocationTrackingStrategy.ACCURACY_BEST)
                .setDebugMode(true) // only in development mode
                .build()

        WebengageInitializer.initialize(this, webEngageConfig)
    }

    override fun registerWith(registry: PluginRegistry) {
        if(registry!=null) {
            FreshchatSdkPlugin.register(registry)
        }
    }
}
