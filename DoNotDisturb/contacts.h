#ifndef CONTACTS_H
#define CONTACTS_H

#include <QtCore>
#include <QContactManager>
#include <QContactPhoneNumber>
#include <QContactDetailFilter>
#include <QContactAvatar>

QTM_USE_NAMESPACE

class Contacts : public QObject
{
    Q_OBJECT
public:
    explicit Contacts(QObject *parent = 0);
    QList<QContactLocalId> convertToUList(const  QVariantList &vl);

signals:

public slots:
    QVariantList getAll();
    QVariantList getWhiteList();
    void addWhiteList(const  QVariantList &wl);
    void updateWhiteList(const  QVariantList &wl);
    void clearWhiteList();
    void save();

private:
    QVariantList get(const QList<QContact> &contactList);
    QContactManager m_cm;
    QVariantList m_whiteList;
    QVariantList m_buffer;
};

#endif // CONTACTS_H
