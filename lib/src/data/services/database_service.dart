

class DatabaseService {
  // DatabaseService._();

  // static final DatabaseService instance = DatabaseService._();

  // static Database? database;

  // get databse async {
  //   if (database != null) return database;
  //   database = await initDB();
  //   return database;
  // }

  // initDB() async {
  //   return await openDatabase('database.db', version: 1,
  //       onCreate: (Database db, int version) async {
  //     await db.execute(
  //       'CREATE TABLE IF NOT EXISTS users ('
  //       'email TEXT PRIMARY KEY,'
  //       'name TEXT,'
  //       'email TEXT'
  //       ')',
  //     );
  //     await db.execute(
  //       'CREATE TABLE IF NOT EXISTS rooms ('
  //       'id INTEGER PRIMARY KEY AUTOINCREMENT,'
  //       'name TEXT,'
  //       'image TEXT'
  //       ')',
  //     );
  //   });
  // }
}
