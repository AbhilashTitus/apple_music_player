// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MySongModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MySongModelAdapter extends TypeAdapter<MySongModel> {
  @override
  final int typeId = 0;

  @override
  MySongModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MySongModel(
      title: fields[0] as String,
      artist: fields[1] as String,
      data: fields[2] as String,
      albumArt: fields[3] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, MySongModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.albumArt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MySongModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}