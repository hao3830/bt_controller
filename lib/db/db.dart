import 'package:bluetooth_control_path/constants/create_profile_keys.dart';
import 'package:bluetooth_control_path/constants/shared_prefs_keys.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer';
import 'package:uuid/uuid.dart';

class MyDatabase {
  String path;
  String name;
  late Database mydb;
  MyDatabase({required this.name, required this.path});

  Future<void> init() async {
    try {
      mydb = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $name (id INTERGER PRIMARY KEY, name TEXT, left Text, right Text, top Text, bottom Text )');
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> createProfile(CreateProfileKeys prefsKeys) async {
    String left = prefsKeys.left,
        right = prefsKeys.right,
        top = prefsKeys.up,
        bottom = prefsKeys.down,
        profileName = prefsKeys.profileName,
        id = const Uuid().v4();

    await mydb.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO $name(id,name, left, right, top, bottom) VALUES(?,?,?,?,?,?)',
          [id, profileName, left, right, top, bottom]);
    });
  }

  // Future<void> updateProfile(CreateProfileKeys prefsKeys) async {
  //   String left = prefsKeys.left,
  //       right = prefsKeys.right,
  //       top = prefsKeys.up,
  //       bottom = prefsKeys.down,
  //       profileName = prefsKeys.profileName,
  //       id = prefsKeys.id;

  //   await mydb.transaction((txn) async {
  //     await txn.rawUpdate(
  //         'UPDATE $name SET name = ?, left = ?, right = ?, top = ?, bottom = ? WHERE id = ?',
  //         [profileName, left, right, top, bottom, id]);
  //   });
  // }

  Future<void> deleteProfile(String id) async {
    await mydb.transaction((txn) async {
      await txn.rawDelete('DELETE FROM $name WHERE id = ?', [id]);
    });
  }

  Future<void> deleteAll() {
    return mydb.transaction((txn) async {
      await txn.rawDelete('DELETE FROM $name');
    });
  }

  Future<List<Map>> getAllProfiles(tablename) async {
    List<Map> list = await mydb.rawQuery('SELECT * FROM $tablename');
    return list;
  }
}
