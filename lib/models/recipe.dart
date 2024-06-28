import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  final String label;
  final String image;
  final String url;
  final double? calories; // Adjusted type to match the API response
  final int? totalTime;
  final List<String>? ingredientLines; // Adjusted field name to match the API response
  final List<String>? instructions; // Adjusted field name to match the API response

  Recipe({
    required this.label,
    required this.image,
    required this.url,
    this.calories,
    this.totalTime,
    this.ingredientLines,
    this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}
