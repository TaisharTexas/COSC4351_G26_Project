part of 'user_model.dart';  // Ensure this line exists in user_model.g.dart

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
      pastEvents: (fields[12] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.availability)
      ..writeByte(12)
      ..write(obj.pastEvents);
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
