import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/ProviderService.dart';
import '../components/CustomButton.dart';
import '../components/FoodItemCard.dart';
import '../components/SummaryRow.dart';
import '../Models/Ingredients.dart';
import '../services/FirebaseServices.dart';
import 'OrderSummary.dart';

class CreateOrder extends StatefulWidget {
  final double dailyCalories;

  const CreateOrder({super.key, required this.dailyCalories});

  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Ingredient> carbItems = [];
  List<Ingredient> vegetableItems = [];
  List<Ingredient> meatItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  Future<void> _fetchIngredients() async {
    try {
      final vegetableItems = await _firebaseService.getIngredientsByCategory('Vegetables');
      final carbItems = await _firebaseService.getIngredientsByCategory('Carb');
      final meatItems = await _firebaseService.getIngredientsByCategory('Meats');

      setState(() {
        this.vegetableItems = vegetableItems;
        this.carbItems = carbItems;
        this.meatItems = meatItems;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading ingredients: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealState = Provider.of<MealState>(context);
    final totalCalories = mealState.totalCalories;
    final totalPrice = mealState.totalPrice;

    return Scaffold(
      backgroundColor: const Color(0xffFBFBFB),
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        title: const Text('Create your order'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (vegetableItems.isNotEmpty)
                _buildFoodSection('Vegetables', vegetableItems),
              const SizedBox(height: 24),
              if (meatItems.isNotEmpty)
                _buildFoodSection('Meats', meatItems),
              const SizedBox(height: 24),
              if (carbItems.isNotEmpty)
                _buildFoodSection('Carbs', carbItems),
              const SizedBox(height: 32),
              SummaryRow(
                dailyCalories: widget.dailyCalories,
                totalCalories: totalCalories.toInt(),
                totalPrice: totalPrice.toInt(),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Place order',
                onPressed: _isOrderAllowed(totalCalories)
                    ? () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          OrderSummary(dailyCalories: widget.dailyCalories,),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                }
                    : null,
                backgroundColor:
                _isOrderAllowed(totalCalories) ? Theme.of(context).primaryColor : Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodSection(String title, List<Ingredient> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : 16.0),
                child: SizedBox(
                  width: 180,
                  child: FoodItemCard(
                    name: item.name,
                    price: '\$${item.price.toStringAsFixed(2)}',
                    calories: '${item.calories.toStringAsFixed(0)} Cal',
                    imageUrl: item.imageUrl,
                    onQuantityChanged: (quantity) {
                      _handleIngredientSelection(item, quantity);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleIngredientSelection(Ingredient item, int quantity) {
    Provider.of<MealState>(context, listen: false).updateItem(item, quantity);
  }

  bool _isOrderAllowed(double totalCalories) {
    double min = widget.dailyCalories * 0.9;
    double max = widget.dailyCalories * 1.1;
    return totalCalories >= min && totalCalories <= max;
  }
}
