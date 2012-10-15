#include "callwatchdog.h"

CallWatchdog::CallWatchdog(QObject *parent) :
    QObject(parent)
{
    QDBusConnection sessionBus = QDBusConnection::sessionBus();
    if (!sessionBus.registerObject(SELF_BUS_PATH, this, QDBusConnection::ExportAllSlots|QDBusConnection::ExportAllSignals)) {
        qDebug() << "registerObject error!";
        emit quit();
        return;
    }

    if (!sessionBus.registerService(SELF_BUS_NAME)) {
        qDebug() << "registerService error!";
        emit quit();
        return;
    }
    m_bWorking = false;
    loadSetting();

    if (m_bActive)
        start();

    m_lastCallTime = 0;
    m_bIsNeedRecoverSound = false;
}

CallWatchdog::~CallWatchdog()
{
    stop();
    QDBusConnection sessionBus = QDBusConnection::sessionBus();
    sessionBus.unregisterService(SELF_BUS_NAME);
    sessionBus.unregisterObject(SELF_BUS_PATH);
}

void CallWatchdog::sound(bool bVoiced)
{
    QDBusInterface iface(PROFILE_BUS_NAME, PROFILE_BUS_PATH, PROFILE_INSTANCE_INTERFACE);
    if (!bVoiced) {
        m_profile = iface.call("get_profile").arguments()[0].toString();
        m_vibrat = iface.call("get_value", m_profile, KEY_VIBRAT).arguments()[0].toString();
        if (m_vibrat == "On") {
            iface.call("set_value", m_profile, KEY_VIBRAT, "Off");
        }

        if (m_profile == PROFILE_SILENT) {
            return;
        }

        m_systemSoundLevel = iface.call("get_value", m_profile, KEY_SYSTEM_SOUND_LEVEL).arguments()[0].toString();
        iface.call("set_value", m_profile, KEY_SYSTEM_SOUND_LEVEL, SYSTEM_NO_SOUND);

        if (m_profile == PROFILE_GENERAL) {
            m_soundFilePath = iface.call("get_value", m_profile, KEY_RING_TONE).arguments()[0].toString();
            iface.call("set_value", m_profile, KEY_RING_TONE, NO_SOUND_FILE);
        }
    }else{
        if (m_vibrat == "On") {
            iface.call("set_value", m_profile, KEY_VIBRAT, m_vibrat);
        }

        if (m_profile == PROFILE_SILENT) {
            return;
        }

        QTimer::singleShot(5000, this, SLOT(recoverSystemSound()));

        if (m_profile == PROFILE_GENERAL) {
            iface.call("set_value", m_profile, KEY_RING_TONE, m_soundFilePath);
        }
    }
}

bool CallWatchdog::isRepeatedCall(const QString &number)
{
    if (!m_bRepeatedCall)
        return false;

    bool ret = false;
    uint currentTime = QDateTime::currentDateTime().toTime_t();

    ret = (m_lastCallNumber != number)?false:(((currentTime - m_lastCallTime) <= 3*60)?true:false);
    m_lastCallNumber = number;
    m_lastCallTime = currentTime;

    return ret;
}

bool CallWatchdog::isInWeekRange()
{
    QDate currentDate = QDate::currentDate();
    for (int i = 0; i < m_weekDays.size(); i++) {
        if (m_weekDays[i].toInt() == currentDate.dayOfWeek())
            return true;
    }
    return false;
}

bool CallWatchdog::isInTimeRange()
{
    QTime currentTime = QTime::currentTime();
    if (m_startTime < m_endTime) {
        if (currentTime < m_startTime || currentTime > m_endTime)
            return false;
    }else {
        if (currentTime > m_startTime && currentTime < m_endTime)
            return false;
    }

    return true;
}

bool CallWatchdog::isInWhiteList(const QString &number)
{
    for (int i = 0; i < m_whiteList.size(); i++) {
        if (m_whiteList[i] == number)
            return true;
    }
    return false;
}

void CallWatchdog::filter(const QDBusObjectPath &call, const QString &number)
{
//    if (!isInWeekRange())
//        return;

    if (!isInTimeRange())
        return;

    if (isRepeatedCall(number)) {
        return;
    }

    if (isInWhiteList(number)) {
        return;
    }

    m_bIsNeedRecoverSound = true;
    sound(false);
}

void CallWatchdog::callTerminated()
{
    if (!m_bIsNeedRecoverSound)
        return;

    m_bIsNeedRecoverSound = false;
    sound(true);
}

void CallWatchdog::recoverSystemSound()
{
    QDBusInterface iface(PROFILE_BUS_NAME, PROFILE_BUS_PATH, PROFILE_INSTANCE_INTERFACE);
    iface.call("set_value", m_profile, KEY_SYSTEM_SOUND_LEVEL, m_systemSoundLevel);
}

void CallWatchdog::start()
{
    if (m_bWorking)
        return;
    m_bWorking = true;
    QDBusConnection systemBus = QDBusConnection::systemBus();
    if (!systemBus.connect(
                CALL_BUS_NAME,
                CALL_BUS_PATH,
                CALL_BUS_NAME,
                "Coming",
                this,
                SLOT(filter(const QDBusObjectPath&, const QString&)))){
        qDebug() << "dbus connect signal Coming error!";
        emit quit();
        return;
    }

    if (!systemBus.connect(
                CALL_BUS_NAME,
                CALL_BUS_TERM_PATH,
                CALL_INSTANCE_INTERFACE,
                "Terminated",
                this,
                SLOT(callTerminated()))){
        qDebug() << "dbus connect signal Terminated error!";
        emit quit();
        return;
    }
}

void CallWatchdog::stop()
{
    if (!m_bWorking)
        return;
    m_bWorking = false;
    QDBusConnection systemBus = QDBusConnection::systemBus();
    systemBus.disconnect(
                CALL_BUS_NAME,
                CALL_BUS_TERM_PATH,
                CALL_BUS_NAME,
                "Terminated",
                this,
                SLOT(callTerminated()));

    systemBus.disconnect(
                CALL_BUS_NAME,
                CALL_BUS_PATH,
                CALL_BUS_NAME,
                "Coming",
                this,
                SLOT(filter(const QDBusObjectPath&, const QString&)));
}

void CallWatchdog::loadSetting()
{
    QSettings setting("IndependentSoft", "DoNotDisturbMode");
    m_bActive = setting.value("active", false).toBool();
    if (!m_bActive) {
        stop();
        return;
    }else{
        start();
    }

    m_bRepeatedCall = setting.value("repeatedCall", false).toBool();
    m_whiteList = setting.value("whiteList", QStringList()).toStringList();

//    m_weekDays = setting.value("weekDays", "").toString().split(",");
    m_startTime = QTime::fromString(setting.value("startTime", "00:00").toString(), "hh:mm");
    m_endTime = QTime::fromString(setting.value("endTime", "00:00").toString(), "hh:mm");
}
