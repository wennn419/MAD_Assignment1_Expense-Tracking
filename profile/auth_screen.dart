import 'package:flutter/material.dart';
import 'profile_home_screen.dart';

class AuthScreen extends StatefulWidget {
  final List goals;
  const AuthScreen({super.key, required this.goals});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Color(0xFFE8D7A2), shape: BoxShape.circle),
                child: const Icon(Icons.account_balance_wallet, size: 36, color: Color(0xFF5C5238)),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF3EAD3), borderRadius: BorderRadius.circular(20)),
                child: const Text('Campus-Verified Finance', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF5C5238))),
              ),
              const SizedBox(height: 8),
              const Text('KayaWallet', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2C2518))),
              const SizedBox(height: 4),
              const Text('Smart budgeting, mindful savings & AI insights\ndesigned for university life.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF8C826A))),
              const SizedBox(height: 24),
              
              // Toggle tabs (Sign In / Sign Up)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: const Color(0xFFF3EAD3), borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isLogin = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isLogin ? const Color(0xFFDCC48C) : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, color: _isLogin ? const Color(0xFF2C2518) : const Color(0xFF8C826A))),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isLogin = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isLogin ? const Color(0xFFDCC48C) : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, color: !_isLogin ? const Color(0xFF2C2518) : const Color(0xFF8C826A))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isLogin) ...[
                      const Text('Full Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5C5238))),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'e.g. Sarah Tan',
                          filled: true,
                          fillColor: const Color(0xFFFBF8F2),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    const Text('Student ID or Campus Email', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5C5238))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'sarah.tan@student.edu.my',
                        filled: true,
                        fillColor: const Color(0xFFFBF8F2),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Password', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5C5238))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        filled: true,
                        fillColor: const Color(0xFFFBF8F2),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          String name = _isLogin ? 'Sarah Tan' : (_nameController.text.isNotEmpty ? _nameController.text : 'New User');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileHomeScreen(
                                userName: name,
                                userEmail: _emailController.text.isNotEmpty ? _emailController.text : 'sarah.tan@student.edu.my',
                                goals: widget.goals,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDCC48C),
                          foregroundColor: const Color(0xFF2C2518),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: Text(_isLogin ? 'Sign In to Your Wallet →' : 'Create Student Wallet →', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('OR STUDENT SINGLE SIGN-ON', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8C826A))),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.school, size: 18, color: Color(0xFF5C5238)),
                label: const Text('Login with Campus ID Portal', style: TextStyle(color: Color(0xFF2C2518), fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  side: const BorderSide(color: Color(0xFFF3EAD3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}