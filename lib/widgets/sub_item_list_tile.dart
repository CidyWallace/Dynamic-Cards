import 'package:card_dinamico/models/subItem.dart';
import 'package:flutter/material.dart';

class SubItemListTile extends StatefulWidget {
  final SubItem item;
  final VoidCallback onSaved;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isEdit;

  const SubItemListTile({
    super.key,
    required this.item,
    required this.onSaved,
    required this.onDelete,
    required this.onEdit,
    this.isEdit = false,
  });

  @override
  State<SubItemListTile> createState() => _SubItemListTileState();
}

class _SubItemListTileState extends State<SubItemListTile> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      title: Text("${capitalize(item.subTitle)}: R\$ ${item.value}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Parcela: R\$ ${item.dividedValue()}"),
          Text("Pago: ${item.current} de ${item.max}"),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.current > 0)
            IconButton(
              onPressed: () {
                setState(() {
                  item.current--;
                });
                widget.onSaved();
              },
              icon: Icon(Icons.remove_circle_outline),
            ),
          IconButton(
            onPressed: () {
              setState(() {
                if (item.current < item.max) item.current++;
              });
              widget.onSaved();
            },
            icon: Icon(
              item.current >= item.max ? Icons.check_circle : Icons.add_circle,
              color: item.current == item.max ? Colors.green : colors.primary,
            ),
          ),
          IconButton(
            onPressed: widget.isEdit ? widget.onEdit : widget.onDelete,
            icon: widget.isEdit ? Icon(Icons.edit) : Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
