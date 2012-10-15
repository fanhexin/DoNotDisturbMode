#include "setting.h"

Setting::Setting(QObject *parent) :
    QObject(parent)
{
    QSettings setting("IndependentSoft", "DoNotDisturbMode");
    m_bActive = setting.value("active", false).toBool();
    m_bRepeatedCall = setting.value("repeatedCall", false).toBool();
//    m_weekDays = setting.value("weekDays", "").toString();
    m_startTime = setting.value("startTime", "00:00").toString();
    m_endTime = setting.value("endTime", "00:00").toString();
}

void Setting::save()
{
    QSettings setting("IndependentSoft", "DoNotDisturbMode");
    setting.setValue("active", m_bActive);
    setting.setValue("repeatedCall", m_bRepeatedCall);
//    setting.setValue("weekDays", m_weekDays);
    setting.setValue("startTime", m_startTime);
    setting.setValue("endTime", m_endTime);
}

bool Setting::getActive()
{
    return m_bActive;
}

void Setting::setActive(bool b)
{
    m_bActive = b;
}

bool Setting::getRepeatedCall()
{
    return m_bRepeatedCall;
}

void Setting::setRepeatedCall(bool b)
{
    m_bRepeatedCall = b;
}

QString Setting::getWeekDays()
{
    return m_weekDays;
}

void Setting::setWeekDays(const QString &w)
{
    m_weekDays = w;
}

QString Setting::getStartTime()
{
    return m_startTime;
}

void Setting::setStartTime(const QString &t)
{
    m_startTime = t;
}

QString Setting::getEndTime()
{
    return m_endTime;
}

void Setting::setEndTime(const QString &t)
{
    m_endTime = t;
}




