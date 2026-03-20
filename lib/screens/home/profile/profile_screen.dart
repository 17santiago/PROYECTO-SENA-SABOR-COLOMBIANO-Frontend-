// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_recetas/provider/favorite_provider.dart';
import 'package:provider/provider.dart'; // 👈 AGREGADO
import 'package:frontend_recetas/services/profile_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend_recetas/models/user_model.dart';
import 'package:frontend_recetas/services/api_services.dart';
import 'package:frontend_recetas/widget/recipe_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadFavoritesOnce(); // Carga los favoritos UNA VEZ al iniciar
  }

  // Carga los favoritos en el provider (solo si está vacío)
  Future<void> _loadFavoritesOnce() async {
    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    if (provider.favoriteRecipes.isEmpty) {
      await provider.loadFavorites();
    }
  }

  //Cargar perfil del usuario
  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final profileData = await ProfileServices.getProfile();
      setState(() {
        _user = User.fromJson(profileData);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar perfil')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  // Métodos de foto de perfil
  Future<void> _showPhotoOptions() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.blue),
              title: Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.green),
              title: Text('Elegir de galería'),
              onTap: () {
                Navigator.pop(context);
                _pickPhotoFromGallery();
              },
            ),
            if (_user?.profileImage != null)
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Eliminar foto',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeletePhoto();
                },
              ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhotoFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _uploadPhoto(File(pickedFile.path));
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await _uploadPhoto(File(pickedFile.path));
    }
  }

  Future<void> _uploadPhoto(File imageFile) async {
    setState(() => _loading = true);
    try {
      final result = await ProfileServices.uploadProfilePhoto(imageFile);
      if (result['success']) {
        await _loadProfile();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _confirmDeletePhoto() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar foto'),
        content: Text('¿Estás seguro de que quieres eliminar tu foto de perfil?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePhoto();
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePhoto() async {
    setState(() => _loading = true);
    try {
      final result = await ProfileServices.deleteProfilePhoto();
      if (result['success']) {
        await _loadProfile();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar sesión'),
        content: Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await ApiService.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/welcome',
                (route) => false,
              );
            },
            child: Text('Salir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // SECCIÓN SUPERIOR: FOTO + NOMBRE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: _showPhotoOptions,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xff0B76A6), Color(0xff042D40)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xff0B76A6), Color(0xff042D40)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 4, color: Colors.transparent),
                                ),
                                child: _user?.profileImage != null
                                    ? ClipOval(
                                        child: Image.network(
                                          _user!.profileImageUrl!,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return CircleAvatar(
                                              backgroundColor: Colors.blue[100],
                                              child: Icon(Icons.person, size: 60, color: Colors.blue),
                                            );
                                          },
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.blue[100],
                                        child: Icon(Icons.person, size: 60, color: Colors.blue),
                                      ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.edit, size: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          _user?.name ?? 'Usuario',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Padding(
                   padding: EdgeInsets.symmetric(horizontal: 60),
                   child: Divider(
                     thickness: 2,
                   ),
                  ),
                  const SizedBox(height: 20),


                  // SECCIÓN DE FAVORITOS REACTIVA
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Favoritos',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B76A6),
                          ),
                        ),
                        const SizedBox(height: 10),

                        //CONSUMER: se repinta automáticamente al cambiar favoritos
                        Consumer<FavoriteProvider>(
                          builder: (context, provider, child) {
                            final recipes = provider.favoriteRecipes;

                            if (recipes.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: Text(
                                    'No tienes recetas favoritas',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}