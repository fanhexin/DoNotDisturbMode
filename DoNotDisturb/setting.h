#ifndef SETTING_H
#define SETTING_H

#include <QtCore>
#include <QtDBus>

class Setting : public QObject
{
    Q_OBJECT
public:
    explicit Setting(QObject *parent = 0);
    
signals:
    
public slots:
    void save();

    bool getActive();
    void setActive(bool b);

    bool getRepeatedCall();
    void setRepeatedCall(bool b);

    QString getWeekDays();
    void setWeekDays(const QString &w);

    QString getStartTime();
    void setStartTime(const QString &t);

    QString getEndTime();
    void setEndTime(const QString &t);

    void setWhiteList(const QString &wl);
    
private:
    bool m_bActive;
    bool m_bRepeatedCall;
    QString m_weekDays;
    QString m_startTime;
    QString m_endTime;
    QString m_whiteList;
};

#endif // SETTING_H
