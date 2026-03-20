import 'package:flutter/material.dart';
import 'package:frontend_recetas/models/recipe_model.dart';
import 'package:frontend_recetas/services/favorite_services.dart';
import 'package:frontend_recetas/services/api_services.dart';

class FavoriteProvider extends ChangeNotifier {
  Set<int> _favoriteIds = {};
  List<Recipe> _favoriteRecipes = [];

  Set<int> get favoriteIds => _favoriteIds;
  List<Recipe> get favoriteRecipes => _favoriteRecipes;

  Future<void> loadFavorites() async {
    try {
      final favoritesData = await FavoriteServices.getFavorites();
      _favoriteIds = favoritesData.map<int>((fav) => fav['id'] as int).toSet();
      _favoriteRecipes = favoritesData.map((fav) {
        return Recipe(
          id: fav['id'],
          name: fav['name'] ?? 'Sin nombre',
          ingredients: fav['ingredients'] ?? '',
          steps: fav['steps'] ?? '',
          regionImage: fav['region'] != null
              ? '${ApiService.baseUrl}/uploads/${fav['region']}'
              : '',
          galery: (fav['galery'] != null && fav['galery'] != '')
    ? '${ApiService.baseUrl}/uploads/recipes/${fav['galery']}'
    : ''
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      _favoriteIds = {};
      _favoriteRecipes = [];
      notifyListeners();
    }
  }

  Future<void> addFavorite(int recipeId) async {
    try {
      await FavoriteServices.addFavorite(recipeId);
      _favoriteIds.add(recipeId);      
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> removeFavorite(int recipeId) async {
    try {
      await FavoriteServices.removeFavorite(recipeId);
      _favoriteIds.remove(recipeId);
      _favoriteRecipes.removeWhere((r) => r.id == recipeId);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  bool isFavorite(int recipeId) => _favoriteIds.contains(recipeId);
}
