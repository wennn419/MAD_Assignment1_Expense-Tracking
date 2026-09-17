import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_expense.dart';
import 'edit_expense.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  // =========================
  // COLORS
  // =========================

  final Color eggshellBackground =
      const Color(0xFFFAF2DA);

  final Color eggshellCard =
      const Color(0xFFFFFDF5);

  final Color eggshellHeader =
      const Color(0xFFF3E5AB);

  final Color primaryButton =
      const Color(0xFFD9BA7A);

  final Color themeYellow =
      const Color(0xFFFFFCC4);

  // =========================
  // EXPENSES
  // =========================

  List<Map<String, dynamic>> expenses = [];
  Map<String, dynamic>? hoveredExpense;

  // =========================
  // INIT
  // =========================

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  // =========================
  // LOAD EXPENSES
  // =========================

  Future<void> loadExpenses() async {
    final prefs =
        await SharedPreferences.getInstance();

    final savedExpenses =
        prefs.getString('expenses');

    if (savedExpenses != null) {
      final List<dynamic> decodedData =
          jsonDecode(savedExpenses);

      setState(() {
        expenses = decodedData
            .map(
              (expense) =>
                  Map<String, dynamic>.from(
                expense,
              ),
            )
            .toList();
      });
    }
  }

  // =========================
  // SAVE EXPENSES
  // =========================

  Future<void> saveExpenses() async {
    final prefs =
        await SharedPreferences.getInstance();

    final data = jsonEncode(expenses);

    await prefs.setString(
      'expenses',
      data,
    );
  }

  // =========================
  // TOTAL
  // =========================

  double get totalExpenses {
    return expenses.fold(
      0.0,
      (sum, expense) =>
          sum +
          (expense['amount'] as num)
              .toDouble(),
    );
  }

  // =========================
  // ADD EXPENSE
  // =========================

  Future<void> addExpense() async {
    final newExpense =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddExpensePage(),
      ),
    );

    if (newExpense != null) {
      setState(() {
        expenses.add(
          Map<String, dynamic>.from(
            newExpense,
          ),
        );
      });

      await saveExpenses();
    }
  }

  // =========================
  // EDIT EXPENSE
  // =========================

  Future<void> editExpense(
    int index,
  ) async {
    final updatedExpense =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditExpensePage(
          expense: expenses[index],
        ),
      ),
    );

    if (updatedExpense != null) {
      setState(() {
        expenses[index] =
            Map<String, dynamic>.from(
          updatedExpense,
        );
      });

      await saveExpenses();
    }
  }

  // =========================
  // DELETE EXPENSE
  // =========================

  Future<void> deleteExpense(
    int index,
  ) async {
    final expense = expenses[index];

    final String category =
        expense['category']?.toString() ?? '';

    final double amount =
        (expense['amount'] as num)
            .toDouble();

    final bool? confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              eggshellCard,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),

          title: const Text(
            'Delete Expense?',
            style: TextStyle(
              color:
                  Color(0xFF3D392F),
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          content: Text(
            'Are you sure you want to delete '
            '$category expense of '
            'RM ${amount.toStringAsFixed(2)}?',

            style: const TextStyle(
              color:
                  Color(0xFF817866),
              fontSize: 14,
            ),
          ),

          actions: [
            // CANCEL
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },

              child: const Text(
                'Cancel',
                style: TextStyle(
                  color:
                      Color(0xFF817866),
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            // DELETE
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryButton,

                foregroundColor:
                    const Color(
                  0xFF3D392F,
                ),

                elevation: 0,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),

              child: const Text(
                'Delete',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        expenses.removeAt(index);
      });

      await saveExpenses();
    }
  }

  // =========================
  // CATEGORY ICON
  // =========================

  IconData getCategoryIcon(
    String category,
  ) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;

      case 'Subscription':
        return Icons.subscriptions;

      case 'Transportation':
        return Icons.directions_bus;

      case 'Medication':
        return Icons.medication;

      case 'Shopping':
        return Icons.shopping_bag;

      case 'Entertainment':
        return Icons.movie;

      case 'Utilities & Bills':
        return Icons.receipt_long;

      default:
        return Icons.category;
    }
  }

  // =========================
  // GET EXPENSE DATE
  // =========================

  DateTime? getExpenseDate(
    Map<String, dynamic> expense,
  ) {
    if (expense['date'] == null) {
      return null;
    }

    return DateTime.tryParse(
      expense['date'].toString(),
    );
  }

  // =========================
  // FORMAT DATE
  // =========================

  String formatExpenseDate(
    DateTime? date,
  ) {
    if (date == null) {
      return 'Date not set';
    }

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} '
        '${date.day}, '
        '${date.year}';
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          eggshellBackground,

      // =========================
      // APP BAR
      // =========================

      appBar: AppBar(
        backgroundColor:
            eggshellHeader,

        elevation: 0,

        title: const Text(
          'Expense Tracking',

          style: TextStyle(
            color:
                Color(0xFF3D392F),
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        centerTitle: false,
      ),

      // =========================
      // BODY
      // =========================

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // =========================
            // TOTAL CARD
            // =========================

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(20),

              decoration:
                  BoxDecoration(
                color:
                    eggshellHeader,

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.08),

                    blurRadius: 8,

                    offset:
                        const Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  const Text(
                    'Total Spent',

                    style:
                        TextStyle(
                      color:
                          Color(0xFF655E50),

                      fontSize: 15,

                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    'RM ${totalExpenses.toStringAsFixed(2)}',

                    style:
                        const TextStyle(
                      color:
                          Color(0xFF3D392F),

                      fontSize: 30,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    '${expenses.length} expense${expenses.length == 1 ? '' : 's'} recorded',

                    style:
                        const TextStyle(
                      color:
                          Color(0xFF756D5C),

                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // =========================
            // EXPENSES TITLE
            // =========================

            const Text(
              'Expenses',

              style: TextStyle(
                color:
                    Color(0xFF3D392F),

                fontSize: 20,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            // =========================
            // EXPENSE LIST
            // =========================

            Expanded(
              child: expenses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [
                          Icon(
                            Icons
                                .receipt_long,

                            size: 60,

                            color: Colors
                                .black
                                .withOpacity(
                              0.25,
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          const Text(
                            'No expenses yet',

                            style:
                                TextStyle(
                              fontSize: 17,

                              fontWeight:
                                  FontWeight
                                      .w600,

                              color:
                                  Color(
                                0xFF655E50,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          const Text(
                            'Tap + to add your first expense',

                            style:
                                TextStyle(
                              fontSize: 13,

                              color:
                                  Color(
                                0xFF817866,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Builder(
                      builder:
                          (context) {
                        // =========================
                        // SORT
                        // =========================

                        final sortedExpenses =
                            List<
                                Map<String,
                                    dynamic>>.from(
                          expenses,
                        );

                        sortedExpenses.sort(
                          (a, b) {
                            final dateA =
                                getExpenseDate(
                              a,
                            );

                            final dateB =
                                getExpenseDate(
                              b,
                            );

                            if (dateA == null &&
                                dateB == null) {
                              return 0;
                            }

                            if (dateA == null) {
                              return 1;
                            }

                            if (dateB == null) {
                              return -1;
                            }

                            return dateB
                                .compareTo(
                              dateA,
                            );
                          },
                        );

                        // =========================
                        // GROUP BY DATE
                        // =========================

                        final Map<
                                String,
                                List<
                                    Map<String,
                                        dynamic>>>
                            groupedExpenses =
                            {};

                        for (final expense
                            in sortedExpenses) {
                          final date =
                              getExpenseDate(
                            expense,
                          );

                          final dateKey =
                              date == null
                                  ? 'Date not set'
                                  : formatExpenseDate(
                                      date,
                                    );

                          groupedExpenses
                              .putIfAbsent(
                                dateKey,
                                () => [],
                              )
                              .add(
                                expense,
                              );
                        }

                        // =========================
                        // LIST
                        // =========================

                        return ListView(
                          children: [
                            for (final entry
                                in groupedExpenses
                                    .entries) ...[
                              // =========================
                              // DATE HEADER
                              // =========================

                              Padding(
                                padding:
                                    const EdgeInsets
                                        .only(
                                  top: 4,
                                  bottom: 8,
                                ),

                                child: Text(
                                  entry.key,

                                  style:
                                      const TextStyle(
                                    color:
                                        Color(
                                      0xFF756D5C,
                                    ),

                                    fontSize:
                                        14,

                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),

                              // =========================
                              // EXPENSES
                              // =========================

                              for (final expense
                                  in entry.value) ...[
                                Builder(
                                  builder:
                                      (context) {
                                    final String
                                        category =
                                        expense[
                                                'category']
                                            ?.toString() ??
                                            '';

                                    final String
                                        description =
                                        expense[
                                                    'description']
                                                ?.toString() ??
                                            '';

                                    final double
                                        amount =
                                        (expense[
                                                    'amount']
                                                as num)
                                            .toDouble();

                                    // IMPORTANT:
                                    // Get original index
                                    // from the main list.
                                    final int
                                        originalIndex =
                                        expenses
                                            .indexOf(
                                      expense,
                                    );

                                    return Container(
                                      margin:
                                          const EdgeInsets
                                              .only(
                                        bottom: 10,
                                      ),

                                      decoration:
                                          BoxDecoration(
                                        color:
                                            eggshellCard,

                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          16,
                                        ),

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors
                                                .black
                                                .withOpacity(
                                              0.06,
                                            ),

                                            blurRadius:
                                                6,

                                            offset:
                                                const Offset(
                                              0,
                                              2,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // =========================
                                      // CLICKABLE CARD
                                      // =========================

                                      child: MouseRegion(
                                      cursor: SystemMouseCursors.click,

                                      onEnter: (_) {
                                        setState(() {
                                          hoveredExpense = expense;
                                        });
                                      },

                                      onExit: (_) {
                                        setState(() {
                                          if (hoveredExpense == expense) {
                                            hoveredExpense = null;
                                          }
                                        });
                                      },

                                      child: GestureDetector(
                                        onTap: () {
                                          if (originalIndex != -1) {
                                            editExpense(originalIndex);
                                          }
                                        },

                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: hoveredExpense == expense
                                                ? const Color(0xFFFFF4B8)
                                                : Colors.transparent,

                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),

                                          child: ListTile(
                                          contentPadding:
                                              const EdgeInsets
                                                  .symmetric(
                                            horizontal:
                                                16,
                                            vertical:
                                                7,
                                          ),

                                          // =========================
                                          // ICON
                                          // =========================

                                          leading:
                                              CircleAvatar(
                                            radius:
                                                23,

                                            backgroundColor:
                                                themeYellow,

                                            child:
                                                Icon(
                                              getCategoryIcon(
                                                category,
                                              ),

                                              color:
                                                  const Color(
                                                0xFF5A513F,
                                              ),
                                            ),
                                          ),

                                          // =========================
                                          // CATEGORY
                                          // =========================

                                          title:
                                              Text(
                                            category,

                                            style:
                                                const TextStyle(
                                              color:
                                                  Color(
                                                0xFF3D392F,
                                              ),

                                              fontSize:
                                                  16,

                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),

                                          // =========================
                                          // DESCRIPTION
                                          // =========================

                                          subtitle:
                                              description
                                                      .isEmpty
                                                  ? null
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .only(
                                                        top:
                                                            4,
                                                      ),

                                                      child:
                                                          Text(
                                                        description,

                                                        style:
                                                            const TextStyle(
                                                          color:
                                                              Color(
                                                            0xFF817866,
                                                          ),

                                                          fontSize:
                                                              13,
                                                        ),
                                                      ),
                                                    ),

                                          // =========================
                                          // AMOUNT + DELETE
                                          // =========================

                                          trailing:
                                              Row(
                                            mainAxisSize:
                                                MainAxisSize
                                                    .min,

                                            children: [
                                              Text(
                                                'RM ${amount.toStringAsFixed(2)}',

                                                style:
                                                    const TextStyle(
                                                  color:
                                                      Color(
                                                    0xFF3D392F,
                                                  ),

                                                  fontSize:
                                                      15,

                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                ),
                                              ),

                                              // DELETE BUTTON
                                              IconButton(
                                                icon:
                                                    const Icon(
                                                  Icons
                                                      .delete_outline,

                                                  size:
                                                      21,
                                                ),

                                                color:
                                                    const Color(
                                                  0xFF817866,
                                                ),

                                                // Prevent the
                                                // card onTap
                                                // from being used
                                                // for delete.
                                                onPressed:
                                                    () {
                                                  if (originalIndex !=
                                                      -1) {
                                                    deleteExpense(
                                                      originalIndex,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          ),
                                        ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],

                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // =========================
      // ADD BUTTON
      // =========================

      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            primaryButton,

        elevation: 3,

        onPressed:
            addExpense,

        child: const Icon(
          Icons.add,

          color:
              Color(0xFF3D392F),

          size: 28,
        ),
      ),
    );
  }
}