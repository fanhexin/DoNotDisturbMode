#ifndef CALLWATCHDOG_H
#define CALLWATCHDOG_H

#include <QtCore>
#include <QtDBus>

#define CALL_BUS_NAME "com.nokia.csd.Call"
#define CALL_BUS_PATH "/com/nokia/csd/call"
#define CALL_BUS_TERM_PATH "/com/nokia/csd/call/1"
#define CALL_INSTANCE_INTERFACE "com.nokia.csd.Call.Instance"

#define PROFILE_BUS_NAME "com.nokia.profiled"
#define PROFILE_BUS_PATH "/com/nokia/profiled"
#define PROFILE_INSTANCE_INTERFACE PROFILE_BUS_NAME
#define PROFILE_SILENT "silent"
#define PROFILE_GENERAL "general"
#define KEY_RING_TONE "ringing.alert.tone"
#define KEY_SYSTEM_SOUND_LEVEL "system.sound.level"
#define KEY_VIBRAT "vibrating.alert.enabled"
#define NO_SOUND_FILE "/usr/share/sounds/ring-tones/No sound.wav"
#define SYSTEM_NO_SOUND "0"

#define SELF_BUS_NAME "org.oceandeep.donotdisturb"
#define SELF_BUS_PATH "/org/oceandeep/donotdisturb"

class CallWatchdog : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.oceandeep.donotdisturb")
public:
    explicit CallWatchdog(QObject *parent = 0);
    ~CallWatchdog();

    void sound(bool bVoiced);
    bool isRepeatedCall(const QString &number);
    bool isInWeekRange();
    bool isInTimeRange();
    bool isInWhiteList(const QString &number);

signals:
    void quit();

private slots:
    void filter(const QDBusObjectPath &call, const QString &number);
    void callTerminated();
    void recoverSystemSound();

public slots:
    void start();
    void stop();
    void loadSetting();

private:
    bool m_bActive;
    bool m_bRepeatedCall;
    QStringList m_whiteList;
    QStringList m_weekDays;
    QTime m_startTime;
    QTime m_endTime;

    bool m_bWorking;
    bool m_bIsNeedRecoverSound;
    QString m_profile;
    QString m_soundFilePath;
    QString m_systemSoundLevel;
    QString m_vibrat;
    QString m_lastCallNumber;
    uint m_lastCallTime;
};

#endif // CALLWATCHDOG_H
