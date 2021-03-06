// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NameCategoryAdapter extends TypeAdapter<NameCategory> {
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
    )
      ..fix = fields[2] as double?
      ..users = (fields[3] as Map?)?.cast<String, double>();
  }

  @override
  void write(BinaryWriter writer, NameCategory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.fix)
      ..writeByte(3)
      ..write(obj.users);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
