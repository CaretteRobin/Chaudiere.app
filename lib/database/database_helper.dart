import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../core/models/event.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'events.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(_createTableSQL);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS events');
        await db.execute(_createTableSQL);
      },
    );
  }

  static const String _createTableSQL = '''
    CREATE TABLE events(
      id TEXT PRIMARY KEY,
      title TEXT,
      category TEXT,
      start_date TEXT,
      image_url TEXT,
      is_favorite INTEGER
    )
  ''';

  /// Insertion protégée contre les doublons
  Future<void> insertEvent(Event event) async {
    final db = await database;

    final exists = await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [event.id],
    );

    if (exists.isEmpty) {
      await db.insert(
        'events',
        event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Récupère tous les événements
  Future<List<Event>> fetchEvents() async {
    final db = await database;
    final maps = await db.query('events');
    return maps.map((e) => Event.fromMap(e)).toList();
  }

  /// Mise à jour d’un événement
  Future<void> updateEvent(Event event) async {
    final db = await database;
    await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  /// Supprime tout
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('events');
  }
}
