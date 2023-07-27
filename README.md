# gwc_customer

A new Flutter project.

## Getting Started

************Note for Zoom SDK **********************

Unzip zoom sdk for accessing using below command

"flutter pub run flutter_zoom_plugin:unzip_zoom_sdk"


***************************************************

#file structure:

lib-------
---model--------> deserialized Json response
---repository---> apiService and all other repositories
---screens------> All UI
---services-----> service class
---utils--------> All Constants, enums, AppConfig
---widgets------> Custom Widgets

**** Notification Payload For User App *******
please refer payload file in path: C:\fembuddy\fembuddy projects\gwc_customer\lib\payload

#****  calling api code from ui  ********

* we need to create repository object on this class
* need to pass the http.client from each class to that particular repository
* create object for service class -> for service class object we need to send that created repository
* so that it will call the api class functions from service class
*
* once we got response we r checking for the successModel and ErrorModel
* here While getting api response on each screens we r checking for the runtimeType
* if we got ErrorModel type that we r showing the error
* if we get the success response than we r adding to that respective Model class to serialize.


# Note for Release aab

on each release change the version No. in AppConfig file-> androidVersion parameter
and we need to inform to update in the backend also

we r checking old apk version and new version if any difference than we r showing to open playstore in spalshscreen

last updated version is 21
changed to 22

** kept jks file inside this project only

# building App

while building apk or running app if u face any error from
(Need Changes in pubspec.lock file)
** firebase_core change firebase_core_platform_interface version to "4.5.1"
** package_info_plus_windows-2.1.0  than 
go to that file and remove ? on those lines