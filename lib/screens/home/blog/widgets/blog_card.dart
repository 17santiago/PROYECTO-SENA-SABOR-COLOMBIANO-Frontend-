import 'package:flutter/material.dart';
import 'package:frontend_recetas/models/blog_model.dart';
import 'package:frontend_recetas/screens/home/blog/widgets/blog_detail_screen.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;

  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BlogDetailScreen(blog: blog)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal:  24, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            
            colors: [
              Color(0xFF0B76A6),
              Color(0xFF042D40)],
            stops: [0.5, 1.0],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 253, 252, 252),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      blog.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(221, 252, 250, 250),
                      ),
                    ),
                    
                    const SizedBox(width: 10),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // IMAGE + MASCARA
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  
                ),
                child: Stack(
                  children: [
                    Image.network(
                      blog.imageUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      // ignore: deprecated_member_use
                      color: Colors.blue.withOpacity(0.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
