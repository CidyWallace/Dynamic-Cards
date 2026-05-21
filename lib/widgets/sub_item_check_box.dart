import 'package:card_dinamico/models/subItem.dart';
import 'package:flutter/material.dart';

class SubItemCheckBox extends StatefulWidget {
  final SubItem item;
  final VoidCallback onSaved;
  final VoidCallback onDelete;

  const SubItemCheckBox({
    super.key,
    required this.item,
    required this.onSaved,
    required this.onDelete,
  });

  @override
  State<SubItemCheckBox> createState() => _SubItemCheckBoxState();
}

class _SubItemCheckBoxState extends State<SubItemCheckBox> {
  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            title: Text(
              "${item.subTitle} x${item.amount}",
              style: TextStyle(
                decoration: item.marker
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            value: item.marker,
            onChanged: (value) {
              setState(() {
                item.marker = value ?? false;
              });
              widget.onSaved();
            },
          ),
        ),
        IconButton(onPressed: widget.onDelete, icon: Icon(Icons.delete)),
      ],
    );
  }
}
