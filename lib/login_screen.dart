import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final String defaultUsername = 'testuser';
  final String defaultEmail = 'testuser@test.com';
  final String defaultPassword = 'password123';

  bool validateForm() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return false;
    }
    if (email.contains('@') && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return false;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return false;
    }
    return true;
  }

  Future<void> authenticateUser() async {
    final prefs = await SharedPreferences.getInstance();
    final enteredEmail = emailController.text.trim().toLowerCase();
    final enteredPassword = passwordController.text.trim();

    final storedEmail = (prefs.getString('email') ?? '').trim().toLowerCase();
    final storedUsername = (prefs.getString('username') ?? '').trim().toLowerCase();
    final storedPassword = (prefs.getString('password') ?? '').trim();

    final isStoredUser = storedPassword.isNotEmpty &&
        (enteredEmail == storedEmail || enteredEmail == storedUsername) &&
        enteredPassword == storedPassword;

    // FIXED: Accept both username AND email for default user
    final isDefaultUser = (enteredEmail == defaultUsername ||
            enteredEmail == defaultEmail) &&
        enteredPassword == defaultPassword;

    if (isStoredUser || isDefaultUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
      // TODO: Navigate to home / habit screen when ready
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  void handleLogin() {
    if (validateForm()) {
      authenticateUser();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Habit Tracker',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.blue.shade700),
                      hintText: 'Enter Username or Email',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
                      hintText: 'Enter Password',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot password?', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  ),
                  child: const Text('Log in', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                const Text('or', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                  ),
                  child: const Text('Sign up', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                  },
                  child: const Text("Don't have an account? Sign Up", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}