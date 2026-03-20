import 'package:flutter/material.dart';
import 'package:frontend_recetas/provider/favorite_provider.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatefulWidget {
  final int recipeId;

  const FavoriteButton({super.key, required this.recipeId});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isLoading = false;

  Future<void> _toggleFavorite() async {
    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<FavoriteProvider>(context, listen: false);
      final isFavorite = provider.isFavorite(widget.recipeId);

      if (isFavorite) {
        await provider.removeFavorite(widget.recipeId);
      } else {
        await provider.addFavorite(widget.recipeId);
      }
    } catch (e) {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios del provider para repintar el icono
    return Consumer<FavoriteProvider>(
      builder: (context, provider, child) {
        final isFavorite = provider.isFavorite(widget.recipeId);

        return IconButton(
          icon: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                  size: 28, 
                ),
          onPressed: _isLoading ? null : _toggleFavorite,
          style: IconButton.styleFrom(
            // ignore: deprecated_member_use
            backgroundColor: Colors.black.withOpacity(0.4), 
            padding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), 
            ),
          ),
        );
      },
    );
  }
}
