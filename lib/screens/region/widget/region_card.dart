import 'package:flutter/material.dart';
import 'package:frontend_recetas/models/region_model.dart';

class RegionCard extends StatelessWidget {
  final Region region;
  final VoidCallback? onTap;

  const RegionCard({super.key, required this.region, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5, // Ocupa la mitad del ancho
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            // Imagen de la región
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                region.imagen,
                width: double.infinity, // Ocupa todo el ancho disponible
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            // Cuadro con nombre de la región
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                region.nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}