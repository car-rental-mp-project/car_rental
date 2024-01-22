// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarAdapter extends TypeAdapter<Car> {
  @override
  final int typeId = 0;

  @override
  Car read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Car(
      name: fields[0] as String?,
      description: fields[1] as String?,
      imageUrls: (fields[2] as List?)?.cast<String>(),
      power: fields[3] as String?,
      range: fields[4] as String?,
      seats: fields[5] as String?,
      brand: fields[6] as String?,
      rating: fields[7] as String?,
      type: fields[8] as String?,
      ownerEmail: fields[9] as String?,
      id: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Car obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.imageUrls)
      ..writeByte(3)
      ..write(obj.power)
      ..writeByte(4)
      ..write(obj.range)
      ..writeByte(5)
      ..write(obj.seats)
      ..writeByte(6)
      ..write(obj.brand)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.ownerEmail)
      ..writeByte(10)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
