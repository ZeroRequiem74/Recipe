import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<String> recipes = [];

  // Function to load recipes from shared preferences
  Future<void> _loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recipes = prefs.getStringList('recipes') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRecipes(); // Load recipes when the screen is first loaded
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recipe List',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index].split(':');
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
