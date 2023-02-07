-keep class org.videolan.libvlc.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }


# these are all for quickblox

#QuickBlox
-keep class org.jivesoftware.smack.initializer.VmArgInitializer { public *; }
-keep class org.jivesoftware.smack.** { *; }

##---------------Begin: proguard configuration for Gson  ----------
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
#-keep class sun.misc.Unsafe { *; }
#-keep class com.google.gson.stream.** { *; }

# Application classes that will be serialized/deserialized over Gson
-keep class com.quickblox.core.account.model.** { *; }

#quickblox sample chat
-keep class com.quickblox.auth.parsers.** { *; }
-keep class org.webrtc.** { *; }
-keep class com.quickblox.auth.model.** { *; }
-keep class com.quickblox.core.parser.** { *; }
-keep class com.quickblox.core.model.** { *; }
-keep class com.quickblox.core.server.** { *; }
-keep class com.quickblox.core.rest.** { *; }
-keep class com.quickblox.core.error.** { *; }
#-keep class com.quickblox.core.Query { *; }

-keep class com.quickblox.users.parsers.** { *; }
-keep class com.quickblox.users.model.** { *; }

-keep class com.quickblox.chat.parser.** { *; }
-keep class com.quickblox.chat.model.** { *; }

-keep class com.quickblox.messages.parsers.** { *; }
-keep class com.quickblox.messages.model.** { *; }

-keep class com.quickblox.content.parsers.** { *; }
-keep class com.quickblox.content.model.** { *; }

-keep class org.jivesoftware.** { *; }

 #sample chat
-keep class android.support.v7.** { *; }
-keep class com.bumptech.** { *; }

-dontwarn org.jivesoftware.smackx.**
-dontwarn android.support.v4.app.**