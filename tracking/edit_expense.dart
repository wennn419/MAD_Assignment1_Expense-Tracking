import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditExpensePage extends StatefulWidget {
  final Map<String, dynamic> expense;

  const EditExpensePage({
    super.key,
    required this.expense,
  });

  @override
  State<EditExpensePage> createState() =>
      _EditExpensePageState();
}

class _EditExpensePageState
    extends State<EditExpensePage> {

  // =========================
  // CONTROLLERS
  // =========================

  final TextEditingController amountController =
      TextEditingController();

  final TextEditingController descriptionController =
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
  // CATEGORIES
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

  List<String> customCategories = [];

  // =========================
  // SELECTED VALUES
  // =========================

  String? selectedCategory;
  String? selectedPaymentMethod;

  DateTime selectedDate = DateTime.now();

  // =========================
  // HOVER
  // =========================

  String? hoveredCategory;
  String? hoveredPaymentMethod;
  bool hoveredDate = false;

  // =========================
  // INIT
  // =========================

  @override
  void initState() {
    super.initState();

    amountController.text =
        widget.expense['amount'].toString();

    descriptionController.text =
        widget.expense['description']?.toString() ?? '';

    selectedCategory =
        widget.expense['category']?.toString();

    selectedPaymentMethod =
        widget.expense['paymentMethod']?.toString();

    final savedDate =
        widget.expense['date']?.toString();

    if (savedDate != null) {
      final parsedDate =
          DateTime.tryParse(savedDate);

      if (parsedDate != null) {
        selectedDate = parsedDate;
      }
    }

    loadCategories();
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // =========================
  // LOAD CUSTOM CATEGORIES
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
  // MONTH
  // =========================

  String shortMonthName(int month) {
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
  // DATE
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
  // CATEGORY ITEM
  // =========================

  Widget categoryItem(
    String category,
  ) {
    final bool isSelected =
        selectedCategory == category;

    final bool isHover =
        hoveredCategory == category;

    return MouseRegion(
      cursor:
          SystemMouseCursors.click,

      onEnter: (_) {
        setState(() {
          hoveredCategory = category;
        });
      },

      onExit: (_) {
        setState(() {
          if (hoveredCategory == category) {
            hoveredCategory = null;
          }
        });
      },

      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = category;
          });
        },

        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 8,
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
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Icon(
                getCategoryIcon(category),
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
      cursor:
          SystemMouseCursors.click,

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
          padding:
              const EdgeInsets.symmetric(
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
            mainAxisSize:
                MainAxisSize.min,

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
  // SAVE CHANGES
  // =========================

  void saveChanges() {
    final double? amount =
        double.tryParse(
      amountController.text.trim(),
    );

    final String description =
        descriptionController.text.trim();

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid amount.',
          ),
        ),
      );

      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a category.',
          ),
        ),
      );

      return;
    }

    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a payment method.',
          ),
        ),
      );

      return;
    }

    final Map<String, dynamic> updatedExpense = {
      'category': selectedCategory!,
      'amount': amount,
      'description': description,
      'date': selectedDate.toIso8601String(),
      'paymentMethod': selectedPaymentMethod!,
    };

    Navigator.pop(
      context,
      updatedExpense,
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: headerColor,
        elevation: 0,

        title: Text(
          'Edit Expense',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: IconThemeData(
          color: textColor,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // =========================
            // AMOUNT + DESCRIPTION
            // =========================

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // AMOUNT

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [
                          Text(
                            'Amount',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          MouseRegion(
                            cursor:
                                SystemMouseCursors
                                    .click,

                            onEnter: (_) {
                              setState(() {
                                hoveredDate = true;
                              });
                            },

                            onExit: (_) {
                              setState(() {
                                hoveredDate = false;
                              });
                            },

                            child: GestureDetector(
                              onTap: selectDate,

                              child: Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: hoveredDate
                                      ? const Color(
                                          0xFFFFF4B8,
                                        )
                                      : Colors.transparent,

                                  borderRadius:
                                      BorderRadius
                                          .circular(8),
                                ),

                                child: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,

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
                                      '${shortMonthName(selectedDate.month)} '
                                      '${selectedDate.year}',

                                      style:
                                          const TextStyle(
                                        color:
                                            Color(
                                          0xFF3D392F,
                                        ),
                                        fontSize: 13,
                                        fontWeight:
                                            FontWeight.w600,
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
                                const EdgeInsets.all(
                              16,
                            ),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(14),

                              borderSide:
                                  BorderSide.none,
                            ),

                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(14),

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

                const SizedBox(
                  width: 16,
                ),

                // DESCRIPTION

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
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      SizedBox(
                        height: 72,

                        child: TextField(
                          controller:
                              descriptionController,

                          maxLines: 1,

                          decoration:
                              InputDecoration(
                            hintText:
                                'Enter description (optional)',

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
                                  BorderRadius
                                      .circular(14),

                              borderSide:
                                  BorderSide.none,
                            ),

                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(14),

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
              ],
            ),

            const SizedBox(
              height: 24,
            ),

            // =========================
            // CATEGORY
            // =========================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  'Category',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 16,
            ),

            Wrap(
              spacing: 8,
              runSpacing: 8,

              children: [
                ...defaultCategories.map(
                  (category) =>
                      categoryItem(category),
                ),

                ...customCategories.map(
                  (category) =>
                      categoryItem(category),
                ),
              ],
            ),

            const SizedBox(
              height: 24,
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
                paymentMethodItem(
                  'Cash',
                  Icons.payments_outlined,
                ),

                paymentMethodItem(
                  'Card',
                  Icons.credit_card_outlined,
                ),

                paymentMethodItem(
                  'E-Wallet',
                  Icons.account_balance_wallet_outlined,
                ),

                paymentMethodItem(
                  'Bank Transfer',
                  Icons.account_balance_outlined,
                ),
              ],
            ),

            const SizedBox(
              height: 24,
            ),

            // =========================
            // SAVE CHANGES
            // =========================

            Center(
              child: SizedBox(
                width: 180,
                height: 48,

                child: ElevatedButton(
                  onPressed: saveChanges,

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
                          BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}