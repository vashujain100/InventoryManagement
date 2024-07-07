import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'piece.g.dart';

@HiveType(typeId: 2)
class Piece extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String pieceNumber;

  @HiveField(2)
  final Map<String, int> sizesQuantityMap;

  Piece({
    String? id,
    required this.pieceNumber,
    required this.sizesQuantityMap,
  }) : this.id = id ?? const Uuid().v4();

  Piece copyWithSizesQuantityMap(Map<String, int> newSizesQuantityMap) {
    return Piece(
      id: id,
      pieceNumber: pieceNumber,
      sizesQuantityMap: newSizesQuantityMap,
    );
  }

  factory Piece.fromJson(Map<String, dynamic> json) {
    return Piece(
      pieceNumber: json['pieceNumber'],
      sizesQuantityMap: Map<String, int>.from(json['sizesQuantityMap']),
    );
  }
}
