// import 'dart:async';

// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class ImDb {
//   static ImDb? _instance;

//   factory ImDb.get() => _getInstance();
//   static _getInstance() {
//     // 只能有一个实例
//     if (_instance == null) {
//       _instance = ImDb._internal();
//     }
//     return _instance;
//   }

//   ImDb._internal() {
//     init();
//   }

//   late Database _database;

//   Future<Database> init() async {
//     _database = await openDatabase(
//       // Set the path to the database. Note: Using the `join` function from the
//       // `path` package is best practice to ensure the path is correctly
//       // constructed for each platform.
//       join(await getDatabasesPath(), 'unicorn.db'),
//       onCreate: (db, version) {
//         String msg = '''CREATE TABLE msg(
//           msgId INTEGER PRIMARY KEY,
//           peerId TEXT, 
//           age INTEGER
//           )
//         ''';
//         // Run the CREATE TABLE statement on the database.
//         return db.execute(
//           msg,
//         );
//       },
//       // Set the version. This executes the onCreate function and provides a
//       // path to perform database upgrades and downgrades.
//       version: 1,
//     );
//     return _database;
//   }

//   Database getDb() => _database;

//   // init() async {
//   // WidgetsFlutterBinding.ensureInitialized();
//   // }
// }
