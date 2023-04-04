package `in`.fello.felloapp

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.ContentValues.TAG
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.provider.Settings
import android.util.Base64
import android.util.Log
import android.view.View
import com.google.android.gms.ads.identifier.AdvertisingIdClient
import com.google.android.gms.common.GooglePlayServicesNotAvailableException
import com.google.android.gms.common.GooglePlayServicesRepairableException
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.security.MessageDigest
import java.lang.reflect.Method


class MainActivity : FlutterFragmentActivity()  {
    private val CHANNEL = "fello.in/dev/notifications/channel/tambola"
    private val DEVICEDATACHANNEL = "methodChannel/deviceData"
    private val UPIINTENTCHANNEL = "methodChannel/upiIntent"
    private val getUpiApps="getUpiApps"
    private val intiateTransaction="initiateTransaction"
    private  var res: MethodChannel.Result?=null
    private val successRequestCode = 101
    private lateinit var paymentMethodChannel:MethodChannel
    private lateinit var context:Context
    private lateinit var paymentResult: MethodChannel.Result
    override fun configureFlutterEngine( flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        context=applicationContext
        flutterEngine.plugins.add(MyPlugin())
        GeneratedPluginRegistrant.registerWith(flutterEngine)

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
        //METHOD CHANNEL [2]
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICEDATACHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
            call, result ->
            if (call.method == "getInstalledApps") {
              val installedAppsList = getInstalledApplications()
              if (installedAppsList.size != 0) {
                result.success(installedAppsList)
              } else {
                result.error("UNAVAILABLE", "Installed Apps information not available", null)
              }
            }
             else if(call.method == "getDeviceId"){
               val id: String = getUniqueDeviceId(context)
                 result.success(id)
             }
            else if(call.method == "getAdvertisingId"){
                val id: String? = getAdvertisingId()
                result.success(id)
            }
            else if(call.method == "getAppSetId"){
                val id: String? = getAppSetId()
                result.success(id);
            }
            else if(call.method == "getAndroidId"){
                result.success(getAndroidId())
            }
            else if(call.method == "isDeviceRooted"){
                result.success(RootCheckService().isDeviceRooted())
            }
            else {
              result.notImplemented()
            }
          }

       paymentMethodChannel =  MethodChannel(flutterEngine.dartExecutor.binaryMessenger, UPIINTENTCHANNEL)
        paymentMethodChannel.setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            when (call.method) {
                "initiatePsp" -> {
                    paymentResult = result
                    var argsData = call.arguments as HashMap<*, *>
                    val intentUrl:String = argsData["redirectUrl"] as String
                    val packageName = argsData["packageName"] as String
                    val i = Intent(Intent.ACTION_VIEW)
                    i.data = Uri.parse(intentUrl)
                    i.setPackage(packageName)
                    startActivityForResult(i, successRequestCode)
                }
                "getPhonePeVersion" -> {
                    val id: Long = getPhonePeVersionCode(context)
                    result.success(id)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == successRequestCode) {
            print("On Activity Result"+data.toString())
            data?.putExtra("resultCode",resultCode)
         paymentResult.success(data?.getStringExtra("response") as Object?) ; // returnResult(data?.getStringExtra("response") as Object?)
        }
    }

    fun getPhonePeVersionCode(context: Context?): Long {
        // val PHONEPE_PACKAGE_NAME_UAT = "com.phonepe.app.preprod"
        val PHONEPE_PACKAGE_NAME_PRODUCTION = "com.phonepe.app"
        var packageInfo: PackageInfo? = null
        var phonePeVersionCode = -1L
        try {
            packageInfo = packageManager.getPackageInfo(
                PHONEPE_PACKAGE_NAME_PRODUCTION,
                PackageManager.GET_ACTIVITIES
            )
            phonePeVersionCode = if (VERSION.SDK_INT >= VERSION_CODES.P) {
                packageInfo.getLongVersionCode()
            } else {
                packageInfo.versionCode.toLong()
            }
        } catch (e: PackageManager.NameNotFoundException) {
            Log.e(
                TAG, String.format(
                    "failed to get package info for package name = {%s}, exception message = {%s}",
                    PHONEPE_PACKAGE_NAME_PRODUCTION, e.message
                )
            )
        }
        return phonePeVersionCode
    }
    
    @SuppressLint("HardwareIds")
    private fun getAndroidId(): String? {
        return Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID);
    }

    @SuppressLint("QueryPermissionsNeeded")
    private fun getInstalledApplications(): ArrayList<HashMap<String,Any?>> {
     try {
       val packageManager = context.packageManager
       val installedApps = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
       val userApps = installedApps.filter {
           (it.flags and ApplicationInfo.FLAG_SYSTEM) != ApplicationInfo.FLAG_SYSTEM
       }
       val apps: ArrayList<HashMap<String,Any?>>  = ArrayList()
       for (app in userApps) {
          val appName =  app.loadLabel(packageManager).toString()
           val appData : HashMap<String, Any?>
          = HashMap<String, Any?> ()
           appData["package_name"] = app.packageName
           appData["app_name"] = appName
           apps.add(appData)
       }
       return apps;
   } catch (e: Exception) {
       println("Failed to query packages with error $e")
       return ArrayList()
   }
    }

    @SuppressLint("HardwareIds")
    fun getUniqueDeviceId(context: Context): String {
        return Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
    }


    private fun getAdvertisingId(): String? {
        var adInfo: com.google.android.gms.ads.identifier.AdvertisingIdClient.Info? = null
        try {
            adInfo = AdvertisingIdClient.getAdvertisingIdInfo(applicationContext)
        } catch (e: IOException) {
            e.printStackTrace()
        } catch (e: GooglePlayServicesNotAvailableException) {
            e.printStackTrace()
        } catch (e: GooglePlayServicesRepairableException) {
            e.printStackTrace()
        }
        var advertisingId: String? = null
        try {
            advertisingId = adInfo?.id
        } catch (e: NullPointerException) {
            e.printStackTrace()
        }
        return advertisingId
    }

    @SuppressLint("HardwareIds")
    fun getAppSetId(): String {
        val androidId = Settings.Secure.getString(
            applicationContext.contentResolver,
            Settings.Secure.ANDROID_ID
        )
        val deviceId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            Build.getSerial()
        } else {
            Build.SERIAL
        }
        val combinedId = "$androidId$deviceId"
        val digest = MessageDigest.getInstance("SHA-256")
        val hash = digest.digest(combinedId.toByteArray(Charsets.UTF_8))
        return hash.joinToString("") {
            String.format("%02x", it)
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
    // TODO: IMAGE PICKER PICKING UP THIS CODE AND NOT WORKING PROPERLY.
    // TO BE FIXED IN NEXT SPRINT
    // override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    //     // if(data==null){
    //     //     return;
    //     // }
    //     // if(res!=null) {


    //     //     if (requestCode == successRequestCode) {

    //     //         returnResult(data?.getStringExtra("response") as Object?)

    //     //     }
    //     //     else {
    //     //         if(!isAlreadyReturend){
    //     //             isAlreadyReturend=true
    //     //             res?.error("400", "user_cancelled", "Something went wrong")
    //     //         }


    //     //     }
    //     // }


    //     super.onActivityResult(requestCode, resultCode, data)
    // }


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
