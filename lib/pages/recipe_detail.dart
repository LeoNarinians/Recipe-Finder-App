import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe.dart';

class RecipeDetail extends StatelessWidget {
  final Recipe recipe;

  RecipeDetail({required this.recipe});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.label),
        backgroundColor: Colors.white70, // Change the AppBar background color here
      ),
      backgroundColor: Colors.white, // Set the background color of the entire page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recipe.image.isNotEmpty)
                Image.network(
                  recipe.image,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 8),
              Text(
                recipe.label,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (recipe.calories != null)
                Chip(
                  label: Text('${recipe.calories!.toStringAsFixed(0)} Calories'),
                  backgroundColor: Colors.grey[300], // Light grey background color
                  // No border property needed
                ),
              SizedBox(height: 16),
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildIngredientsTable(recipe.ingredientLines),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Check out the recipe here:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchUrl(recipe.url);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    recipe.url,
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsTable(List<String>? ingredients) {
    if (ingredients == null || ingredients.isEmpty) {
      return Text('No ingredients available.');
    }

    return Table(
      columnWidths: {
        0: FlexColumnWidth(),
      },
      children: ingredients.asMap().entries.map((entry) {
        int index = entry.key;
        String ingredient = entry.value;
        Color rowColor = index % 2 == 0 ? Colors.grey[100]! : Colors.grey[300]!; // Alternate row colors
        return TableRow(
          children: [
            Container(
              color: rowColor,
              padding: const EdgeInsets.all(8.0),
              child: Text(ingredient),
            ),
          ],
        );
      }).toList(),
    );
  }
}
