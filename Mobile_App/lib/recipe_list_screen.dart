import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<String> recipes = [];
  List<String> filteredRecipes = []; // To store the filtered list
  TextEditingController searchController = TextEditingController(); // Controller for the search bar

  // Function to load recipes from shared preferences
  Future<void> _loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recipes = prefs.getStringList('recipes') ?? [];
      filteredRecipes = List.from(recipes); // Initially, display all recipes
    });
  }

  // Function to filter recipes based on search input
  void _filterRecipes(String query) {
    final filtered = recipes.where((recipe) {
      final recipeDetails = recipe.split(':');
      final recipeName = recipeDetails[0].toLowerCase();
      final recipeIngredients = recipeDetails[1].toLowerCase();

      return recipeName.contains(query.toLowerCase()) ||
          recipeIngredients.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredRecipes = filtered;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRecipes(); // Load recipes when the screen is first loaded
    searchController.addListener(() {
      _filterRecipes(searchController.text); // Filter recipes as the user types
    });
  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: RecipeSearchDelegate(recipes));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name or Ingredients',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index].split(':');
                  final recipeName = recipe[0];
                  final recipeIngredients = recipe[1];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(recipeName),
                      subtitle: Text(recipeIngredients),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // You can navigate to a recipe details screen here
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Tapped on: $recipeName'),
                        ));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeSearchDelegate extends SearchDelegate {
  final List<String> recipes;

  RecipeSearchDelegate(this.recipes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = recipes.where((recipe) {
      final recipeDetails = recipe.split(':');
      final recipeName = recipeDetails[0].toLowerCase();
      final recipeIngredients = recipeDetails[1].toLowerCase();

      return recipeName.contains(query.toLowerCase()) ||
          recipeIngredients.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final recipe = results[index].split(':');
        final recipeName = recipe[0];
        final recipeIngredients = recipe[1];

        return Card(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            title: Text(recipeName),
            subtitle: Text(recipeIngredients),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Tapped on: $recipeName'),
              ));
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = recipes.where((recipe) {
      final recipeDetails = recipe.split(':');
      final recipeName = recipeDetails[0].toLowerCase();
      final recipeIngredients = recipeDetails[1].toLowerCase();

      return recipeName.contains(query.toLowerCase()) ||
          recipeIngredients.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final recipe = suggestions[index].split(':');
        final recipeName = recipe[0];
        final recipeIngredients = recipe[1];

        return Card(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            title: Text(recipeName),
            subtitle: Text(recipeIngredients),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Tapped on: $recipeName'),
              ));
            },
          ),
        );
      },
    );
  }
}
