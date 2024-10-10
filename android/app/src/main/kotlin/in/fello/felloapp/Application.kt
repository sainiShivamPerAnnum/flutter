package `in`.fello.felloapp
import android.graphics.Color
import android.util.Log
import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.app.FlutterApplication
import com.clevertap.android.sdk.ActivityLifecycleCallback;
import com.webengage.sdk.android.LocationTrackingStrategy
import com.webengage.sdk.android.WebEngage
import com.webengage.sdk.android.WebEngageConfig
import com.webengage.webengage_plugin.WebengageInitializer


class Application : FlutterApplication() {
    override fun onCreate() {
        ActivityLifecycleCallback.register(this);
        super.onCreate()

        val webEngageConfig = WebEngageConfig.Builder()
            .setPushSmallIcon(R.drawable.ic_action_name)
            .setPushAccentColor(Color.parseColor("#43BEA4"))
            .setWebEngageKey(getString(R.string.webengage_code))
            .setAutoGCMRegistrationFlag(false)
            .setLocationTrackingStrategy(LocationTrackingStrategy.ACCURACY_BEST)
            .setDebugMode(true) // only in development mode
            .build()
        WebengageInitializer.initialize(this, webEngageConfig)


        FirebaseMessaging.getInstance().token.addOnCompleteListener {
            if (!it.isSuccessful) {
                Log.d("Native Error", "Fetching FCM registration token failed", it.exception)
                return@addOnCompleteListener;
            }

            val token = it.result
            WebEngage.get().setRegistrationID(token)
        }

    }


}
