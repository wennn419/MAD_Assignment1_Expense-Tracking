import 'package:flutter/material.dart';

// 1. Category Budget Data Model
class CategoryBudget {
  final String id;
  final String categoryName;
  final IconData icon;
  double monthlyLimit; // Monthly budget limit
  double spentAmount; // Current spent amount

  CategoryBudget({
    required this.id,
    required this.categoryName,
    required this.icon,
    required this.monthlyLimit,
    this.spentAmount = 0.0,
  });

  // Remaining budget
  double get remainingBudget => monthlyLimit - spentAmount;

  // Usage percentage (0.0 to 1.0+)
  double get percentageUsed {
    if (monthlyLimit <= 0) return 0.0;
    return spentAmount / monthlyLimit;
  }

  // Recommended daily limit based on 30 days
  double get recommendedDailyLimit => monthlyLimit / 30.0;
}

void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Color Palette: Warm Eggshell Yellow Theme
    const Color eggshellBackground = Color(0xFFFAF2DA);
    const Color eggshellCard = Color(0xFFFFFDF5);
    const Color eggshellHeader = Color(0xFFF3E5AB);
    const Color primaryText = Color(0xFF4A3E2C);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker - Budgeting',
      theme: ThemeData(
        scaffoldBackgroundColor: eggshellBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: eggshellHeader,
          surface: eggshellBackground,
        ),
        cardTheme: const CardThemeData(
          color: eggshellCard,
          elevation: 2,
        ),
        useMaterial3: true,
      ),
      home: const BudgetScreen(
          primaryText: primaryText, headerColor: eggshellHeader),
    );
  }
}

class BudgetScreen extends StatefulWidget {
  final Color primaryText;
  final Color headerColor;
  const BudgetScreen(
      {super.key, required this.primaryText, required this.headerColor});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  // Budget categories list
  final List<CategoryBudget> _budgets = [
    CategoryBudget(
      id: '1',
      categoryName: 'Food',
      icon: Icons.restaurant,
      monthlyLimit: 300.0,
      spentAmount: 180.0,
    ),
    CategoryBudget(
      id: '2',
      categoryName: 'Subscription',
      icon: Icons.subscriptions,
      monthlyLimit: 50.0,
      spentAmount: 35.0,
    ),
    CategoryBudget(
      id: '3',
      categoryName: 'Transportation',
      icon: Icons.directions_car,
      monthlyLimit: 200.0,
      spentAmount: 150.0,
    ),
    CategoryBudget(
      id: '4',
      categoryName: 'Medication',
      icon: Icons.medical_services,
      monthlyLimit: 150.0,
      spentAmount: 40.0,
    ),
    CategoryBudget(
      id: '5',
      categoryName: 'Shopping',
      icon: Icons.shopping_bag,
      monthlyLimit: 200.0,
      spentAmount: 210.0,
    ),
    CategoryBudget(
      id: '6',
      categoryName: 'Entertainment',
      icon: Icons.movie,
      monthlyLimit: 150.0,
      spentAmount: 135.0,
    ),
    CategoryBudget(
      id: '7',
      categoryName: 'Utilities & Bills',
      icon: Icons.receipt_long,
      monthlyLimit: 250.0,
      spentAmount: 90.0,
    ),
  ];

  // 根据选中的收入等级一键应用建议预算比例
  void _applyBudgetPreset(String tier) {
    // 各种收入等级下的分类建议预算映射 (RM)
    final Map<String, Map<String, double>> presets = {
      'tier1': { // < RM 1000 (Total Limit: RM 800)
        'Food': 300.0,
        'Subscription': 20.0,
        'Transportation': 150.0,
        'Medication': 50.0,
        'Shopping': 80.0,
        'Entertainment': 50.0,
        'Utilities & Bills': 150.0,
      },
      'tier2': { // RM 1000 - RM 2000 (Total Limit: RM 1400)
        'Food': 500.0,
        'Subscription': 50.0,
        'Transportation': 250.0,
        'Medication': 100.0,
        'Shopping': 150.0,
        'Entertainment': 100.0,
        'Utilities & Bills': 250.0,
      },
      'tier3': { // RM 2000+ (Total Limit: RM 2200)
        'Food': 800.0,
        'Subscription': 100.0,
        'Transportation': 400.0,
        'Medication': 150.0,
        'Shopping': 300.0,
        'Entertainment': 200.0,
        'Utilities & Bills': 350.0,
      },
    };

    final selectedPreset = presets[tier];
    if (selectedPreset != null) {
      setState(() {
        for (var item in _budgets) {
          if (selectedPreset.containsKey(item.categoryName)) {
            item.monthlyLimit = selectedPreset[item.categoryName]!;
          }
        }
      });
    }
  }

  // 建议预算弹窗
  void _showSuggestionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFDF5),
        title: const Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Color(0xFFD9BA7A)),
            SizedBox(width: 8),
            Text('Smart Budget Suggestions'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your monthly income level to apply standard recommended budget limits:',
              style: TextStyle(fontSize: 13, color: Color(0xFF6C5B3E)),
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              tileColor: const Color(0xFFFAF2DA),
              title: const Text('Below RM 1,000',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Food: RM300 | Transport: RM150 ...'),
              onTap: () {
                _applyBudgetPreset('tier1');
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Applied budget limits for < RM 1,000 income.')),
                );
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              tileColor: const Color(0xFFFAF2DA),
              title: const Text('RM 1,000 - RM 2,000',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Food: RM500 | Transport: RM250 ...'),
              onTap: () {
                _applyBudgetPreset('tier2');
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Applied budget limits for RM 1,000 - 2,000 income.')),
                );
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              tileColor: const Color(0xFFFAF2DA),
              title: const Text('Above RM 2,000',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Food: RM800 | Transport: RM400 ...'),
              onTap: () {
                _applyBudgetPreset('tier3');
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Applied budget limits for RM 2,000+ income.')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Dialog to add expense
  void _showAddExpenseDialog(CategoryBudget budget) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFDF5),
        title: Text('Add Expense: ${budget.categoryName}'),
        content: TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Expense Amount (RM)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9BA7A),
              foregroundColor: const Color(0xFF3D311D),
            ),
            onPressed: () {
              final double? amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                setState(() {
                  budget.spentAmount += amount;
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Added RM${amount.toStringAsFixed(2)} to ${budget.categoryName}'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Dialog to delete category
  void _deleteCategory(CategoryBudget budget) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFDF5),
        title: const Text('Delete Category'),
        content:
            Text('Are you sure you want to delete "${budget.categoryName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE56B6F),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _budgets.removeWhere((item) => item.id == budget.id);
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${budget.categoryName} removed.')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Reset monthly spent amount
  void _resetMonthlySpent() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFDF5),
        title: const Text('Reset Monthly Budget'),
        content: const Text(
            'Are you sure you want to reset all spent amounts to RM 0.00 for the new month?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE56B6F),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                for (var item in _budgets) {
                  item.spentAmount = 0.0;
                }
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('All monthly spent amounts have been reset!')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  // Determine progress bar color based on usage percentage
  Color _getProgressColor(double percentage) {
    if (percentage >= 1.0) {
      return const Color(0xFFE56B6F); // Over budget: Red
    } else if (percentage >= 0.8) {
      return const Color(0xFFE29578); // Warning: Orange
    }
    return const Color(0xFF81B29A); // Normal: Green
  }

  @override
  Widget build(BuildContext context) {
    // Total calculations
    double totalLimit =
        _budgets.fold(0, (sum, item) => sum + item.monthlyLimit);
    double totalSpent =
        _budgets.fold(0, (sum, item) => sum + item.spentAmount);
    double overallProgress = totalLimit > 0 ? (totalSpent / totalLimit) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Monthly Budget Limits',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: widget.headerColor,
        foregroundColor: widget.primaryText,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            tooltip: 'Suggest Budget',
            onPressed: _showSuggestionDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Month',
            onPressed: _resetMonthlySpent,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5AB),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overall Monthly Budget Summary',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6C5B3E),
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RM ${totalSpent.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: widget.primaryText),
                      ),
                      Text(
                        '/ RM ${totalLimit.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFF7C6C4F)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: overallProgress > 1.0 ? 1.0 : overallProgress,
                      minHeight: 12,
                      backgroundColor: const Color(0xFFFAF2DA),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          _getProgressColor(overallProgress)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(overallProgress * 100).toStringAsFixed(1)}% Used',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF6C5B3E)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Category Budgets (${_budgets.length})',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.primaryText),
            ),
            const SizedBox(height: 12),

            // Category Budget List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _budgets.length,
              itemBuilder: (context, index) {
                final item = _budgets[index];
                final double progress = item.percentageUsed;
                final bool isOverBudget = item.spentAmount > item.monthlyLimit;

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isOverBudget
                          ? const Color(0xFFE56B6F)
                          : const Color(0xFFEFE1B8),
                      width: isOverBudget ? 1.5 : 1.2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon + Name + Actions
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFFF3E5AB),
                              foregroundColor: widget.primaryText,
                              child: Icon(item.icon),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      item.categoryName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: widget.primaryText),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isOverBudget) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE56B6F),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'OVER',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Trash Icon
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Color(0xFFE56B6F)),
                              onPressed: () => _deleteCategory(item),
                              tooltip: 'Delete Category',
                            ),
                            // Add Expense Icon
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Color(0xFFBCA15D)),
                              onPressed: () => _showAddExpenseDialog(item),
                              tooltip: 'Add Expense',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Spent vs Limit
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Spent: RM ${item.spentAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isOverBudget
                                    ? const Color(0xFFE56B6F)
                                    : widget.primaryText,
                              ),
                            ),
                            Text(
                              'Limit: RM ${item.monthlyLimit.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF8C7C5F)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress > 1.0 ? 1.0 : progress,
                            minHeight: 10,
                            backgroundColor: const Color(0xFFFAF2DA),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                _getProgressColor(progress)),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Daily Limit & Remaining Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Suggested daily: RM ${item.recommendedDailyLimit.toStringAsFixed(1)}/day',
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF7C6C4F)),
                            ),
                            Text(
                              isOverBudget
                                  ? 'Exceeded by RM ${(item.spentAmount - item.monthlyLimit).toStringAsFixed(2)}'
                                  : 'Remaining: RM ${item.remainingBudget.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isOverBudget
                                    ? const Color(0xFFE56B6F)
                                    : const Color(0xFF52796F),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}