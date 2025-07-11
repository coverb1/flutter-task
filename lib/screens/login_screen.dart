import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with default values
    _usernameController.text = 'emlys';
    _passwordController.text = '**********';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Handle login logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login functionality would be implemented here'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 34),
          child: Column(
            children: [
              const SizedBox(height: 68),
              
              // Login Title
              Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 189),
              
              // Recipe Book Title
              Text(
                'Recip Book',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 177),
              
              // Username Field
              CustomTextField(
                controller: _usernameController,
                hintText: 'Username',
              ),
              
              const SizedBox(height: 117),
              
              // Password Field
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                isPassword: true,
              ),
              
              const SizedBox(height: 106),
              
              // Login Button
              LoginButton(
                onPressed: _handleLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}