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
    explicit Contacts();

signals:

public slots:
    QVariantList getAll();

private:
    QVariantList get(const QList<QContact> &contactList);
    QContactManager m_cm;
};

#endif // CONTACTS_H
