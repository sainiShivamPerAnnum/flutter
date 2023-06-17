package `in`.fello.felloapp

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.util.Log
import `in`.fello.felloapp.R

class MyWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            Log.d("MyWidgetProvider", "onUpdate called");
            val views = RemoteViews(context.packageName, R.layout.balance_widget_layout)

            // Update the views with your desired values and functionality
            // Fetch the balance data and update the amount_text TextView
            val balance = fetchData()
            views.setTextViewText(R.id.amount_text, String.format("%.2f", balance))

            // Set the click action for the button to open a specific screen in your app
            // val intent = Intent(context, SpecificActivity::class.java)
            // val pendingIntent = PendingIntent.getActivity(context, 0, intent, 0)
            // views.setOnClickPendingIntent(R.id.quick_save_button, pendingIntent)

            // Update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun fetchData(): Double {
        // Fetch and return the balance data from your source (e.g., database, API)
        // Replace this with your actual implementation
        return 3.0
    }
}