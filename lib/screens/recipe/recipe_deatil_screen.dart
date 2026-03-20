import 'package:flutter/material.dart';
import 'package:frontend_recetas/screens/recipe/widgets/imagenes_tab.dart';
import 'package:frontend_recetas/screens/recipe/widgets/ingredientes_tab.dart';
import 'package:frontend_recetas/screens/recipe/widgets/pasos_tab.dart';

import '../../../models/recipe_model.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Título con mitad azul y mitad negro
  Widget _buildColoredTitle(String text) {
    final middle = (text.length / 2).floor();

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 52,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: text.substring(0, middle),
            style: const TextStyle(color: Color(0xFF0B76A6)),
            
          ),
          TextSpan(
            text: text.substring(middle),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,        
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// TÍTULO
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: _buildColoredTitle(widget.recipe.name),
            ),

            const Divider(thickness: 1, color: Colors.black,),

            /// TAB BAR ESTILIZADO
            Container(
              margin: const EdgeInsets.symmetric(vertical: 14),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(                
                gradient: LinearGradient(colors: [
                  const Color(0xFF719CAF),
                  const Color(0xFF6BBBDF),
                ], stops: const [0.5, 1.0]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(  
                dividerColor: Colors.transparent,              
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFFD4D3D3), // azul claro
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: const Color.fromARGB(255, 7, 7, 7),
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(fontSize: 12),
                tabs: const [
                  Tab(text: 'Ingredientes'),
                  Tab(text: 'Pasos'),
                  Tab(text: 'Imágen'),
                ],
              ),
            ),

            /// CONTENIDO
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  IngredientesTab(recipe: widget.recipe),
                  PasosTab(recipe: widget.recipe),
                  ImagenesTab(recipe: widget.recipe),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
