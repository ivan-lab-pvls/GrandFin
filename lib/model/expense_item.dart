enum ECategoryType {
  food("Food"),
  entertainment("Entertainment"),
  financialOperations("Financial operations"),
  travel("Travel"),
  other("Other");

  const ECategoryType(this.text);
  final String text;
}

class ExpenseItem {
  String? description;
  DateTime? date;
  double? cost;
  ECategoryType? type;

  ExpenseItem({this.description, this.date, this.cost, this.type});

  factory ExpenseItem.fromJson(Map<String, dynamic> parsedJson) {
    return ExpenseItem(
        description: parsedJson['description'] ?? "",
        cost: parsedJson['cost'] ?? "",
        type: ECategoryType.values.byName(parsedJson['type']),
        date: DateTime.tryParse(parsedJson['date']));
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "cost": cost,
      "date": date.toString(),
      "type": type!.name,
    };
  }
}
