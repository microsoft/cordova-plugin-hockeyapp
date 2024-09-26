### As of March 2019, this repo is no longer maintained by Microsoft. If you're interested in continuing this project, please feel free to fork it. As of March 2019, we will no longer monitor or respond to open issues. Thanks for your support!

---

# cordova-plugin-hockeyapp

This plugin exposes the HockeyApp SDK for iOS and Android

Including:

* HockeyAppSDK-iOS 3.8.2
* HockeyAppSDK-Android 3.5.0

## Installation

    cordova plugin add cordova-plugin-hockeyapp

## Supported Platforms

- Android
- iOS

## Methods

Initialize HockeyApp SDK:
```
hockeyapp.start(success:function, error:function, appId:string, autoSend:boolean, ignoreDefaultHandler:boolean, loginMode:int, appSecret:string):void
```



When specifying the `loginMode`, it is recommended that you use the `hockeyapp.loginMode` enumeration. Available values are:

- ANONYMOUS: The user will not be prompted to authenticate.
- EMAIL_ONLY: The user will be prompted to specify a valid email address. You must also pass your `appSecret` when using this mode.
- EMAIL_PASSWORD: The user will be prompted for a valid username/password combination.
- VALIDATE: The user will not be prompted to authenticate, but the app will try to validate with the HockeyApp service.

Important: Only ANONYMOUS is available for iOS devices, other modes will produce an error.

Display tester feedback user interface:
```
hockeyapp.feedback(success:function, error:function):void
```

Check for a new version:
```
hockeyapp.checkForUpdate(success:function, error:function):void
```

Force an app crash:
```
hockeyapp.forceCrash():void
```

Add arbitrary metadata to a crash, which will be displayed in crash reports:
```
hockeyapp.addMetaData(success:function, error:function, data:object):void
```
