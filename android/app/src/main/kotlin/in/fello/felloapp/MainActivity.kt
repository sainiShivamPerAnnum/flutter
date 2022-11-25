package `in`.fello.felloapp

import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.view.View
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "fello.in/dev/notifications/channel/tambola"
    private val getUpiApps="getUpiApps"
    private val intiateTransaction="intiateTransaction"
    private lateinit var result: MethodChannel.Result
    private val successRequestCode = 101
    override fun configureFlutterEngine( flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                // Note: this method is invoked on the main thread.
                call, result ->
            this.result=result;
            when (call.method){
                "createNotificationChannel" ->{
                    val argData = call.arguments as HashMap<String,String>
                    val completed = createNotificationChannel(argData)

                    result.success(completed)
                }

                getUpiApps->startUpiChannel(UPIMethod.getApps,"")
                    intiateTransaction ->startUpiChannel(UPIMethod.startTransaction,call.argument<String>("deepLink").toString(),call.argument<String>("app").toString())
            }



        }
    }


    private fun  startUpiChannel(type:UPIMethod,deepLink:String="",app:String=""){
        var intent= Intent(this,UpiChannel::class.java)
        if(type==UPIMethod.startTransaction){
            intent.putExtra("deepLink",deepLink)
            intent.putExtra("app",app)
            intent.putExtra("type",type)
        }
        startActivityForResult(intent,successRequestCode)

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {

        if(requestCode==Activity.RESULT_OK && requestCode==requestCode){
            val e=data?.getIntExtra("error",400)
            val message=data?.getStringExtra("message")
            val list=data?.getLongArrayExtra("apps")

            if(e!=200){
                result.error(e.toString(),message,"")
            }else{
                if (list != null) {
                    if(list.isEmpty()){
                        result.success(message)
                            return
                    }
                }
                result.success(list)

            }

        }
        super.onActivityResult(requestCode, resultCode, data)
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
