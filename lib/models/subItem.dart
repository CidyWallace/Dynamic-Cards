class SubItem {
  String subTitle;
  bool isCounter;

  bool marker;
  int current;
  int max;
  int amount;
  double value;

  SubItem({
    required this.subTitle,
    required this.isCounter,
    this.current = 0,
    this.max = 0,
    this.value = 0.0,
    this.amount = 0,
    this.marker = false,
  });

  double dividedValue() {
    double total = value / max;
    return double.parse(total.toStringAsFixed(2));
  }
}
