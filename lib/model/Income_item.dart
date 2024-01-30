enum EIncomeType {
  salary("Salary"),
  financialOperations("Financial operations");

  const EIncomeType(this.text);
  final String text;
}

class IncomeItem {
  String? description;
  DateTime? date;
  EIncomeType? type;
  double? cost;

  IncomeItem({this.description, this.date, this.cost, this.type});

  factory IncomeItem.fromJson(Map<String, dynamic> parsedJson) {
    return IncomeItem(
        description: parsedJson['description'] ?? "",
        cost: parsedJson['cost'] ?? "",
        type: EIncomeType.values.byName(parsedJson['type']),
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
