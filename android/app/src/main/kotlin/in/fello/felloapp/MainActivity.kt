package `in`.fello.felloapp

import android.annotation.SuppressLint
import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.util.Base64
import android.util.Log
import android.view.View
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.logging.Logger
import kotlin.math.log


class MainActivity : FlutterFragmentActivity()  {
    private val CHANNEL = "fello.in/dev/notifications/channel/tambola"
    private val getUpiApps="getUpiApps"
    private val intiateTransaction="initiateTransaction"
    private  var res: MethodChannel.Result?=null
    private val successRequestCode = 101
    private lateinit var context:Context
    override fun configureFlutterEngine( flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
            context=applicationContext
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                // Note: this method is invoked on the main thread.
                call, result ->
            isAlreadyReturend=false
            res=result

            when (call.method){
                "createNotificationChannel" ->{

                    val argData = call.arguments as HashMap<String,String>
                    val completed = createNotificationChannel(argData)

                    returnResult(completed as Object)
                }

                getUpiApps->getupiApps()
                intiateTransaction ->startTransation(call.argument<String>("app").toString(),call.argument<String>("deepLinkUrl").toString())
                else -> result.notImplemented();
            }




        }
    }

    private var isAlreadyReturend=false

    private fun returnResult(re:Object?){
        if(re==null){
            return;
        }
        if(!isAlreadyReturend){
            isAlreadyReturend=true
            res?.success(re);
        }

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if(data==null){
            return;
        }
        if(res!=null) {


            if (requestCode == successRequestCode) {

                returnResult(data?.getStringExtra("response") as Object?)

            }
            else {
                if(!isAlreadyReturend){
                    isAlreadyReturend=true
                    res?.error("400", "user_cancelled", "Something went wrong")
                }


            }
        }


        super.onActivityResult(requestCode, resultCode, data)
    }


    @SuppressLint("SuspiciousIndentation")
    private fun startTransation(app:String, deepLink:String){

        try {


            val uri = Uri.parse(deepLink)
            val deepLinkIntent=Intent(Intent.ACTION_VIEW,uri)
            deepLinkIntent.setPackage(app)
            if(deepLinkIntent.resolveActivity(context.packageManager)==null){
                res?.error("400","No App Found","No UPI Apps Found")
                return
            }
            else
            this.startActivityForResult(deepLinkIntent,successRequestCode)



        }catch (e: Exception){
            Log.d("Something went Wrong:" ,"$e")
            e.printStackTrace()
        }
    }




    private fun getupiApps(){

        val packageManager = context.packageManager
        val mainIntent = Intent(Intent.ACTION_MAIN, null)
        mainIntent.addCategory(Intent.CATEGORY_DEFAULT)
        mainIntent.addCategory(Intent.CATEGORY_BROWSABLE)
        mainIntent.action = Intent.ACTION_VIEW
        val uri1 = Uri.Builder().scheme("upi").authority("pay").build()
        mainIntent.data = uri1
        var list= mutableListOf<Map<String,String>>()

        try {
            val activities = packageManager.queryIntentActivities(mainIntent, PackageManager.MATCH_DEFAULT_ONLY)
            Log.d(activities.toString(),"UPI Apps Present")
            // Convert the activities into a response that can be transferred over the channel.

        for(it in activities){
            val packageName = it.activityInfo.packageName
            val drawable = packageManager.getApplicationIcon(packageName)

            val bitmap = getBitmapFromDrawable(drawable)
            val icon = if (bitmap != null) {
                encodeToBase64(bitmap)
            } else {
                null
            }
            var map=mapOf(
                    "packageName" to packageName,
                    "icon" to icon,
                    "priority" to it.priority,
                    "preferredOrder" to it.preferredOrder
            )
            list.add(
                    map as Map<String, String>
            )
        }


            Log.d(list.size.toString(),"List")
            returnResult(list as Object)

        } catch (ex: Exception) {
            Log.e("UPI",ex.message!!)
            res?.error("400", "exception",ex.message )
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





    private fun encodeToBase64(image: Bitmap): String? {
        val byteArrayOS = ByteArrayOutputStream()
        image.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOS)
        return Base64.encodeToString(byteArrayOS.toByteArray(), Base64.NO_WRAP)
    }

    private fun getBitmapFromDrawable(drawable: Drawable): Bitmap? {
        val bmp: Bitmap = Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bmp)
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight())
        drawable.draw(canvas)
        return bmp
    }

}
