#!/bin/sh

name="CordovaPlugins"

plugins="\
    cordova-plugin-test-framework \
    cordova-plugin-battery-status\
    cordova-plugin-camera \
    cordova-plugin-console \
    cordova-plugin-contacts \
    cordova-plugin-device \
    cordova-plugin-device-motion \
    cordova-plugin-device-orientation \
    cordova-plugin-dialogs \
    cordova-plugin-file \
    cordova-plugin-file-transfer \
    cordova-plugin-geolocation \
    cordova-plugin-globalization \
    cordova-plugin-inappbrowser \
    cordova-plugin-media \
    cordova-plugin-media-capture \
    cordova-plugin-network-information \
    cordova-plugin-splashscreen \
    cordova-plugin-statusbar \
    cordova-plugin-vibration"

patches="\
    cordova-plugin-camera \
    cordova-plugin-file"

wwwroot="cordova-mobile-spec/www"

# Create project
test "${0%/*}" != "$0" && cd "${0%/*}"
mkdir -p Build/www
cd Build
cordova create $name com.github.xwebview.cordova.plugins $name --copy-from=www

# Add platform and plugins
cd $name
cordova platform add https://github.com/xwebview/cordova-xwv.git#4.0.x
for p in $plugins; do
    cordova plugin add $p
    test -d plugins/$p/tests && cordova plugin add plugins/$p/tests
done
cd ..

# Apply local patches
for p in $patches; do
    patch -d $name/platforms/ios/$name/Plugins -p1 < ../$p.patch
done

# Prepare web assets
test -d ../$wwwroot || git submodule update --init 
cp -pr ../$wwwroot/* www
mv $name/platforms/ios/www/cdvtests www
