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
      nameCategory: fields[0] as String,
      type: fields[1] as String,
      keyAt: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryTransaction obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nameCategory)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.keyAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryTransactionAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
