import 'package:flutter/material.dart';
import '../../../../models/recipe_model.dart';

class IngredientesTab extends StatelessWidget {
  final Recipe recipe;

  const IngredientesTab({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final ingredientsList = recipe.ingredients
        .split(RegExp(r',|\n'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  
    return ListView( 
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      children: [
        const SizedBox(height: 18),
        const Text(
          'Ingredientes:',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Tamaño ajustado
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ...ingredientsList.map(
          (ingredient) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Expanded( // Usar Expanded en lugar de Flexible suele ser mejor en filas de listas
                  child: Text(
                    ingredient,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}