import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Ingredients.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Ingredient>> getIngredientsByCategory(String category) async {
    final snapshot = await _firestore.collection(category).get();

    return snapshot.docs
        .map((doc) => _mapToIngredient(doc, category))
        .toList();
  }

  Ingredient _mapToIngredient(DocumentSnapshot doc, String category) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return Ingredient(
      id: doc.id,
      name: data['food_name'] ?? '',
      calories: (data['calories'] ?? 0).toDouble(),
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['image_url'] ?? '',
      category: category,
    );
  }
}
