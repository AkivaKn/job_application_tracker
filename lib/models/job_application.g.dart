// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_application.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobApplicationAdapter extends TypeAdapter<JobApplication> {
  @override
  final int typeId = 0;

  @override
  JobApplication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobApplication(
      jobTitle: fields[0] as String,
      company: fields[1] as String,
      status: fields[5] as String,
      jobSite: fields[2] as String?,
      location: fields[3] as String?,
      salary: fields[4] as int?,
      createdAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, JobApplication obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.jobTitle)
      ..writeByte(1)
      ..write(obj.company)
      ..writeByte(2)
      ..write(obj.jobSite)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.salary)
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
      other is JobApplicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
