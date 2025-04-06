import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRecipeScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();

  // Function to save a recipe locally
  Future<void> _saveRecipe(String name, String ingredients) async {
    final prefs = await SharedPreferences.getInstance();
    // Load current recipes or initialize a new list
    List<String> recipes = prefs.getStringList('recipes') ?? [];

    // Save the new recipe as a string in the format "name:ingredients"
    recipes.add('$name:$ingredients');

    // Save the updated list of recipes back to shared preferences
    await prefs.setStringList('recipes', recipes);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Recipe',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Recipe Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: ingredientsController,
              decoration: InputDecoration(
                labelText: 'Ingredients',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    ingredientsController.text.isNotEmpty) {
                  // Save the recipe to local storage
                  await _saveRecipe(
                    nameController.text,
                    ingredientsController.text,
                  );

                  // Clear the text fields and show confirmation
                  nameController.clear();
                  ingredientsController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Recipe added: ${nameController.text}'),
                  ));
                }
              },
              child: Text('Add Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
