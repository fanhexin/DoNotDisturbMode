.pragma library

var db;
function init() {
    db = openDatabaseSync("DoNotDisturb", "1.0", "", 1000000);
    db.transaction(function(tx) {
                       tx.executeSql("CREATE TABLE IF NOT EXISTS WhiteList(id INTEGER, name TEXT, imgUrl TEXT, number TEXT)");
                   });
}

function wl_insert(data) {
    db.transaction(function(tx) {
                       tx.executeSql('INSERT INTO WhiteList VALUES(?, ?, ?, ?)', data);
                   });
}

function wl_del(id) {
    db.transaction(function(tx) {
                       tx.executeSql('DELETE FROM WhiteList WHERE id=?', [id]);
                   });
}

function wl_clear() {
    db.transaction(function(tx) {
                       tx.executeSql('DELETE FROM WhiteList');
                   });
}

function wl_get(callback) {
    db.transaction(function(tx) {
                       var tmp = {};
                       var rs = tx.executeSql('SELECT * FROM WhiteList');
                       for (var i = 0; i < rs.rows.length; i++) {
                           callback(rs.rows.item(i));
                       }
                   });
}

function wl_destroy() {
    db.transaction(function(tx) {
                       tx.executeSql('DROP TABLE WhiteList');
                   });
}

function wl_isExist(id) {
    var ret;
    db.transaction(function(tx) {
                       var rs = tx.executeSql('SELECT * FROM WhiteList WHERE id=?', [id]);
                       ret = rs.rows.length;
                   });
    return ret;
}
