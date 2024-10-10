package `in`.fello.felloapp

import com.clevertap.android.sdk.pushnotification.fcm.CTFcmMessageHandler
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.appsflyer.AppsFlyerLib
import com.webengage.sdk.android.WebEngage

class MyFirebaseMessagingService : FirebaseMessagingService() {

    private val mHandler = CTFcmMessageHandler()

    override fun onNewToken(s: String) {
        super.onNewToken(s)
        WebEngage.get().setRegistrationID(s)
        AppsFlyerLib.getInstance().updateServerUninstallToken(applicationContext, s)
        mHandler.onNewToken(applicationContext, s)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        val data: Map<String, String> = remoteMessage.data
        if (data.containsKey("source") && "webengage" == data["source"]) {
            WebEngage.get().receive(data)
        }
        mHandler.createNotification(applicationContext, remoteMessage)
    }
}
