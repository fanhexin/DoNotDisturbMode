// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Image {
    width: parent.width
    asynchronous: true
    source: (theme.inverted)?"image://theme/meegotouch-groupheader-inverted-background":"image://theme/meegotouch-groupheader-background"
}
