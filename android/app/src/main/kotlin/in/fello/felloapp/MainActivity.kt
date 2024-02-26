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
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Base64
import android.util.Log
import android.view.View
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.ByteArrayOutputStream
import `in`.fello.felloapp.R
import android.widget.RemoteViews
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.ContentResolver
import android.database.Cursor
import android.os.Build
import android.provider.ContactsContract
import com.clevertap.android.sdk.CleverTapAPI


class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "fello.in/dev/notifications/channel/tambola"
    private val DEVICEDATACHANNEL = "methodChannel/deviceData"
    private val UPIINTENTCHANNEL = "methodChannel/upiIntent"
    private val getUpiApps = "getUpiApps"
    private val intiateTransaction = "initiateTransaction"
    private val CONTACTCHANNEL = "methodChannel/contact"
    private var res: MethodChannel.Result? = null
    private val successRequestCode = 101
    private lateinit var paymentMethodChannel: MethodChannel
    private lateinit var context: Context
    private lateinit var paymentResult: MethodChannel.Result
    private var contacts: List<Contact> = emptyList()

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && intent.extras != null){
            CleverTapAPI.getDefaultInstance(this)?.pushNotificationClickedEvent(intent!!.extras)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        context = applicationContext
//        flutterEngine.plugins.add(MyPlugin())
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, rawResult ->
            val result: MethodChannel.Result = MethodResultWrapper(rawResult)
            isAlreadyReturend = false
            res = result

            when (call.method) {
                "createNotificationChannel" -> {

                    val argData = call.arguments as HashMap<String, String>
                    val completed = createNotificationChannel(argData)

                    returnResult(completed as Object)
                }

                getUpiApps -> getupiApps()
                intiateTransaction -> startTransation(
                    call.argument<String>("app").toString(),
                    call.argument<String>("deepLinkUrl").toString()
                )

                else -> result.notImplemented();
            }
        }
        //METHOD CHANNEL [2]
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            DEVICEDATACHANNEL
        ).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, rawResult ->
            val result: MethodChannel.Result = MethodResultWrapper(rawResult)
            if (call.method == "getInstalledApps") {
                val installedAppsList = getInstalledApplications()
                if (installedAppsList.size != 0) {
                    result.success(installedAppsList)
                } else {
                    result.error("UNAVAILABLE", "Installed Apps information not available", null)
                }
            } else if (call.method == "getDeviceId") {
                val id: String = getUniqueDeviceId(context)
                result.success(id)
            } else if (call.method == "getAndroidId") {
                result.success(getAndroidId())
            } else if (call.method == "isDeviceRooted") {
                result.success(RootCheckService().isDeviceRooted())
            } else if (call.method == "updateHomeScreenWidget") {
                result.success(updateHomeScreenWidget())
            } else {
                result.notImplemented()
            }
        }

        paymentMethodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, UPIINTENTCHANNEL)
        paymentMethodChannel.setMethodCallHandler {
            // This method is invoked on the main thread.
                call, rawResult ->
            val result: MethodChannel.Result = MethodResultWrapper(rawResult)

            when (call.method) {
                "initiatePsp" -> {
                    paymentResult = result
                    var argsData = call.arguments as HashMap<*, *>
                    val intentUrl: String = argsData["redirectUrl"] as String
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

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CONTACTCHANNEL
        ).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, rawResult ->
            val result: MethodChannel.Result = MethodResultWrapper(rawResult)
            if (call.method == "getContacts") {
                loadContacts()
                result.success(contacts.map { contact ->
                    mapOf(
                        "displayName" to contact.displayName,
                        "phoneNumber" to contact.phoneNumber
                    )
                })
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == successRequestCode) {
            data?.let { intentData ->
                try {
                    val response = intentData.getStringExtra("response")
                    val resultCode = intentData.getIntExtra("resultCode", 0)
                    paymentResult.success(response as Object?)
                } catch (e: Exception) {
                    // Handle any exception that may occur
                    paymentResult.error("RESULT_ERROR", "Error processing result", null)
                    Log.e("OnActivityResult", "Error processing result: ${e.message}")
                }
            } ?: run {
                // Handle the case when data is null
                paymentResult.error("RESULT_NULL", "Result data is null", null)
                Log.e("OnActivityResult", "Result data is null")
            }
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
        Log.d("MainActivity", "Calling AndroidID");
        return Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID);
    }

    private fun updateHomeScreenWidget(): String? {
        Log.d("MainActivity", "SHOURYA updateWidget() triggered from Flutter")

        val appWidgetManager = AppWidgetManager.getInstance(this)
        val widgetProvider = ComponentName(applicationContext, MyWidgetProvider::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(widgetProvider)

        // Update the widget content and notify changes
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.balance_widget_layout)
            val felloBalance = MyWidgetProvider.getFormattedFelloBalance(applicationContext)
            views.setTextViewText(R.id.amount_text, felloBalance)

            // Update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        return "DONE";
    }

    @SuppressLint("QueryPermissionsNeeded")
    private fun getInstalledApplications(): ArrayList<HashMap<String, Any?>> {
        try {
            val packageManager = context.packageManager
            val installedApps =
                packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
            val userApps = installedApps.filter {
                (it.flags and ApplicationInfo.FLAG_SYSTEM) != ApplicationInfo.FLAG_SYSTEM
            }
            val apps: ArrayList<HashMap<String, Any?>> = ArrayList()
            for (app in userApps) {
                val appName = app.loadLabel(packageManager).toString()
                val appData: HashMap<String, Any?> = HashMap<String, Any?>()
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

    private var isAlreadyReturend = false

    private fun returnResult(re: Object?) {
        if (re == null) {
            return;
        }
        if (!isAlreadyReturend) {
            isAlreadyReturend = true
            res?.success(re);
        }

    }


    @SuppressLint("SuspiciousIndentation")
    private fun startTransation(app: String, deepLink: String) {

        try {


            val uri = Uri.parse(deepLink)
            val deepLinkIntent = Intent(Intent.ACTION_VIEW, uri)
            deepLinkIntent.setPackage(app)
            if (deepLinkIntent.resolveActivity(context.packageManager) == null) {
                res?.error("400", "No App Found", "No UPI Apps Found")
                return
            } else
                this.startActivityForResult(deepLinkIntent, successRequestCode)


        } catch (e: Exception) {
            Log.d("Something went Wrong:", "$e")
            e.printStackTrace()
        }
    }


    private fun getupiApps() {

        val packageManager = context.packageManager
        val mainIntent = Intent(Intent.ACTION_VIEW)
        // mainIntent.addCategory(Intent.CATEGORY_DEFAULT)
        // mainIntent.addCategory(Intent.CATEGORY_BROWSABLE)
        // mainIntent.action = Intent.ACTION_VIEW
        // val uri1 = Uri.parse("upi://pay")
        mainIntent.data = Uri.parse("upi://pay")
        var list = mutableListOf<Map<String, String>>()

        try {
            val activities =
                packageManager.queryIntentActivities(mainIntent, PackageManager.MATCH_DEFAULT_ONLY)
            Log.d(activities.toString(), "UPI Apps Present")
            // Convert the activities into a response that can be transferred over the channel.

            for (it in activities) {
                val packageName = it.activityInfo.packageName
                Log.d(packageName, "package name");
                val drawable = packageManager.getApplicationIcon(packageName)

                val bitmap = getBitmapFromDrawable(drawable)
                val icon = if (bitmap != null) {
                    encodeToBase64(bitmap)
                } else {
                    null
                }
                var map = mapOf(
                    "packageName" to packageName,
                    "icon" to icon,
                    "priority" to it.priority,
                    "preferredOrder" to it.preferredOrder
                )
                list.add(
                    map as Map<String, String>
                )
            }


            Log.d(list.size.toString(), "List")
            returnResult(list as Object)

        } catch (ex: Exception) {
            Log.e("UPI", ex.message!!)
            res?.error("400", "exception", ex.message)
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
        val bmp: Bitmap = Bitmap.createBitmap(
            drawable.intrinsicWidth,
            drawable.intrinsicHeight,
            Bitmap.Config.ARGB_8888
        )
        val canvas = Canvas(bmp)
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight())
        drawable.draw(canvas)
        return bmp
    }

    private fun loadContacts() {
        val contentResolver: ContentResolver = applicationContext.contentResolver
        val projection: Array<String> = arrayOf(
            ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME,
            ContactsContract.CommonDataKinds.Phone.NUMBER
        )
        val cursor: Cursor? = contentResolver.query(
            ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
            projection,
            null,
            null,
            null
        )
        cursor?.use {
            contacts = generateSequence { if (cursor.moveToNext()) cursor else null }
                .map { Contact(it.getString(0), it.getString(1)) }
                .toList()
        }
    }
}


private class MethodResultWrapper internal constructor(private val methodResult: MethodChannel.Result) :
    MethodChannel.Result {
    private val handler: Handler
    override fun success(result: Any?) {
        handler.post(
            Runnable { methodResult.success(result) })
    }

    override fun error(
        errorCode: String, errorMessage: String?, errorDetails: Any?
    ) {
        handler.post(
            Runnable { methodResult.error(errorCode, errorMessage, errorDetails) })
    }

    override fun notImplemented() {
        handler.post(
            Runnable { methodResult.notImplemented() })
    }

    init {
        handler = Handler(Looper.getMainLooper())
    }
}

data class Contact(val displayName: String, val phoneNumber: String)
