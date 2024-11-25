// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      selfText: json['selfText'] as String? ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      numComments: (json['numComments'] as num?)?.toInt() ?? 0,
      author: json['author'] as String? ?? '',
      permalink: json['permalink'] as String? ?? '',
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'selfText': instance.selfText,
      'score': instance.score,
      'numComments': instance.numComments,
      'author': instance.author,
      'permalink': instance.permalink,
    };
