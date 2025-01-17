// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

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

  SubjectsHistoryDao? _subjectsHistoryDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `subjects_star` (`isHidden` INTEGER, `status` INTEGER NOT NULL, `rating` REAL NOT NULL, `tags` TEXT, `isCollected` INTEGER, `creationTime` INTEGER NOT NULL, `subjectId` INTEGER NOT NULL, `name` TEXT NOT NULL, `nameCn` TEXT NOT NULL, `type` INTEGER NOT NULL, `url` TEXT, `platform` TEXT NOT NULL, `summary` TEXT, `totalEpisodes` INTEGER, `volumes` INTEGER, `eps` INTEGER, `airDate` TEXT, `images` TEXT, `score` REAL, `rank` INTEGER, PRIMARY KEY (`subjectId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subjects_user_tags` (`tagId` INTEGER PRIMARY KEY AUTOINCREMENT, `tag` TEXT NOT NULL, `creationTime` INTEGER NOT NULL, `isHidden` INTEGER, `isPinned` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subjects_history` (`creationTime` INTEGER NOT NULL, `subjectId` INTEGER NOT NULL, `name` TEXT NOT NULL, `nameCn` TEXT NOT NULL, `type` INTEGER NOT NULL, `url` TEXT, `platform` TEXT NOT NULL, `summary` TEXT, `totalEpisodes` INTEGER, `volumes` INTEGER, `eps` INTEGER, `airDate` TEXT, `images` TEXT, `score` REAL, `rank` INTEGER, PRIMARY KEY (`subjectId`))');

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

  @override
  SubjectsHistoryDao get subjectsHistoryDao {
    return _subjectsHistoryDaoInstance ??=
        _$SubjectsHistoryDao(database, changeListener);
  }
}

class _$SubjectsStarDao extends SubjectsStarDao {
  _$SubjectsStarDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _subjectsStarInsertionAdapter = InsertionAdapter(
            database,
            'subjects_star',
            (SubjectsStar item) => <String, Object?>{
                  'isHidden':
                      item.isHidden == null ? null : (item.isHidden! ? 1 : 0),
                  'status': item.status,
                  'rating': item.rating,
                  'tags': item.tags,
                  'isCollected': item.isCollected == null
                      ? null
                      : (item.isCollected! ? 1 : 0),
                  'creationTime': item.creationTime,
                  'subjectId': item.subjectId,
                  'name': item.name,
                  'nameCn': item.nameCn,
                  'type': item.type,
                  'url': item.url,
                  'platform': item.platform,
                  'summary': item.summary,
                  'totalEpisodes': item.totalEpisodes,
                  'volumes': item.volumes,
                  'eps': item.eps,
                  'airDate': item.airDate,
                  'images': item.images,
                  'score': item.score,
                  'rank': item.rank
                }),
        _subjectsStarUpdateAdapter = UpdateAdapter(
            database,
            'subjects_star',
            ['subjectId'],
            (SubjectsStar item) => <String, Object?>{
                  'isHidden':
                      item.isHidden == null ? null : (item.isHidden! ? 1 : 0),
                  'status': item.status,
                  'rating': item.rating,
                  'tags': item.tags,
                  'isCollected': item.isCollected == null
                      ? null
                      : (item.isCollected! ? 1 : 0),
                  'creationTime': item.creationTime,
                  'subjectId': item.subjectId,
                  'name': item.name,
                  'nameCn': item.nameCn,
                  'type': item.type,
                  'url': item.url,
                  'platform': item.platform,
                  'summary': item.summary,
                  'totalEpisodes': item.totalEpisodes,
                  'volumes': item.volumes,
                  'eps': item.eps,
                  'airDate': item.airDate,
                  'images': item.images,
                  'score': item.score,
                  'rank': item.rank
                }),
        _subjectsStarDeletionAdapter = DeletionAdapter(
            database,
            'subjects_star',
            ['subjectId'],
            (SubjectsStar item) => <String, Object?>{
                  'isHidden':
                      item.isHidden == null ? null : (item.isHidden! ? 1 : 0),
                  'status': item.status,
                  'rating': item.rating,
                  'tags': item.tags,
                  'isCollected': item.isCollected == null
                      ? null
                      : (item.isCollected! ? 1 : 0),
                  'creationTime': item.creationTime,
                  'subjectId': item.subjectId,
                  'name': item.name,
                  'nameCn': item.nameCn,
                  'type': item.type,
                  'url': item.url,
                  'platform': item.platform,
                  'summary': item.summary,
                  'totalEpisodes': item.totalEpisodes,
                  'volumes': item.volumes,
                  'eps': item.eps,
                  'airDate': item.airDate,
                  'images': item.images,
                  'score': item.score,
                  'rank': item.rank
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubjectsStar> _subjectsStarInsertionAdapter;

  final UpdateAdapter<SubjectsStar> _subjectsStarUpdateAdapter;

  final DeletionAdapter<SubjectsStar> _subjectsStarDeletionAdapter;

  @override
  Future<List<SubjectsStar>> findAllSubjectsStar() async {
    return _queryAdapter.queryList('SELECT * FROM subjects_star',
        mapper: (Map<String, Object?> row) => SubjectsStar(
            subjectId: row['subjectId'] as int,
            name: row['name'] as String,
            nameCn: row['nameCn'] as String,
            type: row['type'] as int,
            url: row['url'] as String?,
            platform: row['platform'] as String,
            summary: row['summary'] as String?,
            totalEpisodes: row['totalEpisodes'] as int?,
            volumes: row['volumes'] as int?,
            eps: row['eps'] as int?,
            airDate: row['airDate'] as String?,
            images: row['images'] as String?,
            score: row['score'] as double?,
            rank: row['rank'] as int?,
            isHidden:
                row['isHidden'] == null ? null : (row['isHidden'] as int) != 0,
            status: row['status'] as int,
            rating: row['rating'] as double,
            tags: row['tags'] as String?,
            isCollected: row['isCollected'] == null
                ? null
                : (row['isCollected'] as int) != 0,
            creationTime: row['creationTime'] as int));
  }

  @override
  Future<List<SubjectsStar>> findSubjectsStarByTypeStatusTagsHidden(
    int type,
    int status,
    bool isHidden,
    String sortBy,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subjects_star         WHERE type = ?1          AND status = ?2          AND isHidden = ?3       ORDER BY ?4 DESC       LIMIT 20 OFFSET ?5;',
        mapper: (Map<String, Object?> row) => SubjectsStar(subjectId: row['subjectId'] as int, name: row['name'] as String, nameCn: row['nameCn'] as String, type: row['type'] as int, url: row['url'] as String?, platform: row['platform'] as String, summary: row['summary'] as String?, totalEpisodes: row['totalEpisodes'] as int?, volumes: row['volumes'] as int?, eps: row['eps'] as int?, airDate: row['airDate'] as String?, images: row['images'] as String?, score: row['score'] as double?, rank: row['rank'] as int?, isHidden: row['isHidden'] == null ? null : (row['isHidden'] as int) != 0, status: row['status'] as int, rating: row['rating'] as double, tags: row['tags'] as String?, isCollected: row['isCollected'] == null ? null : (row['isCollected'] as int) != 0, creationTime: row['creationTime'] as int),
        arguments: [type, status, isHidden ? 1 : 0, sortBy, offset]);
  }

  @override
  Future<List<SubjectsStar>> findAllSubjects(
    int status,
    bool isHidden,
    String sortBy,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subjects_star         WHERE status = ?1          AND isHidden = ?2       ORDER BY ?3 DESC       LIMIT 20 OFFSET ?4;',
        mapper: (Map<String, Object?> row) => SubjectsStar(subjectId: row['subjectId'] as int, name: row['name'] as String, nameCn: row['nameCn'] as String, type: row['type'] as int, url: row['url'] as String?, platform: row['platform'] as String, summary: row['summary'] as String?, totalEpisodes: row['totalEpisodes'] as int?, volumes: row['volumes'] as int?, eps: row['eps'] as int?, airDate: row['airDate'] as String?, images: row['images'] as String?, score: row['score'] as double?, rank: row['rank'] as int?, isHidden: row['isHidden'] == null ? null : (row['isHidden'] as int) != 0, status: row['status'] as int, rating: row['rating'] as double, tags: row['tags'] as String?, isCollected: row['isCollected'] == null ? null : (row['isCollected'] as int) != 0, creationTime: row['creationTime'] as int),
        arguments: [status, isHidden ? 1 : 0, sortBy, offset]);
  }

  @override
  Future<List<SubjectsStar>> queryUserFavorites(
    bool isCollected,
    bool isHidden,
    String sortBy,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subjects_star         WHERE isCollected = ?1           AND isHidden = ?2       ORDER BY ?3 DESC       LIMIT 20 OFFSET ?4;',
        mapper: (Map<String, Object?> row) => SubjectsStar(subjectId: row['subjectId'] as int, name: row['name'] as String, nameCn: row['nameCn'] as String, type: row['type'] as int, url: row['url'] as String?, platform: row['platform'] as String, summary: row['summary'] as String?, totalEpisodes: row['totalEpisodes'] as int?, volumes: row['volumes'] as int?, eps: row['eps'] as int?, airDate: row['airDate'] as String?, images: row['images'] as String?, score: row['score'] as double?, rank: row['rank'] as int?, isHidden: row['isHidden'] == null ? null : (row['isHidden'] as int) != 0, status: row['status'] as int, rating: row['rating'] as double, tags: row['tags'] as String?, isCollected: row['isCollected'] == null ? null : (row['isCollected'] as int) != 0, creationTime: row['creationTime'] as int),
        arguments: [isCollected ? 1 : 0, isHidden ? 1 : 0, sortBy, offset]);
  }

  @override
  Future<int?> countSubjectsByStatus(int status) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM subjects_star         WHERE status = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [status]);
  }

  @override
  Future<int?> countSubjectsByStatusAndType(
    int status,
    int type,
  ) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM subjects_star         WHERE type = ?2         AND status = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [status, type]);
  }

  @override
  Future<List<double>> getScoreByType(int type) async {
    return _queryAdapter.queryList(
        'SELECT score FROM subjects_star WHERE type = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [type]);
  }

  @override
  Future<List<double>> getRatingByType(int type) async {
    return _queryAdapter.queryList(
        'SELECT rating FROM subjects_star WHERE type = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [type]);
  }

  @override
  Future<bool?> isSubjectExists(int subjectId) async {
    return _queryAdapter.query(
        'SELECT EXISTS(SELECT 1 FROM subjects_star WHERE subjectId = ?1)',
        mapper: (Map<String, Object?> row) => (row.values.first as int) != 0,
        arguments: [subjectId]);
  }

  @override
  Future<bool?> isSubjectCollectedById(
    int subjectId,
    bool isCollected,
  ) async {
    return _queryAdapter.query(
        'SELECT EXISTS(SELECT 1 FROM subjects_star WHERE subjectId = ?1 AND isCollected = ?2)',
        mapper: (Map<String, Object?> row) => (row.values.first as int) != 0,
        arguments: [subjectId, isCollected ? 1 : 0]);
  }

  @override
  Future<String?> getTagsForSubject(int subjectId) async {
    return _queryAdapter.query(
        'SELECT tags FROM subjects_star WHERE subjectId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        arguments: [subjectId]);
  }

  @override
  Future<void> addSubject(SubjectsStar subject) async {
    await _subjectsStarInsertionAdapter.insert(
        subject, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateSubject(SubjectsStar subject) {
    return _subjectsStarUpdateAdapter.updateAndReturnChangedRows(
        subject, OnConflictStrategy.abort);
  }

  @override
  Future<void> removeSubject(SubjectsStar subject) async {
    await _subjectsStarDeletionAdapter.delete(subject);
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
        _subjectsUserTagsUpdateAdapter = UpdateAdapter(
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

  final UpdateAdapter<SubjectsUserTags> _subjectsUserTagsUpdateAdapter;

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
  Future<void> updateTag(SubjectsUserTags tag) async {
    await _subjectsUserTagsUpdateAdapter.update(
        tag, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteTag(SubjectsUserTags tag) async {
    await _subjectsUserTagsDeletionAdapter.delete(tag);
  }
}

class _$SubjectsHistoryDao extends SubjectsHistoryDao {
  _$SubjectsHistoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _subjectsHistoryInsertionAdapter = InsertionAdapter(
            database,
            'subjects_history',
            (SubjectsHistory item) => <String, Object?>{
                  'creationTime': item.creationTime,
                  'subjectId': item.subjectId,
                  'name': item.name,
                  'nameCn': item.nameCn,
                  'type': item.type,
                  'url': item.url,
                  'platform': item.platform,
                  'summary': item.summary,
                  'totalEpisodes': item.totalEpisodes,
                  'volumes': item.volumes,
                  'eps': item.eps,
                  'airDate': item.airDate,
                  'images': item.images,
                  'score': item.score,
                  'rank': item.rank
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubjectsHistory> _subjectsHistoryInsertionAdapter;

  @override
  Future<List<SubjectsHistory>> findAllSubjectsHistory() async {
    return _queryAdapter.queryList(
        'SELECT * FROM subjects_history ORDER BY creationTime DESC',
        mapper: (Map<String, Object?> row) => SubjectsHistory(
            subjectId: row['subjectId'] as int,
            name: row['name'] as String,
            nameCn: row['nameCn'] as String,
            type: row['type'] as int,
            url: row['url'] as String?,
            platform: row['platform'] as String,
            summary: row['summary'] as String?,
            totalEpisodes: row['totalEpisodes'] as int?,
            volumes: row['volumes'] as int?,
            eps: row['eps'] as int?,
            airDate: row['airDate'] as String?,
            images: row['images'] as String?,
            score: row['score'] as double?,
            rank: row['rank'] as int?,
            creationTime: row['creationTime'] as int));
  }

  @override
  Future<void> deleteAllSubjectsHistory() async {
    await _queryAdapter.queryNoReturn('DELETE FROM subjects_history');
  }

  @override
  Future<void> insertSubjectsHistory(SubjectsHistory subjectsHistory) async {
    await _subjectsHistoryInsertionAdapter.insert(
        subjectsHistory, OnConflictStrategy.replace);
  }
}
