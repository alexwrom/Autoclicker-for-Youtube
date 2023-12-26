// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cred_channel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CredChannelAdapter extends TypeAdapter<CredChannel> {
  @override
  final int typeId = 1;

  @override
  CredChannel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CredChannel(
      keyLangCode: fields[7] as int,
      nameChannel: fields[1] as String,
      imgBanner: fields[2] as String,
      accountName: fields[3] as String,
      idUpload: fields[0] as String,
      idChannel: fields[4] as String,
      accessToken: fields[5] as String,
      idToken: fields[6] as String,
      defaultLanguage: fields[8] as String,
      refreshToken: fields[9] as String,
      idInvitation: fields[10] as String,
      typePlatformRefreshToken: fields[11] as String,
      remoteChannel: fields[12] as bool,
      bonus: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CredChannel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.idUpload)
      ..writeByte(1)
      ..write(obj.nameChannel)
      ..writeByte(2)
      ..write(obj.imgBanner)
      ..writeByte(3)
      ..write(obj.accountName)
      ..writeByte(4)
      ..write(obj.idChannel)
      ..writeByte(5)
      ..write(obj.accessToken)
      ..writeByte(6)
      ..write(obj.idToken)
      ..writeByte(7)
      ..write(obj.keyLangCode)
      ..writeByte(8)
      ..write(obj.defaultLanguage)
      ..writeByte(9)
      ..write(obj.refreshToken)
      ..writeByte(10)
      ..write(obj.idInvitation)
      ..writeByte(11)
      ..write(obj.typePlatformRefreshToken)
      ..writeByte(12)
      ..write(obj.remoteChannel)
      ..writeByte(13)
      ..write(obj.bonus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CredChannelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
