// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 1;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      piece: fields[0] as String,
      sizesQuantityMap: (fields[1] as Map).cast<String, int>(),
      date: fields[2] as DateTime,
      customerName: fields[3] as String,
      customerId: fields[4] as String?,
      totalPayment: fields[5] as double,
      paymentDone: fields[6] as double,
      paymentDue: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.piece)
      ..writeByte(1)
      ..write(obj.sizesQuantityMap)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.customerName)
      ..writeByte(4)
      ..write(obj.customerId)
      ..writeByte(5)
      ..write(obj.totalPayment)
      ..writeByte(6)
      ..write(obj.paymentDone)
      ..writeByte(7)
      ..write(obj.paymentDue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
