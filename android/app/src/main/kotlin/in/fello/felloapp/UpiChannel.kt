package `in`.fello.felloapp

import androidx.appcompat.app.AppCompatActivity
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Bundle
import android.util.Base64
import android.util.Log
import java.io.ByteArrayOutputStream

enum class UPIMethod{
    getApps,
    startTransaction
}

class UpiChannel:AppCompatActivity(){
    private var requestCodeNumber = 201119
    private val activity=Activity()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
         val type=intent.getSerializableExtra("type") as UPIMethod

        when(type){
           UPIMethod.startTransaction->startTransation()
           UPIMethod.getApps->getupiApps()

        }

    }


    private fun startTransation(){
        val app=intent.getStringExtra("app")
        val deepLink=intent.getStringExtra("deepLink")

        try {
            val uri = Uri.parse(deepLink)
            val deepLinkIntent=Intent(Intent.ACTION_VIEW)
            deepLinkIntent.data = uri;
            deepLinkIntent.setPackage(app)
            if(intent.resolveActivity(activity.packageManager)==null){
                result(400,"No App Found")
                return
            }
            activity.startActivityForResult(deepLinkIntent, requestCodeNumber)



        }catch (e: Exception){
            Log.d("Something went Wrong:" ,"$e")
            e.printStackTrace()
        }
    }


    private fun getupiApps(){
        val uriBuilder = Uri.Builder()
        uriBuilder.scheme("upi").authority("pay")

        val uri = uriBuilder.build()
        val intent = Intent(Intent.ACTION_VIEW, uri)

        val packageManager = activity.packageManager

        try {
            val activities = packageManager.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)

            // Convert the activities into a response that can be transferred over the channel.
            val activityResponse = activities.map {
                val packageName = it.activityInfo.packageName
                val drawable = packageManager.getApplicationIcon(packageName)

                val bitmap = getBitmapFromDrawable(drawable)
                val icon = if (bitmap != null) {
                    encodeToBase64(bitmap)
                } else {
                    null
                }

                mapOf(
                    "packageName" to packageName,
                    "icon" to icon,
                    "priority" to it.priority,
                    "preferredOrder" to it.preferredOrder
                )
            }
        result(200,"success",result = activities)

        } catch (ex: Exception) {
            Log.e("upi_pay", ex.toString())
            result(400, "exception", )
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCodeNumber == requestCode ) {
            if (data != null) {
                try {
                    val response = data.getStringExtra("response")!!
                    result(200,response,)
                } catch (ex: Exception) {
                    result(400,"invalid_response")
                }
            } else {
                result(401,"user_cancelled")
            }
        }

        super.onActivityResult(requestCode, resultCode, data)

    }

    private fun result(error:Int, message: String, result: List<ResolveInfo> = emptyList()) {
        val resultIntent = Intent()


            resultIntent.putExtra("error", error)

            resultIntent.putExtra("message", message)

        resultIntent.putExtra("apps",result.toTypedArray())

        setResult(Activity.RESULT_OK, resultIntent)
        finish()
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