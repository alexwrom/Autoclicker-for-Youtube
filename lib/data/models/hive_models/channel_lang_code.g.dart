// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_lang_code.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChannelLangCodeAdapter extends TypeAdapter<ChannelLangCode> {
  @override
  final int typeId = 0;

  @override
  ChannelLangCode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChannelLangCode(
      id: fields[0] as String,
      codeLanguage: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChannelLangCode obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.codeLanguage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelLangCodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
