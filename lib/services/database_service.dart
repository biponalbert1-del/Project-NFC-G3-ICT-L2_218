import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/terminal_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'token_transfer_app.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            wallet_address TEXT NOT NULL,
            balance INTEGER NOT NULL,
            is_nearby INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE transactions(
            id TEXT PRIMARY KEY,
            sender_id TEXT NOT NULL,
            receiver_id TEXT NOT NULL,
            amount INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            status TEXT NOT NULL,
            channel TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE terminals(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            service TEXT NOT NULL,
            wallet_address TEXT NOT NULL,
            is_authorized INTEGER NOT NULL
          )
        ''');
        await _seed(db);
      },
    );
  }

  Future<void> _seed(Database db) async {
    final users = [
      const UserModel(
        id: AppConstants.mainUserId,
        name: 'Samuel Bipon',
        phone: '+237 690 000 000',
        walletAddress: '0xAA21...NBP',
        balance: 249031,
        isNearby: false,
      ),
      const UserModel(
        id: 'user-sarah',
        name: 'Sarah L.',
        phone: '+237 675 111 222',
        walletAddress: '0xB17E...SAR',
        balance: 45000,
        isNearby: true,
      ),
      const UserModel(
        id: 'user-leila',
        name: 'Leila M.',
        phone: '+237 696 333 444',
        walletAddress: '0xC8F0...LEI',
        balance: 33000,
        isNearby: true,
      ),
      const UserModel(
        id: 'user-daniel',
        name: 'Daniel K.',
        phone: '+237 677 555 666',
        walletAddress: '0xD41D...DAN',
        balance: 18000,
        isNearby: false,
      ),
    ];

    for (final user in users) {
      await db.insert('users', user.toMap());
    }

    final terminals = [
      const TerminalModel(
        id: 'term-food-01',
        name: 'Snack VIP',
        service: 'Restauration',
        walletAddress: '0xTERM...FOOD',
        isAuthorized: true,
      ),
      const TerminalModel(
        id: 'term-entry-02',
        name: 'Entree principale',
        service: 'Controle acces',
        walletAddress: '0xTERM...GATE',
        isAuthorized: true,
      ),
      const TerminalModel(
        id: 'term-unknown-03',
        name: 'Terminal inconnu',
        service: 'Non verifie',
        walletAddress: '0xTERM...RISK',
        isAuthorized: false,
      ),
    ];

    for (final terminal in terminals) {
      await db.insert('terminals', terminal.toMap());
    }
  }

  Future<UserModel> getCurrentUser() async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [AppConstants.mainUserId],
      limit: 1,
    );
    return UserModel.fromMap(rows.first);
  }

  Future<List<UserModel>> getNearbyUsers() async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'id != ? AND is_nearby = 1',
      whereArgs: [AppConstants.mainUserId],
    );
    return rows.map(UserModel.fromMap).toList();
  }

  Future<List<TerminalModel>> getTerminals() async {
    final db = await database;
    final rows = await db.query('terminals', orderBy: 'is_authorized DESC');
    return rows.map(TerminalModel.fromMap).toList();
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    final rows = await db.query('transactions', orderBy: 'created_at DESC');
    return rows.map(TransactionModel.fromMap).toList();
  }

  Future<void> saveTransaction(TransactionModel transaction) async {
    final db = await database;
    await db.insert('transactions', transaction.toMap());
  }

  Future<void> transferTokens({
    required String senderId,
    required String receiverId,
    required int amount,
  }) async {
    final db = await database;
    await db.transaction((txn) async {
      final senderRows = await txn.query(
        'users',
        where: 'id = ?',
        whereArgs: [senderId],
        limit: 1,
      );
      final receiverRows = await txn.query(
        'users',
        where: 'id = ?',
        whereArgs: [receiverId],
        limit: 1,
      );
      final sender = UserModel.fromMap(senderRows.first);
      final receiver = UserModel.fromMap(receiverRows.first);

      if (amount <= 0) {
        throw Exception('Le montant doit etre superieur a zero.');
      }
      if (sender.balance < amount) {
        throw Exception('Solde insuffisant.');
      }

      await txn.update(
        'users',
        sender.copyWith(balance: sender.balance - amount).toMap(),
        where: 'id = ?',
        whereArgs: [senderId],
      );
      await txn.update(
        'users',
        receiver.copyWith(balance: receiver.balance + amount).toMap(),
        where: 'id = ?',
        whereArgs: [receiverId],
      );
    });
  }
}
