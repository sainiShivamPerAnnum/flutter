package `in`.fello.felloapp
import android.graphics.Color
import android.util.Log
import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.app.FlutterApplication
import com.clevertap.android.sdk.ActivityLifecycleCallback;


class Application : FlutterApplication() {
    override fun onCreate() {
        ActivityLifecycleCallback.register(this);
        super.onCreate()


        FirebaseMessaging.getInstance().token.addOnCompleteListener {
            if (!it.isSuccessful) {
                Log.d("Native Error", "Fetching FCM registration token failed", it.exception)
                return@addOnCompleteListener;
            }

            val token = it.result
        }

    }


}
