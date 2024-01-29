package `in`.fello.felloapp

import com.clevertap.android.sdk.pushnotification.fcm.CTFcmMessageHandler
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.appsflyer.AppsFlyerLib

class MyFirebaseMessagingService : FirebaseMessagingService() {

    private val mHandler = CTFcmMessageHandler()

    override fun onNewToken(s: String) {
        super.onNewToken(s)
        AppsFlyerLib.getInstance().updateServerUninstallToken(applicationContext, s)
        mHandler.onNewToken(applicationContext, s)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        val data: Map<String, String> = remoteMessage.data
        mHandler.createNotification(applicationContext, remoteMessage)
    }
}
