package `in`.fello.felloapp

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.GeneratedPluginRegistrant
import com.freshchat.consumer.sdk.flutter.FreshchatSdkPlugin
// import io.flutter.view.FlutterMain 
// import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
// import io.flutter.plugins.firebase.messaging.FirebaseMessagingPlugin



class Application: FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate();
    }

    override fun registerWith(registry: PluginRegistry) {
        FreshchatSdkPlugin.register(registry)
    }
}
