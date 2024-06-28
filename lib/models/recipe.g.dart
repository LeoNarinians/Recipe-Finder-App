// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      label: json['label'] as String,
      image: json['image'] as String,
      url: json['url'] as String,
      calories: (json['calories'] as num?)?.toDouble(),
      totalTime: (json['totalTime'] as num?)?.toInt(),
      ingredientLines: (json['ingredientLines'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      instructions: (json['instructions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'label': instance.label,
      'image': instance.image,
      'url': instance.url,
      'calories': instance.calories,
      'totalTime': instance.totalTime,
      'ingredientLines': instance.ingredientLines,
      'instructions': instance.instructions,
    };
