package `in`.fello.felloapp

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.util.Log
import `in`.fello.felloapp.R
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import android.content.SharedPreferences
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel


class MyWidgetProvider : AppWidgetProvider() {
    companion object {
        const val ACTION_BUTTON_CLICK = "com.example.ACTION_BUTTON_CLICK"

        fun getFormattedFelloBalance(context: Context): String {
            try {
                val sharedPreferences: SharedPreferences = context.getSharedPreferences(
                    "FlutterSharedPreferences", Context.MODE_PRIVATE
                )
                Log.d(
                    "MyWidgetProvider",
                    sharedPreferences.getString("flutter.felloBalance", "0.00") ?: "N/A"
                )
                val balanceStr = sharedPreferences.getString("flutter.felloBalance", "N/A")

                val doubleNumber = balanceStr?.toDouble()
                val formatter = DecimalFormat("#,##,###")
                formatter.decimalFormatSymbols = DecimalFormatSymbols.getInstance().apply {
                    groupingSeparator = ','
                }
                return "₹${formatter.format(doubleNumber)}"
            } catch (e: NumberFormatException) {
                return "₹0"
            }
        }
    }

    override fun onUpdate(
        context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            Log.d("MyWidgetProvider", "onUpdate called");
            val views = RemoteViews(context.packageName, R.layout.balance_widget_layout)

            val felloBalance = MyWidgetProvider.getFormattedFelloBalance(context)

            views.setTextViewText(R.id.amount_text, felloBalance)

            // Set the click action for the button to open a specific screen in your app
            val intent = Intent(context, MyWidgetProvider::class.java)
            intent.action = "in.fello.felloapp.ACTION_BUTTON_CLICK"
            val pendingIntent =
                PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.quick_save_button, pendingIntent)

            // Update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        Log.d("MyWidgetProvider", "onReceive called");
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        context.startActivity(launchIntent)
    }

    // private fun handleButtonClick(context: Context) {
    //     Log.d("MyWidgetProvider", "handleButtonClick called");

    //     val flutterIntent = Intent(context, MainActivity::class.java)
    //     val engine = FlutterEngineCache.getInstance().get("flutter_engine")
    //     // val channel = MethodChannel(FlutterEngineCache.getInstance().get("flutter_engine").dartExecutor.binaryMessenger, "methodChannel/deviceData")
    //     val messenger = engine?.dartExecutor?.binaryMessenger
    //     if(messenger != null) {

    //         val channel = MethodChannel(messenger, "methodChannel/deviceData")

    //         channel.invokeMethod("openAssetSelection", flutterIntent)
    //     }
    // }

    private fun formatBalance(value: String?): String {
        try {
            val doubleNumber = value?.toDouble()
            val formatter = DecimalFormat("#,##,###.00")
            formatter.decimalFormatSymbols = DecimalFormatSymbols.getInstance().apply {
                groupingSeparator = ','
            }
            return "₹${formatter.format(doubleNumber)}"
        } catch (e: NumberFormatException) {
            return "N/A"
        }
    }
}