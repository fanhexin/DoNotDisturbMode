#include "contacts.h"

Contacts::Contacts()
{
}

QVariantList Contacts::getAll()
{
    QContactDetailFilter filter;
    filter.setDetailDefinitionName(QContactPhoneNumber::DefinitionName, QContactPhoneNumber::FieldNumber);

    QList<QContactSortOrder> lQcSort;
    QContactSortOrder sort;
    sort.setDetailDefinitionName(QContactDisplayLabel::DefinitionName, QContactDisplayLabel::FieldLabel);
    sort.setDirection(Qt::AscendingOrder);
    sort.setCaseSensitivity(Qt::CaseInsensitive);
    lQcSort.append(sort);

    return  get(m_cm.contacts(filter, lQcSort));
}

QVariantList Contacts::get(const QList<QContact> &contactList)
{
    QVariantList list;
    QVariantMap obj;

    for (int i = 0; i < contactList.size(); i++) {
        QContact ct = contactList[i];

        obj.insert("name", ct.displayLabel());
        obj.insert("id", ct.localId());
//        obj.insert("section", "");
//        obj.insert("bSelect", false);

        QUrl imgUrl = ct.detail<QContactAvatar>().imageUrl();
        if (imgUrl != QUrl("")) {
            obj.insert("imgUrl", imgUrl.toString());
        }

        QString numberList;
        QList<QContactPhoneNumber> qp = ct.details<QContactPhoneNumber>();
        numberList += qp[0].number();
        for (int j = 1; j < qp.length(); j++) {
            numberList += ",";
            numberList += qp[j].number();
        }
        obj.insert("number", numberList);

        list.append(obj);
        obj.clear();
    }
    return list;
}

