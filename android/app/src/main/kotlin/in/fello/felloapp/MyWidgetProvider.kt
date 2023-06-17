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


class MyWidgetProvider : AppWidgetProvider() {
    companion object {
        fun getFormattedFelloBalance(context: Context): String {
            try{
                val sharedPreferences: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences",
                Context.MODE_PRIVATE
                )
                Log.d("MyWidgetProvider", sharedPreferences.getString("flutter.felloBalance","0.00")?: "0.00")
                val balanceStr = sharedPreferences.getString("flutter.felloBalance","0.0")

                val doubleNumber = balanceStr?.toDouble()
                val formatter = DecimalFormat("#,##,###.00")
                formatter.decimalFormatSymbols = DecimalFormatSymbols.getInstance().apply {
                    groupingSeparator = ','
                }
                return "₹${formatter.format(doubleNumber)}"
            }catch(e: NumberFormatException) {
                return "N/A"
            }
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            Log.d("MyWidgetProvider", "onUpdate called");
            val views = RemoteViews(context.packageName, R.layout.balance_widget_layout)

            val felloBalance = MyWidgetProvider.getFormattedFelloBalance(context)

            views.setTextViewText(R.id.amount_text, felloBalance)

            // Set the click action for the button to open a specific screen in your app
            // val intent = Intent(context, SpecificActivity::class.java)
            // val pendingIntent = PendingIntent.getActivity(context, 0, intent, 0)
            // views.setOnClickPendingIntent(R.id.quick_save_button, pendingIntent)

            // Update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun formatBalance(value: String?): String {
       try{
            val doubleNumber = value?.toDouble()
            val formatter = DecimalFormat("#,##,###.00")
            formatter.decimalFormatSymbols = DecimalFormatSymbols.getInstance().apply {
                groupingSeparator = ','
            }
            return "₹${formatter.format(doubleNumber)}"
       }catch(e: NumberFormatException) {
            return "N/A"
       }
    }
}