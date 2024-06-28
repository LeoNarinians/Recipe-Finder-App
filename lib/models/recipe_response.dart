import 'package:json_annotation/json_annotation.dart';

part 'recipe_response.g.dart';

@JsonSerializable()
class RecipeResponse {
  @JsonKey(name: 'hits')
  final List<Map<String, dynamic>> hits;

  RecipeResponse({required this.hits});

  factory RecipeResponse.fromJson(Map<String, dynamic> json) => _$RecipeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeResponseToJson(this);
}
