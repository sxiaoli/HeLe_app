// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SubjectsStarDao? _subjectsStarDaoInstance;

  SubjectsUserTagsDao? _subjectsUserTagsDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subjects_star` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `subjectId` INTEGER NOT NULL, `name` TEXT NOT NULL, `nameCn` TEXT NOT NULL, `type` INTEGER NOT NULL, `url` TEXT, `platform` TEXT NOT NULL, `summary` TEXT, `totalEpisodes` INTEGER, `volumes` INTEGER, `eps` INTEGER, `airDate` TEXT, `airWeekday` INTEGER, `images` TEXT, `score` REAL, `rank` INTEGER, `isHidden` INTEGER, `status` INTEGER NOT NULL, `rating` REAL NOT NULL, `tags` TEXT NOT NULL, `creationTime` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subjects_user_tags` (`tagId` INTEGER PRIMARY KEY AUTOINCREMENT, `tag` TEXT NOT NULL, `creationTime` INTEGER NOT NULL, `isHidden` INTEGER, `isPinned` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SubjectsStarDao get subjectsStarDao {
    return _subjectsStarDaoInstance ??=
        _$SubjectsStarDao(database, changeListener);
  }

  @override
  SubjectsUserTagsDao get subjectsUserTagsDao {
    return _subjectsUserTagsDaoInstance ??=
        _$SubjectsUserTagsDao(database, changeListener);
  }
}

class _$SubjectsStarDao extends SubjectsStarDao {
  _$SubjectsStarDao(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<SubjectsStar>> findAllSubjectsStar() async {
    return _queryAdapter.queryList('SELECT * FROM subjects_star',
        mapper: (Map<String, Object?> row) => SubjectsStar(
            id: row['id'] as int?,
            subjectId: row['subjectId'] as int,
            name: row['name'] as String,
            nameCn: row['nameCn'] as String,
            type: row['type'] as int,
            url: row['url'] as String?,
            platform: row['platform'] as String,
            summary: row['summary'] as String?,
            volumes: row['volumes'] as int?,
            eps: row['eps'] as int?,
            airDate: row['airDate'] as String?,
            airWeekday: row['airWeekday'] as int?,
            images: row['images'] as String?,
            score: row['score'] as double?,
            rank: row['rank'] as int?,
            isHidden:
                row['isHidden'] == null ? null : (row['isHidden'] as int) != 0,
            status: row['status'] as int,
            rating: row['rating'] as double,
            tags: row['tags'] as String,
            creationTime: row['creationTime'] as int));
  }
}

class _$SubjectsUserTagsDao extends SubjectsUserTagsDao {
  _$SubjectsUserTagsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _subjectsUserTagsInsertionAdapter = InsertionAdapter(
            database,
            'subjects_user_tags',
            (SubjectsUserTags item) => <String, Object?>{
                  'tagId': item.tagId,
                  'tag': item.tag,
                  'creationTime': item.creationTime,
                  'isHidden':
                      item.isHidden == null ? null : (item.isHidden! ? 1 : 0),
                  'isPinned':
                      item.isPinned == null ? null : (item.isPinned! ? 1 : 0)
                }),
        _subjectsUserTagsDeletionAdapter = DeletionAdapter(
            database,
            'subjects_user_tags',
            ['tagId'],
            (SubjectsUserTags item) => <String, Object?>{
                  'tagId': item.tagId,
                  'tag': item.tag,
                  'creationTime': item.creationTime,
                  'isHidden':
                      item.isHidden == null ? null : (item.isHidden! ? 1 : 0),
                  'isPinned':
                      item.isPinned == null ? null : (item.isPinned! ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubjectsUserTags> _subjectsUserTagsInsertionAdapter;

  final DeletionAdapter<SubjectsUserTags> _subjectsUserTagsDeletionAdapter;

  @override
  Future<List<SubjectsUserTags>> findAllTags() async {
    return _queryAdapter.queryList('SELECT * FROM subjects_user_tags',
        mapper: (Map<String, Object?> row) => SubjectsUserTags(
            tagId: row['tagId'] as int?,
            tag: row['tag'] as String,
            creationTime: row['creationTime'] as int,
            isHidden:
                row['isHidden'] == null ? null : (row['isHidden'] as int) != 0,
            isPinned: row['isPinned'] == null
                ? null
                : (row['isPinned'] as int) != 0));
  }

  @override
  Future<void> insertTag(SubjectsUserTags tag) async {
    await _subjectsUserTagsInsertionAdapter.insert(
        tag, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteTag(SubjectsUserTags tag) async {
    await _subjectsUserTagsDeletionAdapter.delete(tag);
  }
}
