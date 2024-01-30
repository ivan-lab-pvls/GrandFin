class CalculateMortage {
  double? creditAmount;
  double? accruedInterest;
  double? mountlyPayment;
  double? debtInterest;
  int? mortageTerm;

  CalculateMortage(
      {this.creditAmount,
      this.accruedInterest,
      this.mountlyPayment,
      this.debtInterest,
      this.mortageTerm});

  factory CalculateMortage.fromJson(Map<String, dynamic> parsedJson) {
    return CalculateMortage(
      creditAmount: parsedJson['creditAmount'] ?? "",
      accruedInterest: parsedJson['accruedInterest'] ?? "",
      mountlyPayment: parsedJson['mountlyPayment'] ?? "",
      debtInterest: parsedJson['debtInterest'] ?? "",
      mortageTerm: parsedJson['mortageTerm'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "creditAmount": creditAmount,
      "accruedInterest": accruedInterest,
      "mountlyPayment": mountlyPayment,
      "debtInterest": debtInterest,
      "mortageTerm": mortageTerm
    };
  }
}
