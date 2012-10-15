#include "contacts.h"

Contacts::Contacts(QObject *parent) :
    QObject(parent)
{
    QSettings setting("IndependentSoft", "DoNotDisturbMode");
    m_whiteList = setting.value("whiteListId", QVariantList()).toList();
}

QList<QContactLocalId> Contacts::convertToUList(const  QVariantList &vl)
{
    QList<QContactLocalId> uList;
    for (int i = 0; i < vl.size(); i++) {
        uList.append(vl[i].toUInt());
    }
    return uList;
}

QVariantList Contacts::getAll()
{
    if (m_buffer.size())
        return m_buffer;

    QContactDetailFilter filter;
    filter.setDetailDefinitionName(QContactPhoneNumber::DefinitionName, QContactPhoneNumber::FieldNumber);

    QList<QContactSortOrder> lQcSort;
    QContactSortOrder sort;
    sort.setDetailDefinitionName(QContactDisplayLabel::DefinitionName, QContactDisplayLabel::FieldLabel);
    sort.setDirection(Qt::AscendingOrder);
    sort.setCaseSensitivity(Qt::CaseInsensitive);
    lQcSort.append(sort);

    m_buffer = get(m_cm.contacts(filter, lQcSort));
    return m_buffer;
}

QVariantList Contacts::getWhiteList()
{
    return get(m_cm.contacts(convertToUList(m_whiteList)));
}

void Contacts::addWhiteList(const  QVariantList &wl)
{
    m_whiteList += wl;
}

void Contacts::updateWhiteList(const  QVariantList &wl)
{
    m_whiteList = wl;
}

void Contacts::clearWhiteList()
{
    m_whiteList.clear();
}

void Contacts::save()
{
    QSettings setting("IndependentSoft", "DoNotDisturbMode");
    setting.setValue("whiteListId", m_whiteList);

    QStringList wlNumbers;
    QList<QContact> cl = m_cm.contacts(convertToUList(m_whiteList));
    for (int i = 0; i < cl.size(); i++) {
        QList<QContactPhoneNumber> qp = cl[i].details<QContactPhoneNumber>();
        for (int j = 0; j < qp.size(); j++) {
            wlNumbers.append(qp[j].number());
        }
    }
    setting.setValue("whiteList", wlNumbers);
}

QVariantList Contacts::get(const QList<QContact> &contactList)
{
    QVariantList list;
    QVariantMap obj;

    for (int i = 0; i < contactList.size(); i++) {
        QContact ct = contactList[i];

        obj.insert("name", ct.displayLabel());
        obj.insert("id", ct.localId());
        obj.insert("section", "");
        obj.insert("bSelect", false);

        QUrl imgUrl = ct.detail<QContactAvatar>().imageUrl();
        if (imgUrl != QUrl("")) {
            obj.insert("imgUrl", imgUrl.toString());
        }

//        QVariantList numberList;
//        QVariantMap tmp;
//        QList<QContactPhoneNumber> qp = ct.details<QContactPhoneNumber>();
//        for (int j = 0; j < qp.length(); j++) {
//            tmp.insert("name", qp[j].number());
//            numberList.append(tmp);
//            tmp.clear();
//        }
//        obj.insert("number", numberList);
        list.append(obj);
        obj.clear();
    }
    return list;
}

