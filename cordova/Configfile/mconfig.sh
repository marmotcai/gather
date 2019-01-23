#!/bin/sh
set -x

sed -i '/<widget.*>/{s|>| xmlns:android="http://schemas.android.com/apk/res/android">|;}' config.xml
sed -i '/<platform name="android">/a\<icon density="ldpi" src="res/icon/android/icon-36-ldpi.png" />\n<icon density="mdpi" src="res/icon/android/icon-48-mdpi.png" />\n<icon density="hdpi" src="res/icon/android/icon-72-hdpi.png" />\n<icon density="xhdpi" src="res/icon/android/icon-96-xhdpi.png" />\n<icon density="xxhdpi" src="res/icon/android/icon-144-xxhdpi.png" />\n' config.xml
sed -i '/<platform name="android">/a\<edit-config file="app/src/main/AndroidManifest.xml" target="/manifest/supports-screens" mode="merge">\n<supports-screens android:resizeable="true"\nandroid:smallScreens="true"\nandroid:normalScreens="true"\nandroid:largeScreens="true"\nandroid:anyDensity="true" />\n</edit-config>' config.xml

