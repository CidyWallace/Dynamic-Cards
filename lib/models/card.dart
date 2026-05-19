import 'package:card_dinamico/models/subItem.dart';

class DinamiCard {
  String title;
  List<SubItem> itens;
  bool isDeleted;

  DinamiCard({
    required this.title,
    required this.itens,
    this.isDeleted = false,
  });
}
