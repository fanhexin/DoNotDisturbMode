#-------------------------------------------------
#
# Project created by QtCreator 2012-10-10T11:45:30
#
#-------------------------------------------------

QT       += core dbus

QT       -= gui

TARGET = DoNotDisturbd
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += main.cpp \
    callwatchdog.cpp

contains(MEEGO_EDITION,harmattan) {
    target.path = /opt/DoNotDisturb/bin
    INSTALLS += target
}

mydaemon.path = /etc/init/apps
mydaemon.files = ./DoNotDisturb.conf

INSTALLS += mydaemon

HEADERS += \
    callwatchdog.h
