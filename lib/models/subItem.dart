import 'package:uuid/uuid.dart';

var _uuid = const Uuid();

class SubItem {
  String id;
  String subTitle;
  bool isCounter;
  bool marker;
  int current;
  int max;
  int amount;
  double value;

  DateTime updateAt;
  bool deleted;

  SubItem({
    String? id,
    required this.subTitle,
    required this.isCounter,
    this.marker = false,
    this.current = 0,
    this.max = 0,
    this.amount = 0,
    this.value = 0.0,
    DateTime? updateAt,
    this.deleted = false,
  }) : id = id ?? _uuid.v4(),
       updateAt = updateAt ?? DateTime.now();

  Map<String, dynamic> toMap(String cardId) {
    return {
      'id': id,
      'card_id': cardId,
      'subTitle': subTitle,
      'isCounter': isCounter ? 1 : 0,
      'marker': marker ? 1 : 0,
      'current': current,
      'max': max,
      'amount': amount,
      'value': value,
      'updateAt': updateAt.toIso8601String(),
      'deleted': deleted ? 1 : 0,
    };
  }

  factory SubItem.fromMap(Map<String, dynamic> map) {
    return SubItem(
      id: map['id'],
      subTitle: map['subTitle'],
      isCounter: map['isCounter'] == 1 || map['isCounter'] == true,
      marker: map['marker'] == 1 || map['marker'] == true,
      current: map['current'],
      max: map['max'],
      amount: map['amount'],
      value: (map['value'] ?? 0.0).toDouble(),
      updateAt: DateTime.parse(map['updateAt']),
      deleted: map['deleted'] == 1 || map['deleted'] == true,
    );
  }

  double dividedValue() {
    if (max <= 0) return value;
    double total = value / max;
    return double.parse(total.toStringAsFixed(2));
  }
}
