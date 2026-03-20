import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend_recetas/models/recipe_model.dart';
import 'package:frontend_recetas/services/favorite_services.dart';
import 'package:frontend_recetas/services/search_services.dart';
import 'package:frontend_recetas/widget/recipe_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchServices apiService = SearchServices();
  List<Recipe> recipes = [];
  Set<int> favoriteIds = {};
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // 👈 Cargar favoritos al abrir la página
  }

  // 🔁 Cargar favoritos desde el backend
  Future<void> _loadFavorites() async {
    try {
      final favorites =
          await FavoriteServices.getFavorites(); // Tu método en ApiService
      final ids = favorites.map<int>((fav) => fav['id'] as int).toSet();
      setState(() {
        favoriteIds = ids;
      });
    } catch (e) {
      // Si el usuario no está autenticado o hay error, el set queda vacío
      
    }
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final result = await apiService.searchRecipes(query);
      setState(() {
        recipes = result;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
                children: [
                  TextSpan(
                    text: 'Bu',
                    style: TextStyle(color: Color(0xFF000000)),
                  ),
                  TextSpan(
                    text: 'sque',
                    style: TextStyle(color: Color(0xFF0B76A6)),
                  ),
                  TextSpan(
                    text: 'da',
                    style: TextStyle(color: Color(0xFF000000)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            const Divider(thickness: 1.2, indent: 32, endIndent: 32),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0B76A6), Color(0xFF042D40)],
                  stops: [0.5, 1],
                ),
              ),
              child: TextField(
                onChanged: onSearchChanged,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Busca región , receta o ingrediente',
                  hintStyle: TextStyle(
                    // ignore: deprecated_member_use
                    color: Colors.white,
                  ),
                  suffixIcon: const Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),

            const SizedBox(height: 50),

            const Text(
              'Resultados',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 12),

            /// 🔹 LIST VIEW
            Expanded(
              child: recipes.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay resultados',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {                        
                        return RecipeiCard(
                          recipe: recipes[index],
                          
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
