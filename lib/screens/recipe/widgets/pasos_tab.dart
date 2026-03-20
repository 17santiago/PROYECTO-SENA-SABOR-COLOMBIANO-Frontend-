import 'package:flutter/material.dart';
import 'package:frontend_recetas/models/recipe_model.dart';

class PasosTab extends StatelessWidget {
  final Recipe recipe;

  // Corregido el constructor (se eliminó un required extra)
  const PasosTab({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final ingredientsList = recipe.steps
        .split(RegExp(r',|\n')) // Separa por coma o salto de línea
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return SingleChildScrollView(
      // El scrollview permite que la lista baje si es muy larga
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16, // Aumentado un poco para mejor respiro visual
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Pasos:',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 30),

            /// LISTA NUMERADA
            ...List.generate(ingredientsList.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  // CrossAxisAlignment.start alinea el número arriba del texto
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0), // Opcional: para resaltar el número
                      ),
                    ),
                    const SizedBox(width: 8), // Espacio entre número y texto
                    Expanded(
                      // Expanded obliga al texto a ocupar el resto del ancho y saltar de línea
                      child: Text(
                        ingredientsList[index],
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.4, // Mejora la lectura entre líneas
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            // Espacio extra al final para que no pegue con el borde de la pantalla
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}