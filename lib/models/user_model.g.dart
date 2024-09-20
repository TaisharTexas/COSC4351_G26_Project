// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      email: fields[1] as String,
      password: fields[2] as String,
      fullName: fields[3] as String,
      address1: fields[4] as String,
      address2: fields[5] as String,
      city: fields[6] as String,
      state: fields[7] as String,
      zipCode: fields[8] as String,
      skills: (fields[9] as List).cast<String>(),
      preferences: fields[10] as String,
      availability: (fields[11] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.fullName)
      ..writeByte(4)
      ..write(obj.address1)
      ..writeByte(5)
      ..write(obj.address2)
      ..writeByte(6)
      ..write(obj.city)
      ..writeByte(7)
      ..write(obj.state)
      ..writeByte(8)
      ..write(obj.zipCode)
      ..writeByte(9)
      ..write(obj.skills)
      ..writeByte(10)
      ..write(obj.preferences)
      ..writeByte(11)
      ..write(obj.availability);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
