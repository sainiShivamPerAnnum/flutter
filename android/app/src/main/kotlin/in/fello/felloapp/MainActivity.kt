package `in`.fello.felloapp

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.view.View
import androidx.annotation.NonNull
import android.content.Intent
import android.net.Uri
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import io.flutter.plugin.common.PluginRegistry.Registrar


class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "fello.in/dev/notifications/channel/tambola"
    private val PAYMENTCHANNEL = "fello.in/dev/payments/paytmService"
    private var result: Result? = null
    var hasResponded = false
    private var requestCodeNumber = 201119

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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PAYMENTCHANNEL).setMethodCallHandler {
                // Note: this method is invoked on the main thread.
                call, result ->
            if (call.method == "initiatePaytmTransaction") {
                    val argData = call.arguments as java.util.HashMap<String, String>
                    val completed = initiateTransaction(argData)
                result.success(completed)
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCodeNumber == requestCode && result != null) {
        if (data != null) {
            try {
                val response = data.getStringExtra("response")!!
                this.success(response)
            } catch (ex: Exception) {
                this.success("invalid_response")
            }
        } else {
            this.success("user_cancelled")
        }
    }
  }

  private fun success(o: String) {
    if (!hasResponded) {
      hasResponded = true
      result?.success(o)
    }
  }

    private fun initiateTransaction(mapData: HashMap<String,String>) {
        try{
            val uri = Uri.parse(mapData["url"])
            val intent = Intent(Intent.ACTION_VIEW, uri)
            intent.setPackage(mapData["app"])
            if (intent.resolveActivity(packageManager) == null) {
                this.success("activity_unavailable")
                return
            }
            startActivityForResult(intent, requestCodeNumber)

        }
        catch(ex: Exception){
            this.success("failed_to_open_app")
        }
        }
    }
