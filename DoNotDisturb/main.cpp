#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include "contacts.h"
#include "setting.h"

#define DAEMON_BUS_NAME "org.oceandeep.donotdisturb"
#define DAEMON_BUS_PATH "/org/oceandeep/donotdisturb"
#define DAEMON_INSTANCE_INTERFACE DAEMON_BUS_NAME

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication *_app = createApplication(argc, argv);
    QString locale = QLocale::system().name();
    QTranslator translator;
    translator.load(locale, "/opt/DoNotDisturb/lang");
    _app->installTranslator(&translator);

    QScopedPointer<QApplication> app(_app);

    QmlApplicationViewer viewer;
    Contacts ct;
    Setting st;
    viewer.rootContext()->setContextProperty("contacts", &ct);
    viewer.rootContext()->setContextProperty("setting", &st);

    viewer.setMainQmlFile(QLatin1String("qml/DoNotDisturb/main.qml"));
    viewer.showExpanded();

    int ret = app->exec();
    ct.save();
    st.save();

    QDBusInterface iface(DAEMON_BUS_NAME, DAEMON_BUS_PATH, DAEMON_INSTANCE_INTERFACE);
    iface.call("loadSetting");

    return ret;
}
