// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 1;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      location: fields[3] as String,
      address: fields[4] as String,
      requiredSkills: (fields[5] as List).cast<String>(),
      urgency: fields[6] as String,
      eventDate: fields[7] as DateTime,
      assignedVolunteers: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.requiredSkills)
      ..writeByte(6)
      ..write(obj.urgency)
      ..writeByte(7)
      ..write(obj.eventDate)
      ..writeByte(8)
      ..write(obj.assignedVolunteers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}