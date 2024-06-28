import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
import '../models/recipe.dart';
import '../pages/recipe_detail.dart';

class CategoryPage extends StatefulWidget {
  final String category;

  CategoryPage({required this.category});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<List<Recipe>> futureRecipes;
  final List<Recipe> _recipes = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoadingMore) {
        fetchMoreRecipes();
      }
    });
  }

  void fetchRecipes() {
    setState(() {
      futureRecipes = RecipeService().fetchRecipesByCategory(widget.category).then((recipes) {
        _recipes.addAll(recipes);
        return _recipes;
      });
    });
  }

  void fetchMoreRecipes() {
    setState(() {
      _isLoadingMore = true;
    });
    RecipeService().fetchRecipesByCategory(widget.category).then((moreRecipes) {
      setState(() {
        _isLoadingMore = false;
        _recipes.addAll(moreRecipes);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Recipes'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recipes found.'));
          } else {
            return ListView.builder(
              controller: _scrollController,
              itemCount: _recipes.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _recipes.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final recipe = _recipes[index];
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
      ),
    );
  }
}
