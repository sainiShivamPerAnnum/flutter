package `in`.fello.felloapp

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.app.NotificationManager;
import android.app.NotificationChannel;
import android.net.Uri;
import android.media.AudioAttributes;
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.ContentResolver;


class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "fello.in/dev/notifications/channel/tambola"
    private val CHANNEL_FRESHCHAT = "fello.in/dev/notifications/channel/support"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->

            if (call.method == "createNotificationChannel"){
                val argData = call.arguments as java.util.HashMap<String, String>
                val completed = createNotificationChannel(argData)
                if (completed == true){
                    result.success(completed)
                }
                else{
                    result.error("Error Code", "Error Message", null)
                }
            } else {
                result.notImplemented()
            }
        }
        // MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_FRESHCHAT).setMethodCallHandler {
        //     call, result -> 

        //     if (call.method == 'createFreshchatNotificationHandler') {
                
        //     }
        // }
    }

    private fun createNotificationChannel(mapData: HashMap<String,String>): Boolean {
        val completed: Boolean
        if (VERSION.SDK_INT >= VERSION_CODES.O) {
            // Create the NotificationChannel
            val id = mapData["id"]
            val name = mapData["name"]
            val descriptionText = mapData["description"]
//            val sound = "your_sweet_sound"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val mChannel = NotificationChannel(id, name, importance)
            mChannel.description = descriptionText
//            val soundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://"+ getApplicationContext().getPackageName() + "/raw/your_sweet_sound");
//            val att = AudioAttributes.Builder()
//                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
//                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
//                    .build();

//            mChannel.setSound(soundUri, att)
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)
            completed = true
        }
        else{
            completed = false
        }
        return completed
    }
}