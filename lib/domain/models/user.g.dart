// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      email: json['email'] as String,
      photoUrl: json['photo_url'] as String?,
      role: json['role'] as String? ?? 'student',
      weight: (json['weight'] as num?)?.toInt(),
      walletBalance: (json['wallet_balance'] as num?)?.toInt() ?? 0,
      totalCreditsPurchased:
          (json['total_credits_purchased'] as num?)?.toInt() ?? 0,
      progress: json['progress'] == null
          ? null
          : UserProgress.fromJson(json['progress'] as Map<String, dynamic>),
      createdAt: const TimestampConverter().fromJson(json['created_at']),
      lastSeen: const TimestampConverter().fromJson(json['last_seen']),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'email': instance.email,
      'photo_url': instance.photoUrl,
      'role': instance.role,
      'weight': instance.weight,
      'wallet_balance': instance.walletBalance,
      'total_credits_purchased': instance.totalCreditsPurchased,
      'progress': instance.progress?.toJson(),
      'created_at': const TimestampConverter().toJson(instance.createdAt),
      'last_seen': const TimestampConverter().toJson(instance.lastSeen),
    };

_$UserProgressImpl _$$UserProgressImplFromJson(Map<String, dynamic> json) =>
    _$UserProgressImpl(
      ikoLevel: json['iko_level'] as String?,
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
      'iko_level': instance.ikoLevel,
      'checklist': instance.checklist,
      'notes': instance.notes.map((e) => e.toJson()).toList(),
    };

_$UserNoteImpl _$$UserNoteImplFromJson(Map<String, dynamic> json) =>
    _$UserNoteImpl(
      date: const TimestampConverter().fromJson(json['date']),
      content: json['content'] as String,
      instructorId: json['instructor_id'] as String,
    );

Map<String, dynamic> _$$UserNoteImplToJson(_$UserNoteImpl instance) =>
    <String, dynamic>{
      'date': const TimestampConverter().toJson(instance.date),
      'content': instance.content,
      'instructor_id': instance.instructorId,
    };
