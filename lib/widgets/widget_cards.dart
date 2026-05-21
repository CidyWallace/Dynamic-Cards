import 'package:card_dinamico/models/card.dart';
import 'package:card_dinamico/models/subItem.dart';
import 'package:card_dinamico/utils/DB/database_helper.dart';
import 'package:card_dinamico/widgets/sub_item_check_box.dart';
import 'package:card_dinamico/widgets/sub_item_list_tile.dart';
import 'package:flutter/material.dart';

class WidgetCard extends StatefulWidget {
  final DynamicCard card;
  final VoidCallback onDelete;

  const WidgetCard({super.key, required this.card, required this.onDelete});

  @override
  State<WidgetCard> createState() => _WidgetCardState();
}

class _WidgetCardState extends State<WidgetCard> {
  final _dbHelper = DatabaseHelper();

  Future<void> _saveSubItem(SubItem newItem) async {
    await _dbHelper.addSubItem(newItem, widget.card.id);

    widget.card.updateAt = DateTime.now();
    await _dbHelper.addCard(widget.card);

    bool exits = widget.card.itens.any((item) => item.id == newItem.id);

    if (!exits) {
      setState(() {
        widget.card.itens.add(newItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.card.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'delete') widget.onDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20),
                      SizedBox(width: 8),
                      Text('Excluir', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          ...widget.card.itens.map<Widget>((item) {
            if (item.isCounter) {
              return SubItemListTile(
                item: item,
                onSaved: () => _saveSubItem(item),
              );
            }

            return SubItemCheckBox(
              item: item,
              onSaved: () => _saveSubItem(item),
            );
          }),
        ],
      ),
    );
  }
}
