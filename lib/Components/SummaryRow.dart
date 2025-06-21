import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  final int totalCalories;
  final double dailyCalories;
  final int totalPrice;
  const SummaryRow({super.key, required this.totalCalories, required this.dailyCalories, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                '$totalCalories Cal out of ${dailyCalories.toInt()} Cal',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Price', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
