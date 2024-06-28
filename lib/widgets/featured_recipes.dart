import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
import '../models/recipe.dart';
import '../pages/recipe_detail.dart';

class FeaturedRecipes extends StatefulWidget {
  @override
  _FeaturedRecipesState createState() => _FeaturedRecipesState();
}

class _FeaturedRecipesState extends State<FeaturedRecipes> {
  late Future<List<Recipe>> futureRecipes;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  void fetchRecipes() {
    futureRecipes = RecipeService().fetchFeaturedRecipes();
    futureRecipes.then((recipes) {
      setState(() {
        print('Recipes fetched: ${recipes.length}');
      });
    }).catchError((error) {
      print("Error fetching recipes: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: futureRecipes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No recipes found.'));
        } else {
          List<Recipe> recipes = snapshot.data!;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetail(recipe: recipe),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        recipe.image ?? 'https://via.placeholder.com/150',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 8),
                      Text(
                        recipe.label ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (recipe.calories != null)
                        Chip(
                          label: Text('${recipe.calories!.toStringAsFixed(0)} Calories'),
                          backgroundColor: Colors.grey[300],
                        ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}