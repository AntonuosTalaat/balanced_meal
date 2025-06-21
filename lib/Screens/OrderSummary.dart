import 'package:balanced_meal/Components/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/ProviderService.dart';
import '../components/SummaryCard.dart';
import '../components/SummaryRow.dart';
import '../Models/Ingredients.dart';
import '../services/ApiServices.dart';

class OrderSummary extends StatelessWidget {
  final double dailyCalories;

  const OrderSummary({super.key, required this.dailyCalories});

  @override
  Widget build(BuildContext context) {
    final mealState = Provider.of<MealState>(context);
    final ingredients = mealState.selectedItems;

    final Map<Ingredient, int> itemCounts = {};
    for (final item in ingredients) {
      itemCounts[item] = (itemCounts[item] ?? 0) + 1;
    }

    final sortedItems =
        itemCounts.keys.toList()..sort((a, b) => a.name.compareTo(b.name));

    final totalCalories = itemCounts.entries.fold(
      0,
      (sum, entry) => (sum + entry.key.calories * entry.value).toInt(),
    );

    final totalPrice = itemCounts.entries.fold(
      0.0,
      (sum, entry) => sum + entry.key.price * entry.value,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        title: const Text('Order Summary'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedItems.length,
                    itemBuilder: (context, index) {
                      final item = sortedItems[index];
                      final count = itemCounts[item]!;
                      return SummaryCard(
                        name: item.name,
                        price: '\$${item.price.toStringAsFixed(2)}',
                        calories: '${item.calories.toStringAsFixed(0)} Cal',
                        imageUrl: item.imageUrl,
                        initialQuantity: count,
                        onQuantityChanged: (newQty) {
                          mealState.updateItem(item, newQty);
                        },
                      );
                    },
                  ),
                  SummaryRow(
                    dailyCalories: dailyCalories,
                    totalCalories: totalCalories.toInt(),
                    totalPrice: totalPrice.toInt(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            child: CustomButton(
              text: 'Confirm',
              onPressed: () => _submitOrder(context, itemCounts),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitOrder(
    BuildContext context,
    Map<Ingredient, int> itemCounts,
  ) async {
    final List<Map<String, dynamic>> payload =
        itemCounts.entries.map((entry) {
          return {
            'name': entry.key.name,
            'total_price': entry.key.price * entry.value,
            'quantity': entry.value,
          };
        }).toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await ApiService.placeOrder(payload);
    Navigator.pop(context); // Close loading

    if (success) {
      Provider.of<MealState>(context, listen: false).clearItems();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to place order.")));
    }
  }
}
