// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryTransactionAdapter extends TypeAdapter<NameCategory> {
  @override
  final int typeId = 3;

  @override
  NameCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NameCategory(
      name: fields[0] as String,
      type: fields[1] as String,
    )..fix = fields[2] as double?;
  }

  @override
  void write(BinaryWriter writer, NameCategory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.fix);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
