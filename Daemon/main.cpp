#include <QtCore/QCoreApplication>
#include "callwatchdog.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    CallWatchdog dog;
    QObject::connect(&dog, SIGNAL(quit()), &a, SLOT(quit()));
    return a.exec();
}
