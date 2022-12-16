import 'package:todo_list/app/core/database/migrations/migration.dart';
import 'package:todo_list/app/core/database/migrations/migration_v1.dart';

class SqliteMigrationFactory {
  List<Migration> getCreationMigration() => [
        MigrationV1(),
        //MigrationV2(),
        //MigrationV3(),
      ];

  List<Migration> getUpgradeMigration(int oldVersion) {
    final migrations = <Migration>[];

    if (oldVersion == 1) {
      //migrations.add(MigrationV2());
      //migrations.add(MigrationV3());
    }

    if (oldVersion == 2) {
      //migrations.add(MigrationV3());
    }

    return migrations;
  }
}
