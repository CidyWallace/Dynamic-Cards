import 'package:card_dinamico/models/subItem.dart';
import 'package:uuid/uuid.dart';

var _uuid = const Uuid();

class DynamicCard {
  String id;
  String title;
  DateTime updateAt;
  List<SubItem> itens;
  bool deleted;

  DynamicCard({
    String? id,
    required this.title,
    DateTime? updateAt,
    this.deleted = false,
    List<SubItem>? itens,
  }) : id = id ?? _uuid.v4(),
       updateAt = updateAt ?? DateTime.now(),
       itens = itens ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'updateAt': updateAt.toIso8601String(),
      'deleted': deleted ? 1 : 0,
    };
  }

  factory DynamicCard.fromMap(
    Map<String, dynamic> map, {
    List<SubItem>? loadedItems,
  }) {
    return DynamicCard(
      id: map['id'],
      title: map['title'],
      updateAt: DateTime.parse(map['updateAt']),
      deleted: map['deleted'] == 1 || map['deleted'] == true,
      itens: loadedItems ?? [],
    );
  }
}
