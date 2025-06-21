import 'package:flutter/material.dart';
import '../Components/CustomButton.dart';
import 'CreateOrder.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _formKey = GlobalKey<FormState>();

  String? gender;
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  bool get isFormValid {
    return gender != null &&
        weightController.text.trim().isNotEmpty &&
        heightController.text.trim().isNotEmpty &&
        ageController.text.trim().isNotEmpty;
  }

  void _updateState() => setState(() {});

  @override
  void initState() {
    super.initState();
    weightController.addListener(_updateState);
    heightController.addListener(_updateState);
    ageController.addListener(_updateState);
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){Navigator.pop(context);},
            child: Icon(Icons.keyboard_arrow_left)),
        title: const Text("Enter your details"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.07),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 24),
                _buildLabel("Gender"),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Choose your gender',
                        style: TextStyle(color: Colors.grey),
                      ),
                      value: gender,
                      items: const [
                        DropdownMenuItem(
                          value: 'Male',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text('Female'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLabel("Weight"),
                TextFormField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration("Enter your weight",'Kg')
                ),
                const SizedBox(height: 20),
                _buildLabel("Height"),
                TextFormField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration("Enter your height","Cm")
                ),
                const SizedBox(height: 20),
                _buildLabel("Age"),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("Enter your age"),
                ),
                const SizedBox(height:180),
                CustomButton(
                  text: "Next",
                  isEnabled: isFormValid,
                  onPressed: () {
                    final double weight = double.parse(weightController.text);
                    final double height = double.parse(heightController.text);
                    final int age = int.parse(ageController.text);

                    final double dailyCalories = calculateDailyCalories(
                      gender: gender!,
                      weight: weight,
                      height: height,
                      age: age,
                    );

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>  CreateOrder(dailyCalories: dailyCalories),
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
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, [String? suffix]) {
    return InputDecoration(
      hintText: hint,
      suffixText: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    );
  }

  double calculateDailyCalories({
    required String gender,
    required double weight,
    required double height,
    required int age,
  }) {
    if (gender == 'Female') {
      return 655.1 + (9.56 * weight) + (1.85 * height) - (4.67 * age);
    } else {
      return 666.47 + (13.75 * weight) + (5 * height) - (6.75 * age);
    }
  }
}