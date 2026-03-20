import 'package:flutter/material.dart';
import 'package:frontend_recetas/models/region_model.dart';
import 'package:frontend_recetas/models/recipe_model.dart';
import 'package:frontend_recetas/services/favorite_services.dart';
import 'package:frontend_recetas/services/search_services.dart';
import 'package:frontend_recetas/widget/recipe_card.dart';

class RegionRecipesScreen extends StatefulWidget {
  final Region region;

  const RegionRecipesScreen({super.key, required this.region});

  @override
  State<RegionRecipesScreen> createState() => _RegionRecipesScreenState();
}

class _RegionRecipesScreenState extends State<RegionRecipesScreen> {
  final SearchServices _apiService = SearchServices();
  late Future<List<Recipe>> _recipesFuture;
  Set<int> favoriteIds = {}; // 👈 IDs de recetas favoritas del usuario

  @override
  void initState() {
    super.initState();
    _recipesFuture = _apiService.searchRecipes(widget.region.nombre);
    _loadFavorites(); // 👈 Cargar favoritos al abrir la pantalla
  }

  // 🔁 Obtener favoritos desde el backend
  Future<void> _loadFavorites() async {
    try {
      final favorites = await FavoriteServices.getFavorites();
      final ids = favorites.map<int>((fav) => fav['id'] as int).toSet();
      setState(() {
        favoriteIds = ids;
      });
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // ---- Cabecera con nombre de región ----
            Column(
              children: [
                const Text(
                  'Región',
                  style: TextStyle(
                    fontSize: 48,
                    color: Color(0xFF0B76A6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.region.nombre,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // ---- Imagen decorativa ----
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 8,
                  top: -62,
                  child: Transform.rotate(
                    angle: 38.5,
                    child: Container(
                      width: 180,
                      height: 330,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF042D40), Color(0xFF0B76A6)],
                          stops: [0.5, 1],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(290, 490)),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    widget.region.imagen,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // ---- Separador "RECETAS" ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 52),
              child: Column(
                children: [
                  const Divider(color: Colors.black, thickness: 1),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      'RECETAS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.black, thickness: 1),
                ],
              ),
            ),

            // ---- Lista de recetas ----
            Expanded(
              child: FutureBuilder<List<Recipe>>(
                future: _recipesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error al cargar recetas'));
                  }

                  final recipes = snapshot.data ?? [];

                  if (recipes.isEmpty) {
                    return const Center(
                        child: Text('No hay recetas para esta región'));
                  }

                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];

                      return RecipeiCard(
                        recipe: recipe,
                        
                      );
                    },
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