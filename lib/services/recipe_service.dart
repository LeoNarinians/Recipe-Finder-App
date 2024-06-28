import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import '../models/recipe_response.dart';

class RecipeService {
  static const String apiUrl = 'https://api.edamam.com/search';
  static const String apiKey = '60bffe8ae36829e1ff7846a115789b50';
  static const String appId = 'f1c89c20';

  Future<List<Recipe>> fetchRecipesByCategory(String category) async {
    final randomQuery = getRandomQuery();
    final response = await http.get(Uri.parse('$apiUrl?q=$category $randomQuery&app_id=$appId&app_key=$apiKey'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final recipeResponse = RecipeResponse.fromJson(jsonResponse);
      List<Recipe> recipes = recipeResponse.hits
          .map((hit) => Recipe.fromJson(hit['recipe'] as Map<String, dynamic>))
          .toList();
      return recipes;
    } else {
      print('Failed to load recipes. Status code: ${response.statusCode}');
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<Recipe>> fetchFeaturedRecipes() async {
    final randomQuery = getRandomQuery();
    final response = await http.get(Uri.parse('$apiUrl?q=$randomQuery&app_id=$appId&app_key=$apiKey'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final recipeResponse = RecipeResponse.fromJson(jsonResponse);
      List<Recipe> recipes = recipeResponse.hits
          .map((hit) => Recipe.fromJson(hit['recipe'] as Map<String, dynamic>))
          .toList();
      print('Fetched ${recipes.length} featured recipes');
      return recipes;
    } else {
      print('Failed to load featured recipes. Status code: ${response.statusCode}');
      throw Exception('Failed to load featured recipes');
    }
  }

  Future<List<Recipe>> fetchRecipesByQuery(String query) async {
    final randomQuery = getRandomQuery();
    final response = await http.get(Uri.parse('$apiUrl?q=$query $randomQuery&app_id=$appId&app_key=$apiKey'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final recipeResponse = RecipeResponse.fromJson(jsonResponse);
      List<Recipe> recipes = recipeResponse.hits
          .map((hit) => Recipe.fromJson(hit['recipe'] as Map<String, dynamic>))
          .toList();
      return recipes;
    } else {
      print('Failed to load recipes by query. Status code: ${response.statusCode}');
      throw Exception('Failed to load recipes by query');
    }
  }

  // Generate a random query string for fetching recipes
  String getRandomQuery() {
    final queries = ['quick', 'easy', 'delicious', 'healthy', 'dinner', 'lunch', 'breakfast', 'snack'];
    return queries[Random().nextInt(queries.length)];
  }
}
