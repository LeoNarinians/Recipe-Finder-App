import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
import '../models/recipe.dart';
import '../pages/recipe_detail.dart';
import 'dart:math';

class SearchResultsPage extends StatefulWidget {
  final String query;

  SearchResultsPage({required this.query});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
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
      futureRecipes = RecipeService().fetchRecipesByQuery(widget.query).then((recipes) {
        _recipes.addAll(recipes);
        return _recipes;
      });
    });
  }

  void fetchMoreRecipes() {
    setState(() {
      _isLoadingMore = true;
    });
    RecipeService().fetchRecipesByQuery(widget.query).then((moreRecipes) {
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
        title: Text('Search Results'),
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
