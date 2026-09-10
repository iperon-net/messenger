# R8 / ProGuard keep rules for the Iperon messenger release build.
#
# R8 shrinks and obfuscates the app. The rules below protect code that is
# reached via reflection / JNI (and therefore invisible to static analysis),
# which R8 would otherwise strip. Add a new -keep block whenever a release-only
# crash points at a plugin removed by shrinking.

# --- Flutter engine -------------------------------------------------------
# Flutter ships its own consumer rules, but keep the embedding entry points
# explicitly to be safe with deferred components / plugins.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# --- gRPC + protobuf (lib/api.dart, lib/protobuf) -------------------------
# protobuf uses reflection on generated message classes and enum values.
-keep class com.google.protobuf.** { *; }
-keepclassmembers class * extends com.google.protobuf.GeneratedMessageLite {
    <fields>;
}
-keep class io.grpc.** { *; }
-dontwarn io.grpc.**
-dontwarn com.google.protobuf.**
# OkHttp / Conscrypt are optional transports referenced by grpc-okhttp.
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn org.conscrypt.**
-dontwarn javax.annotation.**

# --- Firebase (Crashlytics, Messaging, Remote Config) ---------------------
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
# Keep Crashlytics-relevant attributes so obfuscated stack traces stay useful.
-keepattributes SourceFile,LineNumberTable
-keepattributes *Annotation*
-keepattributes Signature,Exceptions,InnerClasses,EnclosingMethod

# --- flutter_secure_storage ----------------------------------------------
-keep class androidx.security.crypto.** { *; }
-dontwarn androidx.security.crypto.**

# --- native_workmanager / WorkManager ------------------------------------
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**

# --- local_auth (biometrics) ---------------------------------------------
-keep class androidx.biometric.** { *; }
-dontwarn androidx.biometric.**

# --- yandex_login_sdk -----------------------------------------------------
-keep class com.yandex.** { *; }
-dontwarn com.yandex.**

# --- Kotlin metadata / coroutines ----------------------------------------
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.coroutines.**

# --- Play Core (deferred components; only referenced, not bundled) --------
-dontwarn com.google.android.play.core.**

# --- Enums (accessed by valueOf via protobuf / serialization) -------------
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# --- Native methods -------------------------------------------------------
-keepclasseswithmembernames class * {
    native <methods>;
}

# --- Parcelables ----------------------------------------------------------
-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}
