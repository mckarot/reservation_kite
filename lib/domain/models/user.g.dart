// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String? ?? 'student',
      weight: (json['weight'] as num?)?.toInt(),
      walletBalance: (json['walletBalance'] as num?)?.toInt() ?? 0,
      progress: json['progress'] == null
          ? null
          : UserProgress.fromJson(json['progress'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastSeen: DateTime.parse(json['lastSeen'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'role': instance.role,
      'weight': instance.weight,
      'walletBalance': instance.walletBalance,
      'progress': instance.progress,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastSeen': instance.lastSeen.toIso8601String(),
    };

_$UserProgressImpl _$$UserProgressImplFromJson(Map<String, dynamic> json) =>
    _$UserProgressImpl(
      ikoLevel: json['ikoLevel'] as String?,
      checklist: (json['checklist'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: (json['notes'] as List<dynamic>?)
              ?.map((e) => UserNote.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserProgressImplToJson(_$UserProgressImpl instance) =>
    <String, dynamic>{
      'ikoLevel': instance.ikoLevel,
      'checklist': instance.checklist,
      'notes': instance.notes,
    };

_$UserNoteImpl _$$UserNoteImplFromJson(Map<String, dynamic> json) =>
    _$UserNoteImpl(
      date: DateTime.parse(json['date'] as String),
      content: json['content'] as String,
      instructorId: json['instructorId'] as String,
    );

Map<String, dynamic> _$$UserNoteImplToJson(_$UserNoteImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'content': instance.content,
      'instructorId': instance.instructorId,
    };
