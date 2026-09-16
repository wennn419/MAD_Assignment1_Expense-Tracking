import 'package:flutter/material.dart';
import 'ai_budget_chat_screen.dart';
import 'auth_screen.dart';

class ProfileHomeScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final List goals;

  const ProfileHomeScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFDCC48C),
                        child: Text(userName.isNotEmpty ? userName[0] : 'S', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C2518))),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good afternoon, $userName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2C2518))),
                          const Text('Sunway University • Computer Science', style: TextStyle(fontSize: 11, color: Color(0xFF8C826A))),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color(0xFFF3EAD3), shape: BoxShape.circle),
                        child: const Icon(Icons.notifications_none, size: 18, color: Color(0xFF5C5238)),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.logout, size: 18, color: Colors.redAccent),
                        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen(goals: goals))),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Total Available Balance Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF4ECC9), Color(0xFFE8D7A2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TOTAL AVAILABLE BALANCE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6B5F3E))),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), shape: BoxShape.circle),
                          child: const Icon(Icons.account_balance_wallet, size: 16, color: Color(0xFF5C5238)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('RM 3,420.50', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF2C2518))),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_downward, size: 14, color: Color(0xFF3B7A57)),
                          SizedBox(width: 4),
                          Text('+RM 1,200.00 This Month Inflow', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3B7A57))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // AI Advisor Quick Banner
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AIBudgetChatScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF3EAD3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color(0xFFF3EAD3), shape: BoxShape.circle),
                        child: const Icon(Icons.auto_awesome, size: 18, color: Color(0xFF5C5238)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AI Advisor: Noticed +RM 450 inflow today!', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2C2518))),
                            SizedBox(height: 2),
                            Text('Tap to auto-allocate 30% to your New Laptop goal.', style: TextStyle(fontSize: 11, color: Color(0xFF8C826A))),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF5C5238)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Incoming Streams Section
              const Text('Incoming Streams', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C2518))),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    _buildStreamItem('Freelance Design gig', 'Figma App UI • Just now', '+RM 450.00', Icons.brush_outlined),
                    const Divider(height: 24, color: Color(0xFFFBF8F2)),
                    _buildStreamItem('Monthly PTPTN / Allowance', 'Gov Loan • 1 Nov', '+RM 600.00', Icons.school_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Campus Health Score Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.emoji_emotions_outlined, color: Color(0xFF3B7A57), size: 20),
                            SizedBox(width: 8),
                            Text('Campus Health Score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2C2518))),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFD9EAD3), borderRadius: BorderRadius.circular(10)),
                          child: const Text('Healthy Saver', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF3B7A57))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(color: Color(0xFFF3EAD3), shape: BoxShape.circle),
                          child: const Text('86/100', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF5C5238))),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text('Top 12% in Sunway. You cooked at your apartment 4 times this week keeping food expenses low!', style: TextStyle(fontSize: 12, color: Color(0xFF8C826A))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreamItem(String title, String subtitle, String amount, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Color(0xFFF3EAD3), shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: Color(0xFF5C5238)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C2518))),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF8C826A))),
              ],
            ),
          ],
        ),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF3B7A57))),
      ],
    );
  }
}