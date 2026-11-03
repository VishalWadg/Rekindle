# Flutter essential wrapper rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Preserve generic type signatures, inner classes, and annotations
# Crucial for Gson TypeToken reflection used by flutter_local_notifications
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes *Annotation*
-keepattributes EnclosingMethod

# Gson rules
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Flutter Local Notifications plugin and model classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Line numbers for crash reports
-keepattributes SourceFile,LineNumberTable
