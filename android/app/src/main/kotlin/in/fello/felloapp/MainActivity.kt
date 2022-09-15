package `in`.fello.felloapp

import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.net.Uri
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.NonNull
import com.google.android.gms.tasks.Task
import com.google.android.gms.tasks.Tasks.await
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result


class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "fello.in/dev/notifications/channel/tambola"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                // Note: this method is invoked on the main thread.
                call, result ->

            if (call.method == "createNotificationChannel") {
                val argData = call.arguments as java.util.HashMap<String, String>
                val completed = createNotificationChannel(argData)
                if (completed != null) {
                    result.success(completed)
                } else {
                    result.error("Error Code", "Error Message", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onStart() {
        super.onStart()
        window.decorView.visibility = View.VISIBLE
    }

    override fun onStop() {
        window.decorView.visibility = View.GONE
        super.onStop()
    }

    private fun createNotificationChannel(mapData: HashMap<String, String>): Boolean {
        val completed: Boolean
        if (VERSION.SDK_INT >= VERSION_CODES.O) {
            // Create the NotificationChannel
            val id = mapData["id"]
            val name = mapData["name"]
            val descriptionText = mapData["description"]
            val importance = NotificationManager.IMPORTANCE_HIGH
            val mChannel = NotificationChannel(id, name, importance)
            mChannel.description = descriptionText
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)
            completed = true
        } else {
            completed = false
        }
        return completed
    }
}
