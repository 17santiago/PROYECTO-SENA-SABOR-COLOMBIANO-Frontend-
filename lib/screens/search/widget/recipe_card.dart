// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:frontend_recetas/models/recipe_model.dart';

import 'package:frontend_recetas/screens/recipe/recipe_deatil_screen.dart';



class ReSoltRecipiCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onFavorite;

  const ReSoltRecipiCard({
    super.key,
    required this.recipe,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailPage(recipe: recipe),
              ),
            );
          },
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen región con botón de favoritos
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        recipe.regionImage,
                        height: 87,
                        width: 313,
                        alignment: Alignment.bottomCenter,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const SizedBox(height: 160),
                      ),
                
                      // Capa oscura para mejor lectura
                      Container(
                        height: 87,
                        decoration: BoxDecoration(                          
                          color: Colors.black.withOpacity(0.35),
                        ),
                      ),
                
                      // Nombre de la receta encima
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
                          child: Text(
                            recipe.name,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Botón de favoritos en esquina superior derecha
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    
  }



