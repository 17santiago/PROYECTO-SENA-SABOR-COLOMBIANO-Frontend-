import 'package:flutter/material.dart';
import 'package:frontend_recetas/models/recipe_model.dart';
import 'package:frontend_recetas/screens/recipe/recipe_deatil_screen.dart';
import 'package:frontend_recetas/widget/favorite_buton.dart';

class RecipeiCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeiCard({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;

    // Márgenes laterales: 5% del ancho de la pantalla (en lugar de 50 fijos)
    final horizontalMargin = screenWidth * 0.05;

    // Ancho de la tarjeta = ancho total - márgenes izquierdo y derecho
    final cardWidth = screenWidth - (horizontalMargin * 2);

    // Altura de la imagen se mantiene igual (92)
    const imageHeight = 92.0;

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
        margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
          vertical: 15, 
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), 
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Stack(
                children: [
                  // 🖼️ Imagen de fondo
                  Image.network(
                    recipe.regionImage,
                    height: imageHeight,
                    width: cardWidth, 
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const SizedBox(height: imageHeight),
                  ),
                  // Capa oscura 
                  Container(
                    height: imageHeight,
                    width: cardWidth,
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.35),
                    ),
                  ),
                  // 📝 Nombre centrado
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 32,
                      ),
                      child: Text(
                        recipe.name,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteButton(recipeId: recipe.id),
                    
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}