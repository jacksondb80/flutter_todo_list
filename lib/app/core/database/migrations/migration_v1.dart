import 'package:sqflite_common/sqlite_api.dart';
import 'package:todo_list/app/core/database/migrations/migration.dart';

class MigrationV1 implements Migration {
  @override
  void create(Batch batch) {
    String sql = '''
      create table todo(
        id Integer primary key autoincrement,
        descricao varchar(500) not null,
        data_hora datetime,
        finalizado integer
      )
    ''';
    batch.execute(sql);
  }

  @override
  void update(Batch batch) {}
}
