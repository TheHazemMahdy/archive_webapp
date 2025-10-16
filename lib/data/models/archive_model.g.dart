// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArchiveModelAdapter extends TypeAdapter<ArchiveModel> {
  @override
  final int typeId = 0;

  @override
  ArchiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArchiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      lastUpdated: fields[2] as String,
      capacity: fields[3] as String,
      notes: fields[4] as String?,
      status: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ArchiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lastUpdated)
      ..writeByte(3)
      ..write(obj.capacity)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArchiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
