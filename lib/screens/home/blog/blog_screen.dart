import 'package:flutter/material.dart';
import 'package:frontend_recetas/models/blog_model.dart';
import 'package:frontend_recetas/screens/home/blog/widgets/blog_card.dart';
import 'package:frontend_recetas/services/blog_services.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'B',
                      style: TextStyle(color: Color(0xFF3D3D3D)),
                    ),
                    TextSpan(
                      text: 'lo',
                      style: TextStyle(color: Color(0xFF0B76A6)),
                    ),
                    TextSpan(
                      text: 'gs',
                      style: TextStyle(color: Color(0xFF3D3D3D)),
                    ),
                  ],
                ),
              ),
            ),

            // ➖ SEPARADOR
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Divider(
                thickness: 2,
              ),
            ),

            const SizedBox(height: 8),

            // 📃 LISTA DE BLOGS
            Expanded(
              child: FutureBuilder<List<Blog>>(
                future: BlogServices().fetchBlogs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error cargando el blog'));
                  }

                  final blogs = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: blogs.length,
                    itemBuilder: (context, index) {
                      final blog = blogs[index];
                      return BlogCard(blog: blog);
                      
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

