#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class androidx.core.content.FileProvider { *; }
-keep public class androidx.core.content.FileProvider { *; }
-keepnames class * implements android.os.Parcelable
-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *; }

-keep class android.content.res.XmlBlock { *; }
-keep class android.content.res.XmlBlock$Parser { *; }
-keep class org.xmlpull.** { *; }
-keep class android.content.res.XmlResourceParser { *; }

-keepclassmembers class **.R$xml {
   public static *;
}
-keep public class **.R$xml
-keep class com.tom_roush.pdfbox.** { *; }
-keep class org.apache.pdfbox.** { *; }
-keep class io.flutter.plugin.common.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class in.fello.felloapp.** { *; }
-keep class java.io.** { *; }
-keep class android.os.** { *; }
-keep class android.content.Intent { *; }
-keep class android.net.Uri { *; }
-keep class org.xmlpull.v1.** { *; }
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}
-dontwarn com.appsflyer.**
-keep public class com.google.firebase.messaging.FirebaseMessagingService {
    public *;
}
# Play Core - ignore missing classes if not using deferred components
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task