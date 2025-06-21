import 'package:flutter/material.dart';

import '../Components/CustomButton.dart';
import 'PersonalDetails.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'images/background.jpg',
            fit: BoxFit.cover,
          ),

          // Color overlay (orange tint)
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.05),

                  // Title
                  Text(
                    "Balanced Meal",
                    style: TextStyle(
                      fontSize: size.width * 0.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(),

                  // Description Text
                  Text(
                    "Craft your ideal meal effortlessly\nwith our app. Select nutritious\ningredients tailored to your taste\nand well-being.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * 0.055,
                      height: 1.6,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),

                  // Order Food Button
                  CustomButton(
                    text: "Order Food",
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const PersonalDetails(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            // You can choose from various animations:

                            // Slide from right
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
                    },
                    width: size.width * 0.9,
                    textColor: Colors.white,
                  ),

                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


