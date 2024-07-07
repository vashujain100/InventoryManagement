import 'package:hive_flutter/hive_flutter.dart';

import '../models/piece.dart';

class PiecesService {
  static const String _boxName = 'pieces';

  Future<void> addPiece(Piece piece) async {
    final box = await Hive.openBox<Piece>(_boxName);
    await box.put(piece.id, piece);
  }

  Future<List<Piece>> getAllPieces() async {
    final box = await Hive.openBox<Piece>(_boxName);
    return box.values.toList();
  }

  Future<int> getNumberOfPieces() async {
    final box = await Hive.openBox<Piece>(_boxName);
    return box.length;
  }

  Future<Piece?> getPieceById(String id) async {
    final box = await Hive.openBox<Piece>(_boxName);
    return box.get(id);
  }

  Future<void> updatePiece(Piece updatedPiece) async {
    final box = await Hive.openBox<Piece>(_boxName);
    await box.put(updatedPiece.id, updatedPiece);
  }

  Future<void> deletePieceById(String id) async {
    final box = await Hive.openBox<Piece>(_boxName);
    print('Deleting piece with ID: $id');
    print(
        'Box contents before deletion: ${box.values.map((p) => p.id).toList()}');
    await box.delete(id);
    print(
        'Box contents after deletion: ${box.values.map((p) => p.id).toList()}');
  }

  Future<void> deleteAllPieces() async {
    final box = await Hive.openBox<Piece>(_boxName);
    await box.clear();
  }
}
