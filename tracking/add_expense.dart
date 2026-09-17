import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  // =========================
  // CONTROLLERS
  // =========================

  final TextEditingController amountController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  final TextEditingController newCategoryController =
      TextEditingController();

  // =========================
  // COLORS
  // =========================

  final Color backgroundColor =
      const Color(0xFFFAF2DA);

  final Color cardColor =
      const Color(0xFFFFFDF5);

  final Color headerColor =
      const Color(0xFFF3E5AB);

  final Color primaryColor =
      const Color(0xFFFFFCC4);

  final Color buttonColor =
      const Color(0xFFD9BA7A);

  final Color textColor =
      const Color(0xFF3D392F);

  final Color secondaryTextColor =
      const Color(0xFF817866);

  // =========================
  // DEFAULT CATEGORIES
  // =========================

  final List<String> defaultCategories = [
    'Food',
    'Subscription',
    'Transportation',
    'Medication',
    'Shopping',
    'Entertainment',
    'Utilities & Bills',
  ];

  // =========================
  // CUSTOM CATEGORIES
  // =========================

  List<String> customCategories = [];

  // =========================
  // SELECTED CATEGORY
  // =========================

  String? selectedCategory;
  String? selectedPaymentMethod;

  // =========================
  // SELECTED DATE
  // =========================

  DateTime selectedDate = DateTime.now();

  // =========================
  // MANAGE MODE
  // =========================

  bool manageMode = false;

  // =========================
  // HOVER
  // =========================

  String? hoveredCategory;
  bool hoveredAddCategory = false;
  bool hoveredDate = false;
  String? hoveredPaymentMethod;

  // =========================
  // INIT
  // =========================

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    newCategoryController.dispose();
    super.dispose();
  }

  // =========================
  // LOAD CATEGORIES
  // =========================

  Future<void> loadCategories() async {
    final prefs =
        await SharedPreferences.getInstance();

    final savedCategories =
        prefs.getStringList(
      'custom_categories',
    );

    if (savedCategories != null) {
      setState(() {
        customCategories = savedCategories;
      });
    }
  }

  // =========================
  // SAVE CATEGORIES
  // =========================

  Future<void> saveCategories() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setStringList(
      'custom_categories',
      customCategories,
    );
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
  // MONTH NAME
  // =========================

  String _shortMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  // =========================
  // SELECT DATE
  // =========================

  Future<void> selectDate() async {
    final DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // =========================
  // ADD CUSTOM CATEGORY
  // =========================

  Future<void> addCategory() async {
    newCategoryController.clear();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),

          title: Text(
            'Add Category',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: TextField(
            controller:
                newCategoryController,

            decoration:
                InputDecoration(
              hintText:
                  'Category name',

              filled: true,
              fillColor:
                  backgroundColor,

              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
                borderSide:
                    BorderSide.none,
              ),

              focusedBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),

                borderSide:
                    BorderSide(
                  color: buttonColor,
                  width: 1.5,
                ),
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },

              child: Text(
                'Cancel',
                style: TextStyle(
                  color:
                      secondaryTextColor,
                ),
              ),
            ),

            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    buttonColor,

                foregroundColor:
                    textColor,

                elevation: 0,
              ),

              onPressed: () async {
                final category =
                    newCategoryController
                        .text
                        .trim();

                if (category.isEmpty) {
                  return;
                }

                final allCategories = [
                  ...defaultCategories,
                  ...customCategories,
                ];

                // Prevent duplicate category
                if (allCategories.any(
                  (item) =>
                      item.toLowerCase() ==
                      category.toLowerCase(),
                )) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'This category already exists.',
                      ),
                    ),
                  );

                  return;
                }

                setState(() {
                  customCategories.add(
                    category,
                  );

                  selectedCategory =
                      category;
                });

                await saveCategories();

                if (dialogContext.mounted) {
                  Navigator.pop(
                    dialogContext,
                  );
                }
              },

              child: const Text(
                'Add',
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
  }

  // =========================
  // DELETE CUSTOM CATEGORY
  // =========================

  Future<void> deleteCategory(
    String category,
  ) async {
    final bool? confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),

          title: Text(
            'Delete Category?',
            style: TextStyle(
              color: textColor,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          content: Text(
            'Delete "$category" from your categories?',

            style: TextStyle(
              color:
                  secondaryTextColor,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },

              child: Text(
                'Cancel',
                style: TextStyle(
                  color:
                      secondaryTextColor,
                ),
              ),
            ),

            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    buttonColor,

                foregroundColor:
                    textColor,

                elevation: 0,
              ),

              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },

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
        customCategories.remove(
          category,
        );

        if (selectedCategory ==
            category) {
          selectedCategory = null;
        }
      });

      await saveCategories();
    }
  }

  // =========================
  // SAVE EXPENSE
  // =========================

  void saveExpense() {
    final double? amount =
        double.tryParse(
      amountController.text.trim(),
    );

    final String description =
        descriptionController.text.trim();

    // Amount required
    if (amount == null ||
        amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid amount.',
          ),
        ),
      );

      return;
    }

    // Category required
    if (selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a category.',
          ),
        ),
      );

      return;
    }

    // Payment method required
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a payment method.',
          ),
        ),
      );

      return;
    }

    final Map<String, dynamic> expense = {
    'category': selectedCategory!,
    'amount': amount,
    'description': description,
    'date': selectedDate.toIso8601String(),
    'paymentMethod': selectedPaymentMethod!,
    };

    Navigator.pop(
      context,
      expense,
    );
  }

  // =========================
  // CATEGORY ITEM
  // =========================

  Widget categoryItem(
    String category, {
    required bool isCustom,
  }) {
    final bool isSelected =
        selectedCategory == category;

    final bool isHover =
        hoveredCategory == category;

    return MouseRegion(
      cursor:
          SystemMouseCursors.click,

      onEnter: (_) {
        setState(() {
          hoveredCategory =
              category;
        });
      },

      onExit: (_) {
        setState(() {
          if (hoveredCategory ==
              category) {
            hoveredCategory = null;
          }
        });
      },

      child: GestureDetector(
        onTap: () {
          if (manageMode &&
              isCustom) {
            deleteCategory(category);
            return;
          }

          if (!manageMode) {
            setState(() {
              selectedCategory =
                  category;
            });
          }
        },

        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 8,
          ),

          decoration:
              BoxDecoration(
            color: isHover
                ? const Color(
                    0xFFFFF4B8,
                  )
                : isSelected
                    ? primaryColor
                    : cardColor,

            borderRadius:
                BorderRadius.circular(
              30,
            ),

            border: Border.all(
              color:
                  isHover || isSelected
                      ? buttonColor
                      : const Color(
                          0xFFE5DCC8,
                        ),

              width: 1,
            ),
          ),

          child: Row(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Icon(
                getCategoryIcon(
                  category,
                ),
                size: 16,
                color: textColor,
              ),

              const SizedBox(
                width: 5,
              ),

              Text(
                category,

                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              if (manageMode &&
                  isCustom) ...[
                const SizedBox(
                  width: 4,
                ),

                Icon(
                  Icons.close,
                  size: 13,
                  color: textColor,
                ),
              ],

              if (manageMode &&
                  !isCustom) ...[
                const SizedBox(
                  width: 4,
                ),

                Icon(
                  Icons.lock_outline,
                  size: 11,
                  color:
                      secondaryTextColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // ADD CATEGORY BUTTON
  // =========================

  Widget addCategoryButton() {
    return MouseRegion(
      cursor: manageMode
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,

      onEnter: (_) {
        if (!manageMode) {
          setState(() {
            hoveredAddCategory =
                true;
          });
        }
      },

      onExit: (_) {
        setState(() {
          hoveredAddCategory =
              false;
        });
      },

      child: GestureDetector(
        onTap:
            manageMode ? null : addCategory,

        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 8,
          ),

          decoration:
              BoxDecoration(
            color:
                hoveredAddCategory &&
                        !manageMode
                    ? const Color(
                        0xFFFFF4B8,
                      )
                    : backgroundColor,

            borderRadius:
                BorderRadius.circular(
              30,
            ),

            border: Border.all(
              color: buttonColor,
              width: 1.3,
            ),
          ),

          child: Row(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Icon(
                Icons.add_circle_outline,
                size: 16,
                color: textColor,
              ),

              const SizedBox(
                width: 5,
              ),

              Text(
                'Add Category',

                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // PAYMENT METHOD ITEM
  // =========================

  Widget paymentMethodItem(
    String method,
    IconData icon,
  ) {
    final bool isSelected =
        selectedPaymentMethod == method;

    final bool isHover =
        hoveredPaymentMethod == method;

    return MouseRegion(
      cursor: SystemMouseCursors.click,

      onEnter: (_) {
        setState(() {
          hoveredPaymentMethod = method;
        });
      },

      onExit: (_) {
        setState(() {
          if (hoveredPaymentMethod == method) {
            hoveredPaymentMethod = null;
          }
        });
      },

      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPaymentMethod = method;
          });
        },

        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 9,
          ),

          decoration: BoxDecoration(
            color: isHover
                ? const Color(0xFFFFF4B8)
                : isSelected
                    ? primaryColor
                    : cardColor,

            borderRadius:
                BorderRadius.circular(30),

            border: Border.all(
              color: isHover || isSelected
                  ? buttonColor
                  : const Color(0xFFE5DCC8),

              width: 1,
            ),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(
                icon,
                size: 16,
                color: textColor,
              ),

              const SizedBox(
                width: 5,
              ),

              Text(
                method,

                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          backgroundColor,

      // =========================
      // APP BAR
      // =========================

      appBar: AppBar(
        backgroundColor:
            headerColor,

        elevation: 0,

        title: Text(
          'Add Expense',

          style: TextStyle(
            color: textColor,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        centerTitle: false,

        iconTheme:
            IconThemeData(
          color: textColor,
        ),
      ),

      // =========================
      // BODY
      // =========================

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // =========================
            // AMOUNT + DESCRIPTION
            // =========================

            Row(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment:
      CrossAxisAlignment.start,
              children: [
                // =========================
                // AMOUNT
                // =========================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      // Amount title + Date
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .center,

                        children: [
                          const Text(
                            'Amount',

                            style:
                                TextStyle(
                              color:
                                  Color(
                                0xFF3D392F,
                              ),
                              fontSize: 17,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          // =========================
                          // DATE
                          // =========================

                          MouseRegion(
                            cursor:
                                SystemMouseCursors
                                    .click,

                            onEnter: (_) {
                              setState(() {
                                hoveredDate =
                                    true;
                              });
                            },

                            onExit: (_) {
                              setState(() {
                                hoveredDate =
                                    false;
                              });
                            },

                            child:
                                GestureDetector(
                              onTap:
                                  selectDate,

                              child:
                                  Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      8,
                                  vertical:
                                      5,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      hoveredDate
                                          ? const Color(
                                              0xFFFFF4B8,
                                            )
                                          : Colors
                                              .transparent,

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    8,
                                  ),
                                ),

                                child:
                                    Row(
                                  mainAxisSize:
                                      MainAxisSize
                                          .min,

                                  children: [
                                    const Icon(
                                      Icons
                                          .calendar_today_outlined,

                                      size: 16,

                                      color:
                                          Color(
                                        0xFF3D392F,
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 6,
                                    ),

                                    Text(
                                      '${selectedDate.day} '
                                      '${_shortMonthName(selectedDate.month)} '
                                      '${selectedDate.year}',

                                      style:
                                          const TextStyle(
                                        color:
                                            Color(
                                          0xFF3D392F,
                                        ),
                                        fontSize:
                                            13,
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      // Amount box
                      SizedBox(
                        height: 72,

                        child: TextField(
                          controller:
                              amountController,

                          keyboardType:
                              const TextInputType
                                  .numberWithOptions(
                            decimal: true,
                          ),

                          decoration:
                              InputDecoration(
                            hintText:
                                'Enter amount',

                            prefixText:
                                'RM ',

                            filled: true,

                            fillColor:
                                cardColor,

                            contentPadding:
                                const EdgeInsets
                                    .all(
                              16,
                            ),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),

                              borderSide:
                                  BorderSide
                                      .none,
                            ),

                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),

                              borderSide:
                                  BorderSide(
                                color:
                                    buttonColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 16,
                ),

                // =========================
// DESCRIPTION
// =========================

Expanded(
  child: Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,
    children: [
      Text(
        'Description',
        style: TextStyle(
          color: textColor,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(
        height: 8,
      ),

      // Description box
      SizedBox(
        height: 72,
        child: TextField(
          controller:
              descriptionController,

          maxLines: 1,

          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),

          decoration:
              InputDecoration(
            hintText:
                'Enter description (optional)',

            hintStyle: TextStyle(
              color:
                  secondaryTextColor,
              fontSize: 16,
            ),

            filled: true,

            fillColor:
                cardColor,

            contentPadding:
                const EdgeInsets.all(
              16,
            ),

            border:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),

              borderSide:
                  BorderSide.none,
            ),

            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),

              borderSide:
                  BorderSide(
                color: buttonColor,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),

// =========================
// CLOSE AMOUNT + DESCRIPTION ROW
// =========================

],
),

const SizedBox(
  height: 10,
),

            // =========================
// CATEGORY TITLE + MANAGE
// =========================

Row(
  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

  crossAxisAlignment:
      CrossAxisAlignment.center,

  children: [
    Text(
      'Category',

      style: TextStyle(
        color: textColor,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ),

    TextButton(
      onPressed: () {
        setState(() {
          manageMode = !manageMode;

          hoveredCategory = null;
          hoveredAddCategory = false;
        });
      },

      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),

        minimumSize: Size.zero,

        tapTargetSize:
            MaterialTapTargetSize.shrinkWrap,
      ),

      child: Text(
        manageMode
            ? 'Done'
            : 'Manage',

        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ],
),
            // =========================
            // MANAGE MESSAGE
            // =========================

            if (manageMode)
              Padding(
                padding:
                    const EdgeInsets.only(
                  top: 4,
                  bottom: 12,
                ),

                child: Text(
                  'Tap a custom category to delete it.',

                  style: TextStyle(
                    color:
                        secondaryTextColor,
                    fontSize: 13,
                  ),
                ),
              ),

            const SizedBox(
              height: 16,
            ),

            // =========================
            // CATEGORY LIST
            // =========================

            Wrap(
              spacing: 8,
              runSpacing: 8,

              children: [
                // Default categories
                ...defaultCategories.map(
                  (category) =>
                      categoryItem(
                    category,
                    isCustom: false,
                  ),
                ),

                // Custom categories
                ...customCategories.map(
                  (category) =>
                      categoryItem(
                    category,
                    isCustom: true,
                  ),
                ),

                // Add category
                addCategoryButton(),
              ],
            ),

            const SizedBox(
              height: 32,
            ),

            // =========================
            // PAYMENT METHOD
            // =========================

            Text(
              'Payment Method',
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                paymentMethodItem('Cash', Icons.payments_outlined),
                paymentMethodItem('Card', Icons.credit_card_outlined),
                paymentMethodItem('E-Wallet', Icons.account_balance_wallet_outlined),
                paymentMethodItem('Bank Transfer', Icons.account_balance_outlined),
              ],
            ),

            // =========================
            // SAVE BUTTON
            // =========================

            Center(
              child: SizedBox(
                width: 180,
                height: 48,

                child: ElevatedButton(
                  onPressed: saveExpense,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        buttonColor,

                    foregroundColor:
                        textColor,

                    elevation: 2,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),
                    ),
                  ),

                  child: const Text(
                    'Save Expense',

                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

                const SizedBox(
                height: 10,
                ),
             ],
            ),
          
        ),
    );
    
  }
}