import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../../config/theme/colors.dart';
import '../../../../home/ui/pages/homepage.dart';
import '../../../login/ui/pages/login.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isEmployee = false;
  String? _selectedCountry;

  final List<String> countries = [
    'Company A',
    'Company B',
    'Company C',
    // Add more companies here...
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    final textScaleFactor = mediaQuery.textScaleFactor;
    final fontSize = width * 0.04 * textScaleFactor;
    final subheading = width * 0.04 * textScaleFactor;
    final heading = width * 0.07 * textScaleFactor;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: width,
                height: height,
                color: Colors.transparent,
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: Image.asset(
                'assets/images/greygradient.png',
                width: width,
                height: height / 1.7,
              ),
            ),
            Positioned(
              top: -30,
              left: -30,
              child: Image.asset(
                'assets/images/greengradient.png',
                width: width,
                height: height / 1.7,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.09,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Join",
                          style: TextStyle(
                              fontSize: heading, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "SehatGhar",
                          style: TextStyle(
                              fontSize: heading,
                              fontWeight: FontWeight.bold,
                              color: AppColors.green),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.020),
                    SizedBox(
                      width: width - 80,
                      child: Text(
                        "Today and be part of a community of people who are committed to living healthier lives.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                    SizedBox(height: height * 0.020),
                    buildTextFormField('Full Name*', _nameController),
                    SizedBox(height: height * 0.02),
                    buildTextFormField(
                      'Phone No*',
                      _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: height * 0.02),
                    buildTextFormField('Age', _ageController,
                        keyboardType: TextInputType.number),
                    SizedBox(height: height * 0.02),
                    buildTextFormField(
                      'Password*',
                      _passwordController,
                      obscureText: _obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    buildTextFormField(
                      'Confirm Password*',
                      _confirmpasswordController,
                      obscureText: _obscureConfirmPassword,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    buildCheckboxAndDropdown(),
                    SizedBox(height: height * 0.02),
                    if (_isEmployee)
                      buildTextFormField('Employee ID*', _locationController),
                    SizedBox(height: height * 0.03),
                    buildSignUpButton(subheading),
                    SizedBox(height: height * 0.02),
                    buildTermsAndConditions(),
                    SizedBox(height: height * 0.07),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      String labelText, TextEditingController controller,
      {bool obscureText = false,
      TextInputType? keyboardType,
      Widget? suffixIcon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: labelText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  Widget buildCheckboxAndDropdown() {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              activeColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              value: _isEmployee,
              onChanged: (value) {
                setState(() {
                  _isEmployee = value ?? false;
                });
              },
            ),
            Text('Are you a corporate employee??'),
          ],
        ),
        if (_isEmployee)
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Select Company*',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            items: countries.map((String country) {
              return DropdownMenuItem<String>(
                value: country,
                child: Text(country),
              );
            }).toList(),
            value: _selectedCountry,
            onChanged: (value) {
              setState(() {
                _selectedCountry = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your country';
              }
              return null;
            },
          ),
      ],
    );
  }

  Container buildSignUpButton(double subheading) {
    return Container(
      height: subheading * 3,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (ctx) => HomePage()));
          }
        },
        child: Text(
          "Sign up",
          style: TextStyle(color: Colors.white, fontSize: subheading),
        ),
      ),
    );
  }

  Widget buildTermsAndConditions() {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'By Becoming a member, you agree',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'to our ',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: 'Terms & Conditions',
                style: TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Have an account?',
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: 'Login',
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (ctx) => Login()));
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
