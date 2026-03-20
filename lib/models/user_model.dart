import 'package:frontend_recetas/services/api_services.dart';



class User {
  final int id;
  final String name;
  final String? email; 
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    this.email,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profile_image'] != null
          ? '${ApiService.baseUrl}/uploads/profiles/${json['profile_image']}' 
          : null,
    );
  }


  String? get profileImageUrl {
    if (profileImage != null && !profileImage!.startsWith('http')) {
      return '${ApiService.baseUrl}/uploads/profiles/$profileImage';
    }
    return profileImage;
  }

  
}