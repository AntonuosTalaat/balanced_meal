// lib/providers/meal_state.dart
import 'package:flutter/material.dart';
import '../Models/Ingredients.dart';

class MealState extends ChangeNotifier {
  final List<Ingredient> _selectedItems = [];

  List<Ingredient> get selectedItems => _selectedItems;

  void updateItem(Ingredient item, int quantity) {
    _selectedItems.removeWhere((i) => i.name == item.name);
    _selectedItems.addAll(List.filled(quantity, item));
    notifyListeners();
  }

  void clearItems() {
    _selectedItems.clear();
    notifyListeners();
  }

  double get totalCalories => _selectedItems.fold(0, (sum, i) => sum + i.calories);
  double get totalPrice => _selectedItems.fold(0.0, (sum, i) => sum + i.price);
}
