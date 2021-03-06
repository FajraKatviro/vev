TEMPLATE = app

QT += qml quick multimedia
CONFIG += c++11

SOURCES += main.cpp \
    somecountry.cpp \
    politicalgroup.cpp \
    peoplegroup.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $PWD $PWD/gdServer

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    somecountry.h \
    politicalgroup.h \
    peoplegroup.h

OTHER_FILES += description.txt \
                gdServer/*

VEV_DEV = true

!isEmpty(VEV_DEV):{
    !ios:!android{
        VEV_MODE = local
    } else {
        VEV_MODE = remote
    }
}else{
    VEV_MODE = embedded
}

isEqual(VEV_MODE,embedded){
    RESOURCES += server.qrc
}

isEqual(VEV_MODE,local){
    RAW_CONTENT = gdServer/CountryView.qml \
                  gdServer/MainSettings.qml \
                  gdServer/PlayerView.qml \
                  gdServer/PoliticalActionList.qml \
                  gdServer/VevGame.qml
    FK += content
}

isEqual(VEV_MODE,remote){
    DEFINES += VEV_REMOTE
}

ART_FOLDER = $$PWD/../vevBuild/art/imagesets
ART_BUILD_FOLDER = $$PWD/../vevBuild/resourceBuild/vev/imagesets
DEPLOY_BUILD_FOLDER = $$PWD/../vevBuild/deployBuild
DESTDIR = $$PWD/../vevBuild/deployedApp


SHORT_DESCRIPTION = "Game about policy"
LONG_DESCRIPTION = $$PWD/description.txt
QMAKE_TARGET_PRODUCT = VEV
QMAKE_TARGET_COMPANY = 'Fajra Katviro'
VERSION = 1.0.0

FK +=  helpers

ios{
    FK += mobile
}
android{
    FK += mobile
}

!ios:!android:{
    #FK += deploy
}

FK_IOS_PLIST = $$PWD/Info.plist
ios:FK_MOBILE_ICONS = $$PWD/art/iosIcons
android:FK_MOBILE_ICONS = $$PWD/art/androidIcons
mac{
    ICON = $$PWD/art/desktopIcons/icon.icns
}else{
    ICON = $$PWD/art/desktopIcons/icon_128x128.png
}
RC_ICONS = $$PWD/art/desktopIcons/icon.ico


include(fkframework/fkframework.pri)
