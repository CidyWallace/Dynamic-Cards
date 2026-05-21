import 'package:card_dinamico/models/card.dart';
import 'package:card_dinamico/models/subItem.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._interno();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._interno();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await __inicializarDB();
    return _database!;
  }

  Future<Database?> __inicializarDB() async {
    String dbPath = join(await getDatabasesPath(), 'dynamic_cards.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tb_card(
            id TEXT PRIMARY KEY,
            title TEXT,
            updateAt TEXT,
            deleted INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE tb_subitem(
            id TEXT PRIMARY KEY,
            card_id TEXT,
            subTitle TEXT,
            isCounter INTEGER,
            marker INTEGER,
            current INTEGER,
            max INTEGER,
            amount INTEGER,
            value REAL,
            updateAt TEXT,
            deleted INTEGER,
            FOREIGN KEY (card_id) REFERENCES tb_card (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future<void> addCard(DynamicCard card) async {
    final db = await database;

    await db.insert(
      'tb_card',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addSubItem(SubItem item, String cardId) async {
    final db = await database;

    await db.insert(
      'tb_subitem',
      item.toMap(cardId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DynamicCard>> getAllCards() async {
    final db = await database;

    final List<Map<String, dynamic>> mapsCards = await db.query('tb_card');

    List<DynamicCard> listCards = [];

    for (var mapCard in mapsCards) {
      String cardId = mapCard['id'];

      final List<Map<String, dynamic>> mapsSubItens = await db.query(
        'tb_subitem',
        where: 'card_id = ?',
        whereArgs: [cardId],
      );

      List<SubItem> listSubItens = mapsSubItens
          .map((map) => SubItem.fromMap(map))
          .toList();

      listCards.add(DynamicCard.fromMap(mapCard, loadedItems: listSubItens));
    }

    return listCards;
  }

  Future<void> deleteCard(String idCard) async {
    final db = await database;

    await db.delete('tb_card', where: 'id = ?', whereArgs: [idCard]);
  }
}
