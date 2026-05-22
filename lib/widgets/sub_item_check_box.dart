import 'package:card_dinamico/models/subItem.dart';
import 'package:flutter/material.dart';

class SubItemCheckBox extends StatefulWidget {
  final SubItem item;
  final VoidCallback onSaved;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isEdit;

  const SubItemCheckBox({
    super.key,
    required this.item,
    required this.onSaved,
    required this.onDelete,
    required this.onEdit,
    this.isEdit = false,
  });

  @override
  State<SubItemCheckBox> createState() => _SubItemCheckBoxState();
}

class _SubItemCheckBoxState extends State<SubItemCheckBox> {
  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      secondary: IconButton(
        onPressed: widget.isEdit ? widget.onEdit : widget.onDelete,
        icon: widget.isEdit ? const Icon(Icons.edit) : const Icon(Icons.delete),
      ),
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
    );
  }
}
