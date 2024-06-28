import 'package:flutter/material.dart';
import '../widgets/category_list.dart';
import '../widgets/featured_recipes.dart';
import '../pages/search_results_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(query: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Finder'),
        backgroundColor: Colors.grey[300], // Change the AppBar background color here

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300], // Light grey background color
                borderRadius: BorderRadius.circular(30.0), // Increased border radius for bubble effect
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding inside the bubble
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for recipes...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: _onSearchSubmitted,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            CategoryList(),
            SizedBox(height: 16),
            Text(
              'Featured Recipes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: FeaturedRecipes(),
            ),
          ],
        ),
      ),
    );
  }
}
