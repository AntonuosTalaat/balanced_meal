import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  final String id;
  final String name;
  final double calories;
  final double price;
  final String imageUrl;
  final String category;

  Ingredient({
    required this.id,
    required this.name,
    required this.calories,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory Ingredient.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ingredient(
      id: doc.id,
      name: data['food_name'] ?? '',
      calories: (data['calories'] ?? 0).toDouble(),
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['image_url'] ?? '',
      category: data['category'],
    );
  }

}