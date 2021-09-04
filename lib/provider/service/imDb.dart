import 'package:moor/moor.dart';
import 'package:client/tools/utils/moor.dart'
    if (dart.library.js) 'package:client/tools/utils/moor_web.dart';

part 'imDb.g.dart';

@UseMoor(tables: [], daos: [])
class UcDatabase extends _$UcDatabase {
  // we tell the database where to store the data with this constructor
  UcDatabase()
      // : super(FlutterQueryExecutor.inDatabaseFolder(
      //       path: "db.sqlite", logStatements: true));
      : super(getMoorDataBase());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}
