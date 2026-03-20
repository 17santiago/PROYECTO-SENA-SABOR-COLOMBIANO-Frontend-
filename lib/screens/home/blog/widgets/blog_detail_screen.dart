import 'package:flutter/material.dart';
import 'package:frontend_recetas/models/blog_model.dart';


class BlogDetailScreen extends StatelessWidget {
  final Blog blog;
  

  const BlogDetailScreen({super.key, required this.blog, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(    
        
        
        
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // IMAGE
            
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  Text(
                    blog.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF0B76A6),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    
                    blog.content,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(                    
                    'Región: ${blog.regionName}',
                    style: const TextStyle(
                      fontSize: 18,
                       fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
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
