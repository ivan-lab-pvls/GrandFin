import 'package:finance_app/model/Income_item.dart';
import 'package:finance_app/model/expense_item.dart';
import 'package:finance_app/pages/user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddIncomesExpensesPage extends StatefulWidget {
  const AddIncomesExpensesPage(
      {super.key, required this.callBackIncome, required this.callBackExpense});
  final Function(IncomeItem) callBackIncome;
  final Function(ExpenseItem) callBackExpense;

  @override
  State<AddIncomesExpensesPage> createState() => _AddIncomesExpensesPageState();
}

class _AddIncomesExpensesPageState extends State<AddIncomesExpensesPage> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController expenseController = TextEditingController();
  TextEditingController placeDecription = TextEditingController();
  EIncomeType? currentSelectedIncome;
  ECategoryType? currentSelectedExpense;
  DateTime _selectedDate = DateTime.now();
  List<ECategoryType> categoryTypeList = [
    ECategoryType.food,
    ECategoryType.financialOperations,
    ECategoryType.travel,
    ECategoryType.entertainment,
    ECategoryType.other
  ];
  List<EIncomeType> incomeTypeList = [
    EIncomeType.salary,
    EIncomeType.financialOperations,
  ];
  IncomeItem income = IncomeItem();
  ExpenseItem expense = ExpenseItem();
  @override
  void initState() {
    super.initState();
    income.date = DateTime.now();
    expense.date = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 60, 18, 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Operations',
                  style: TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => UserPage(
                                  callBack: () {
                                    setState(() {});
                                  },
                                )),
                      );
                    },
                    child: Image.asset('assets/account.png'))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: 43,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    color: const Color(0xFFdddcf6),
                  ),
                  child: TabBar(
                    padding: const EdgeInsets.all(2),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      color: Colors.white,
                    ),
                    tabs: const [
                      Tab(
                        text: 'Incomes',
                      ),
                      Tab(
                        text: 'Expenses',
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Color(0xFFE8EEF3)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (income.cost != null)
                          Text('+ ${income.cost!.toStringAsFixed(0)} \$',
                              style: const TextStyle(
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6F6CD9),
                                  fontSize: 20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Income amount',
                                style: TextStyle(
                                    fontFamily: 'SF Pro Text',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14)),
                            SizedBox(
                              width: 70,
                              child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: incomeController,
                                  style: const TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                  cursorColor: Colors.black,
                                  onEditingComplete: () {
                                    income.cost =
                                        num.tryParse(incomeController.text)!
                                            .toDouble();
                                    setState(() {});
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none)),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Divider(
                            color: Colors.black.withOpacity(0.2),
                            height: 1,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                      content: Card(
                                        color: Colors.transparent,
                                        elevation: 0.0,
                                        child: Column(children: [
                                          const Text('Enter new category',
                                              style: TextStyle(
                                                  fontFamily: 'SF Pro Text',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14)),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: FormField<EIncomeType>(
                                              builder:
                                                  (FormFieldState<EIncomeType>
                                                      state) {
                                                return InputDecorator(
                                                  decoration: InputDecoration(
                                                      labelStyle:
                                                          const TextStyle(
                                                        fontFamily:
                                                            'SF Pro Text',
                                                      ),
                                                      errorStyle:
                                                          const TextStyle(
                                                              fontFamily:
                                                                  'SF Pro Text',
                                                              color: Colors
                                                                  .redAccent,
                                                              fontSize: 16.0),
                                                      hintText:
                                                          'Please select income',
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      14.0))),
                                                  isEmpty:
                                                      currentSelectedIncome ==
                                                          '',
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton<
                                                        EIncomeType>(
                                                      value:
                                                          currentSelectedIncome,
                                                      isDense: true,
                                                      onChanged: (EIncomeType?
                                                          newValue) {
                                                        setState(() {
                                                          currentSelectedIncome =
                                                              newValue;
                                                          state.didChange(
                                                              newValue);
                                                        });
                                                      },
                                                      items: incomeTypeList.map(
                                                          (EIncomeType value) {
                                                        return DropdownMenuItem<
                                                            EIncomeType>(
                                                          value: value,
                                                          child: Text(
                                                              value.text,
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'SF Pro Text',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      14)),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ]),
                                      ),
                                      actions: [
                                        Card(
                                          color: Colors.transparent,
                                          elevation: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 14),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'SF Pro Text',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14))),
                                                InkWell(
                                                    onTap: () {
                                                      income.type =
                                                          currentSelectedIncome;

                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Save',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'SF Pro Text',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14)))
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Category',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14)),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: currentSelectedIncome != null
                                    ? Text(currentSelectedIncome!.text,
                                        style: const TextStyle(
                                            fontFamily: 'SF Pro Text',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14))
                                    : const Text(''),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 14),
                          child: Divider(
                            color: Colors.black.withOpacity(0.2),
                            height: 1,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Dialog(
                                          child: SizedBox(
                                            width: 300,
                                            height: 200,
                                            child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              initialDateTime: DateTime.now(),
                                              onDateTimeChanged:
                                                  (DateTime newDate) {
                                                _selectedDate = newDate;
                                                income.date = newDate;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Date',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14)),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(
                                    DateFormat("yyyy-MM-dd")
                                        .format(_selectedDate),
                                    style: const TextStyle(
                                        fontFamily: 'SF Pro Text',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 32),
                          child: Divider(
                            color: Colors.black.withOpacity(0.2),
                            height: 1,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (income.cost != null &&
                                    income.type != null) {
                                  widget.callBackIncome(income);

                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                width: 256,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF6F6CD9),
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Text('Make an entry',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'SF Pro Text',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(color: Color(0xFFE8EEF3)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (expense.cost != null)
                          Text('- ${expense.cost!.toStringAsFixed(0)} \$',
                              style: const TextStyle(
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6F6CD9),
                                  fontSize: 20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Expense amount',
                                style: TextStyle(
                                    fontFamily: 'SF Pro Text',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                            SizedBox(
                              width: 70,
                              child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: expenseController,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                  onEditingComplete: () {
                                    expense.cost =
                                        num.tryParse(expenseController.text)!
                                            .toDouble();
                                    setState(() {});
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none)),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.black.withOpacity(0.2),
                          height: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Place',
                                style: TextStyle(
                                    fontFamily: 'SF Pro Text',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                            SizedBox(
                              width: 70,
                              child: TextField(
                                  controller: placeDecription,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                  onEditingComplete: () {
                                    expense.description = placeDecription.text;
                                    setState(() {});
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none)),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Divider(
                            color: Colors.black.withOpacity(0.2),
                            height: 1,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                      content: Card(
                                        color: Colors.transparent,
                                        elevation: 0.0,
                                        child: Column(children: [
                                          const Text('Enter new category',
                                              style: TextStyle(
                                                  fontFamily: 'SF Pro Text',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14)),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: FormField<ECategoryType>(
                                              builder:
                                                  (FormFieldState<ECategoryType>
                                                      state) {
                                                return InputDecorator(
                                                  decoration: InputDecoration(
                                                      labelStyle:
                                                          const TextStyle(
                                                              fontFamily:
                                                                  'SF Pro Text',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14),
                                                      errorStyle:
                                                          const TextStyle(
                                                              fontFamily:
                                                                  'SF Pro Text',
                                                              color: Colors
                                                                  .redAccent,
                                                              fontSize: 16.0),
                                                      hintText:
                                                          'Please select income',
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      14.0))),
                                                  isEmpty:
                                                      currentSelectedExpense ==
                                                          '',
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton<
                                                        ECategoryType>(
                                                      value:
                                                          currentSelectedExpense,
                                                      isDense: true,
                                                      onChanged: (ECategoryType?
                                                          newValue) {
                                                        setState(() {
                                                          currentSelectedExpense =
                                                              newValue;
                                                          state.didChange(
                                                              newValue);
                                                        });
                                                      },
                                                      items: categoryTypeList
                                                          .map((ECategoryType
                                                              value) {
                                                        return DropdownMenuItem<
                                                            ECategoryType>(
                                                          value: value,
                                                          child: Text(
                                                              value.text,
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'SF Pro Text',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      14)),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ]),
                                      ),
                                      actions: [
                                        Card(
                                          color: Colors.transparent,
                                          elevation: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 14),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'SF Pro Text',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14))),
                                                InkWell(
                                                    onTap: () {
                                                      expense.type =
                                                          currentSelectedExpense;

                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Save',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'SF Pro Text',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14)))
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Category',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: currentSelectedExpense != null
                                    ? Text(currentSelectedExpense!.text,
                                        style: const TextStyle(
                                            fontFamily: 'SF Pro Text',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14))
                                    : const Text(''),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 14),
                          child: Divider(
                            color: Colors.black.withOpacity(0.2),
                            height: 1,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Dialog(
                                          child: SizedBox(
                                            width: 300,
                                            height: 200,
                                            child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              initialDateTime: DateTime.now(),
                                              onDateTimeChanged:
                                                  (DateTime newDate) {
                                                _selectedDate = newDate;
                                                expense.date = newDate;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Date',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(
                                    DateFormat("yyyy-MM-dd")
                                        .format(_selectedDate),
                                    style: const TextStyle(
                                        fontFamily: 'SF Pro Text',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 32),
                          child: Divider(
                            color: Colors.black.withOpacity(0.2),
                            height: 1,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (expense.cost != null &&
                                    expense.type != null &&
                                    expense.description != null) {
                                  widget.callBackExpense(expense);

                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                width: 256,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF6F6CD9),
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Text('Make an entry',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'SF Pro Text',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 14)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
