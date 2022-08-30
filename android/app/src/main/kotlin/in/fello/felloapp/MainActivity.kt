package `in`.fello.felloapp

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterFragmentActivity
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
import android.view.View


class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "fello.in/dev/notifications/channel/tambola"
    private val PAYMENTCHANNEL = "fello.in/dev/payments/paytmService";

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
            } 
            else {
                result.notImplemented()
            }
        }


        // MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PAYMENTCHANNEL).setMethodCallHandler {
        //     // Note: this method is invoked on the main thread.
        //     call, result ->
        //     if(call.method == "initiatePaytmTransaction"){
        //         try{
        //             val argData = call.arguments as java.utils.HashMap<String,String>
        //             val uri = Uri.parse(uriStr)
        //             Log.d("initiateTransaction URI: " + uri.toString())
        //             val intent = Intent(Intent.ACTION_VIEW, uri)
        //             intent.setPackage(app)
        //             if (intent.resolveActivity(activity.packageManager) == null) {
        //                 this.success("activity_unavailable")
        //                 return
        //             }
        //             activity.startActivityForResult(intent, requestCodeNumber)
        //     } 
        //     catch (ex: Exception) {
        //             Log.e("upi_pay", ex.toString())
        //             this.success("failed_to_open_app")
        //     }
        //     }
        //     else {
        //         result.notImplemented()
        //     }
        // }
    }

    override fun onStart() {
        super.onStart()
        window.decorView.visibility = View.VISIBLE
    }

    override fun onStop() {
        window.decorView.visibility = View.GONE
        super.onStop()
    }

    private fun createNotificationChannel(mapData: HashMap<String,String>): Boolean {
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
        }
        else{
            completed = false
        }
        return completed
    }

    // private fun initiateTransaction(mapData: HashMap<String,String>) : String{
        
    //     val uri = Uri.parse(mapData["url"])
    //     Log.d("upi_pay", "initiateTransaction URI: " + uri.toString())
    
    //     val intent = Intent(Intent.ACTION_VIEW, uri)
    //     intent.setPackage(mapData["app"])
    
    //     if (intent.resolveActivity(activity.packageManager) == null) {
    //         this.success("activity_unavailable")
    //         return
    //     }
    
    //     activity.startActivityForResult(intent, requestCodeNumber)
    //     } catch (ex: Exception) {
    //     Log.e("upi_pay", ex.toString())
    //     this.success("failed_to_open_app")
    //     }
    // }

    // override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    //     if (requestCodeNumber == requestCode && result != null) {
    //     if (data != null) {
    //         try {
    //         val response = data.getStringExtra("response")!!
    //         this.success(response)
    //         } catch (ex: Exception) {
    //         this.success("invalid_response")
    //         }
    //     } else {
    //         this.success("user_cancelled")
    //     }
    //     }
    //     return true
    // }
}