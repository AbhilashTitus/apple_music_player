// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'song_model.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class MyMyMySongModelAdapter extends TypeAdapter<MyMyMySongModel> {
//   @override
//   final int typeId = 0;

//   @override
//   MyMyMySongModel read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return MyMyMySongModel(
//       fields[0] as String,
//       fields[1] as String,
//       fields[2] as String,
//       fields[3] as String,
//       fields[4] as String,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, MyMyMySongModel obj) {
//     writer
//       ..writeByte(5)
//       ..writeByte(0)
//       ..write(obj.title)
//       ..writeByte(1)
//       ..write(obj.artist)
//       ..writeByte(2)
//       ..write(obj.album)
//       ..writeByte(3)
//       ..write(obj.filePath)
//       ..writeByte(4)
//       ..write(obj.albumArt);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is MyMyMySongModelAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
