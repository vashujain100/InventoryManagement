class Piece {
  final String pieceNumber;
  final Map<String, int> sizesQuantityMap;

  Piece({
    required this.pieceNumber,
    required this.sizesQuantityMap,
  });

  Piece copyWithSizesQuantityMap(Map<String, int> newSizesQuantityMap) {
    return Piece(
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
