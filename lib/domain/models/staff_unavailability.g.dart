// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_unavailability.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnavailabilityStatusAdapter extends TypeAdapter<UnavailabilityStatus> {
  @override
  final int typeId = 10;

  @override
  UnavailabilityStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UnavailabilityStatus.pending;
      case 1:
        return UnavailabilityStatus.approved;
      case 2:
        return UnavailabilityStatus.rejected;
      default:
        return UnavailabilityStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, UnavailabilityStatus obj) {
    switch (obj) {
      case UnavailabilityStatus.pending:
        writer.writeByte(0);
        break;
      case UnavailabilityStatus.approved:
        writer.writeByte(1);
        break;
      case UnavailabilityStatus.rejected:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnavailabilityStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StaffUnavailabilityImplAdapter
    extends TypeAdapter<_$StaffUnavailabilityImpl> {
  @override
  final int typeId = 11;

  @override
  _$StaffUnavailabilityImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$StaffUnavailabilityImpl(
      id: fields[0] as String,
      staffId: fields[1] as String,
      date: fields[2] as DateTime,
      slot: fields[3] as TimeSlot,
      reason: fields[4] as String,
      status: fields[5] as UnavailabilityStatus,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, _$StaffUnavailabilityImpl obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.staffId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.slot)
      ..writeByte(4)
      ..write(obj.reason)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaffUnavailabilityImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffUnavailabilityImpl _$$StaffUnavailabilityImplFromJson(
        Map<String, dynamic> json) =>
    _$StaffUnavailabilityImpl(
      id: json['id'] as String,
      staffId: json['staffId'] as String,
      date: DateTime.parse(json['date'] as String),
      slot: $enumDecode(_$TimeSlotEnumMap, json['slot']),
      reason: json['reason'] as String,
      status:
          $enumDecodeNullable(_$UnavailabilityStatusEnumMap, json['status']) ??
              UnavailabilityStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$StaffUnavailabilityImplToJson(
        _$StaffUnavailabilityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'staffId': instance.staffId,
      'date': instance.date.toIso8601String(),
      'slot': _$TimeSlotEnumMap[instance.slot]!,
      'reason': instance.reason,
      'status': _$UnavailabilityStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TimeSlotEnumMap = {
  TimeSlot.morning: 'morning',
  TimeSlot.afternoon: 'afternoon',
  TimeSlot.fullDay: 'fullDay',
};

const _$UnavailabilityStatusEnumMap = {
  UnavailabilityStatus.pending: 'pending',
  UnavailabilityStatus.approved: 'approved',
  UnavailabilityStatus.rejected: 'rejected',
};
