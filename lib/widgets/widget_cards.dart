import 'package:card_dinamico/models/card.dart';
import 'package:card_dinamico/models/subItem.dart';
import 'package:card_dinamico/screens/screen_sub_itens.dart';
import 'package:card_dinamico/utils/DB/database_helper.dart';
import 'package:card_dinamico/widgets/sub_item_check_box.dart';
import 'package:card_dinamico/widgets/sub_item_list_tile.dart';
import 'package:flutter/material.dart';

class WidgetCard extends StatefulWidget {
  final DynamicCard card;
  final VoidCallback onUpdate;
  final VoidCallback onDeleteCard;
  final VoidCallback onUpdateCard;
  // final VoidCallback onDeleteSubItem;

  const WidgetCard({
    super.key,
    required this.card,
    required this.onDeleteCard,
    required this.onUpdateCard,
    required this.onUpdate,
    // required this.onDeleteSubItem,
  });

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

  Future<void> _deleteSubItem(SubItem item) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Excluir sub-item?'),
          content: Text('Tem certeza em excluir o item "${item.subTitle}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _dbHelper.deleteSubItem(item.id);

                widget.card.updateAt = DateTime.now();
                await _dbHelper.addCard(widget.card);

                if (!dialogContext.mounted) return;

                Navigator.pop(dialogContext);
                widget.onUpdate();
              },
              child: Text('excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
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
                if (value == 'delete') widget.onDeleteCard();
                if (value == 'update') widget.onUpdateCard();
                if (value == 'edit_sub_item') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => screenSubItens(
                        card: widget.card,
                        onUpdate: widget.onUpdate,
                      ),
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'update',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('editar título'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit_sub_item',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('editar sub-item'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20),
                      SizedBox(width: 8),
                      Text('excluir', style: TextStyle(color: Colors.red)),
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
                onDelete: () => _deleteSubItem(item),
                onEdit: () => {},
              );
            }

            return SubItemCheckBox(
              item: item,
              onSaved: () => _saveSubItem(item),
              onDelete: () => _deleteSubItem(item),
              onEdit: () => {},
            );
          }),
        ],
      ),
    );
  }
}
