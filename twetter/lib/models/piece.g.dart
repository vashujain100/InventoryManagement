// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piece.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PieceAdapter extends TypeAdapter<Piece> {
  @override
  final int typeId = 2;

  @override
  Piece read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Piece(
      id: fields[0] as String?,
      pieceNumber: fields[1] as String,
      sizesQuantityMap: (fields[2] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Piece obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pieceNumber)
      ..writeByte(2)
      ..write(obj.sizesQuantityMap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PieceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
