// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerAdapter extends TypeAdapter<Customer> {
  @override
  final int typeId = 0;

  @override
  Customer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Customer(
      id: fields[0] as String,
      name: fields[1] as String,
      contactNo: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Customer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.contactNo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
