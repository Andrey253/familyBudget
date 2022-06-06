// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryTransactionAdapter extends TypeAdapter<CategoryTransaction> {
  @override
  final int typeId = 3;

  @override
  CategoryTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryTransaction(
      name: fields[0] as String,
      type: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryTransaction obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type);
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
