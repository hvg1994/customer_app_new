# gwc_customer

A new Flutter project.

## Getting Started

************Note for Zoom SDK **********************

Unzip zoom sdk for accessing using below command

"flutter pub run flutter_zoom_plugin:unzip_zoom_sdk"


***************************************************

To Open Drive link we need this format
'https://drive.google.com/uc?export=view&id=1RaM7eOiwLG3dbawaOFsQoR_nl9jtUpPK'

file structure:

lib-------
---model--------> deserialized Json response
---repository---> apiService and all other repositories
---screens------> All UI
---services-----> service class
---utils--------> All Constants, enums, AppConfig
---widgets------> Custom Widgets


****  calling api code from ui  ********

* we need to create repository object on this class
* need to pass the http.client from each class to that particular repository
* create object for service class -> for service class object we need to send that created repository
* so that it will call the api class functions from service class
*
* once we got response we r checking for the successModel and ErrorModel
* here While getting api response on each screens we r checking for the runtimeType
* if we got ErrorModel type that we r showing the error
* if we get the success response than we r adding to that respective Model class to serialize.
