import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Statistics',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF2DA),
        cardColor: const Color(0xFFFFFDF5),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFF3E5AB),
        ),
        useMaterial3: true,
      ),
      home: const ExpenseStatsPage(),
    );
  }
}

// Data model for category spending
class ExpenseCategory {
  final String name;
  final double amount;
  final Color color;

  ExpenseCategory({
    required this.name,
    required this.amount,
    required this.color,
  });
}

class ExpenseStatsPage extends StatefulWidget {
  const ExpenseStatsPage({super.key});

  @override
  State<ExpenseStatsPage> createState() => _ExpenseStatsPageState();
}

class _ExpenseStatsPageState extends State<ExpenseStatsPage> {
  // Sample data for the month
  final List<ExpenseCategory> _categories = [
    ExpenseCategory(name: 'Food & Dining', amount: 650.00, color: Colors.orangeAccent),
    ExpenseCategory(name: 'Groceries', amount: 420.50, color: Colors.green),
    ExpenseCategory(name: 'Utilities', amount: 250.00, color: Colors.blueAccent),
    ExpenseCategory(name: 'Entertainment', amount: 180.00, color: Colors.purpleAccent),
    ExpenseCategory(name: 'Transport', amount: 300.00, color: Colors.redAccent),
  ];

  // Helper to calculate total spent in a month
  double get _totalSpent {
    return _categories.fold(0.0, (sum, item) => sum + item.amount);
  }

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Expenses'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Spending Breakdown',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'September 2026',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Pie Chart with Total Amount in the Center
            SizedBox(
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(double.infinity, 280),
                    painter: ExpensePieChartPainter(
                      categories: _categories,
                      touchedIndex: touchedIndex,
                    ),
                  ),
                  // Center Content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total Spent',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'RM${_totalSpent.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Legend / Category Details List
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final percentage = (_totalSpent > 0) 
                            ? (category.amount / _totalSpent) * 100 
                            : 0.0;

                        return Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: category.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                category.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'RM${category.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${percentage.toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class ExpensePieChartPainter extends CustomPainter {
  final List<ExpenseCategory> categories;
  final int touchedIndex;

  ExpensePieChartPainter({required this.categories, required this.touchedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final total = categories.fold<double>(0, (sum, item) => sum + item.amount);
    if (total <= 0) return;

    final center = size.center(Offset.zero);
    final baseRadius = math.min(size.width, size.height) / 2 - 8;
    var startAngle = -math.pi / 2;

    for (var i = 0; i < categories.length; i++) {
      final category = categories[i];
      final sweepAngle = category.amount / total * 2 * math.pi;
      final radius = i == touchedIndex ? baseRadius + 10 : baseRadius;
      final paint = Paint()..color = category.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      final labelAngle = startAngle + sweepAngle / 2;
      final labelPosition = center + Offset(
        math.cos(labelAngle) * radius * .65,
        math.sin(labelAngle) * radius * .65,
      );
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${(category.amount / total * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            color: Colors.white,
            fontSize: i == touchedIndex ? 18 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, labelPosition - Offset(textPainter.width / 2, textPainter.height / 2));
      startAngle += sweepAngle;
    }

    canvas.drawCircle(center, baseRadius * .48, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant ExpensePieChartPainter oldDelegate) =>
      oldDelegate.categories != categories || oldDelegate.touchedIndex != touchedIndex;
}