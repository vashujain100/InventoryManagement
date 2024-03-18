import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/piece.dart';

class PieceProvider {
  final SharedPreferences _prefs;

  PieceProvider(this._prefs);

  List<Piece> get pieces {
    final piecesJson = _prefs.getString('pieces');
    if (piecesJson != null) {
      final List<dynamic> parsedJson = jsonDecode(piecesJson);
      return parsedJson.map((json) => Piece.fromJson(json)).toList();
    }
    return [];
  }

  void addPiece(Piece newPiece) {
    final List<Piece> updatedPieces = [...pieces, newPiece];
    _prefs.setString('pieces', jsonEncode(updatedPieces));
  }

  void updatePiece(Piece updatedPiece) {
    final List<Piece> updatedPieces = pieces.map((piece) {
      return piece.pieceNumber == updatedPiece.pieceNumber
          ? updatedPiece
          : piece;
    }).toList();
    _prefs.setString('pieces', jsonEncode(updatedPieces));
  }

  void removePiece(String pieceNumber) {
    final List<Piece> updatedPieces =
        pieces.where((piece) => piece.pieceNumber != pieceNumber).toList();
    _prefs.setString('pieces', jsonEncode(updatedPieces));
  }
}
