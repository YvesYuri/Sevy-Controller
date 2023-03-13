import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:async';

import '../models/room_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();

  factory DatabaseService() {
    return instance;
  }

  DatabaseService._internal();

  static const DATABASE_NAME = 'contatos.db';
  static const DATABASE_VERSION = 1;

  Database? _db;

  Future<Database> get db => _openDatabase();

  Future<Database> _openDatabase() async {
    sqfliteFfiInit();
    String databasePath = await databaseFactoryFfi.getDatabasesPath();
    String path = join(databasePath, DATABASE_NAME);
    DatabaseFactory databaseFactory = databaseFactoryFfi;

    _db ??= await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
            onCreate: _onCreate, version: DATABASE_VERSION));
    return _db!;
  }

  FutureOr<void> _onCreate(Database db, int version) {
    db.transaction((reference) async {
      await reference.execute(
          "CREATE TABLE IF NOT EXISTS user(email TEXT PRIMARY KEY, display_name TEXT, register_date TEXT)");
      await reference.execute(
          "CREATE TABLE IF NOT EXISTS room(id TEXT PRIMARY KEY, name TEXT, cover TEXT, owner TEXT)");
    });
  }

  //User

  Future<int> createUser(UserModel user) async {
    var dbClient = await db;
    int res = await dbClient.insert("user", user.toMap());
    return res;
  }

  Future<List<UserModel>> readUsers() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM user');
    List<UserModel> users = [];
    for (int i = 0; i < list.length; i++) {
      users.add(UserModel.fromJson(list[i]));
    }
    return users;
  }

  Future<int> updateUser(UserModel user) async {
    var dbClient = await db;
    int res = await dbClient.update("user", user.toMap(),
        where: "email = ?", whereArgs: [user.email]);
    return res;
  }

  Future<int> deleteUser(String email) async {
    var dbClient = await db;
    int res =
        await dbClient.delete("user", where: "email = ?", whereArgs: [email]);
    return res;
  }

  Future<UserModel> readUser(String email) async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM user WHERE email = ?', [email]);
    if (list.isNotEmpty) {
      return UserModel.fromJson(list.first);
    }
    return UserModel();
  }

  //Room
  Future<int> createRoom(RoomModel room) async {
    var dbClient = await db;
    int res = await dbClient.insert("room", room.toMap());
    return res;
  }

  Future<List<RoomModel>> readRooms() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM room');
    List<RoomModel> rooms = [];
    for (int i = 0; i < list.length; i++) {
      rooms.add(RoomModel.fromJson(list[i]));
    }
    return rooms;
  }

  Future<int> updateRoom(RoomModel room) async {
    var dbClient = await db;
    int res = await dbClient
        .update("room", room.toMap(), where: "id = ?", whereArgs: [room.id]);
    return res;
  }

  Future<int> deleteRoom(String id) async {
    var dbClient = await db;
    int res = await dbClient.delete("room", where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<RoomModel> readRoom(String id) async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM room WHERE id = ?', [id]);
    if (list.isNotEmpty) {
      return RoomModel.fromJson(list.first);
    }
    return RoomModel();
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
