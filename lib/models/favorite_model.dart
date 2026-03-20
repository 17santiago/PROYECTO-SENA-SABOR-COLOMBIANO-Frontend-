// models/favorite_state_model.dart
class FavoriteState {
  final Set<int> favoriteIds;
  final bool isLoading;
  final String? error;

  FavoriteState({
    required this.favoriteIds,
    this.isLoading = false,
    this.error,
  });

  FavoriteState copyWith({
    Set<int>? favoriteIds,
    bool? isLoading,
    String? error,
  }) {
    return FavoriteState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool isFavorite(int recipeId) => favoriteIds.contains(recipeId);
}