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
      creditAmount: parsedJson['creditAmount'] ?? 0.0,
      accruedInterest: parsedJson['accruedInterest'] ?? 0.0,
      mountlyPayment: parsedJson['mountlyPayment'] ?? 0.0,
      debtInterest: parsedJson['debtInterest'] ?? 0.0,
      mortageTerm: parsedJson['mortageTerm'] ?? 0,
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
