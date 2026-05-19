import 'package:card_dinamico/models/card.dart';
import 'package:flutter/material.dart';

class WidgetCard extends StatefulWidget {
  final DinamiCard card;

  const WidgetCard({super.key, required this.card});

  @override
  State<WidgetCard> createState() => _WidgetCardState();
}

class _WidgetCardState extends State<WidgetCard> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          widget.card.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          ...widget.card.itens.map<Widget>((item) {
            if (item.isCounter) {
              return ListTile(
                title: Text("${item.subTitle}: R\$ ${item.value}"),
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
                        },
                        icon: Icon(Icons.remove_circle_outline),
                      ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (item.current < item.max) item.current++;
                        });
                      },
                      icon: Icon(
                        item.current >= item.max
                            ? Icons.check_circle
                            : Icons.add_circle,
                        color: item.current == item.max
                            ? Colors.green
                            : colors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return CheckboxListTile(
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
              },
            );
          }),
        ],
      ),
    );
  }
}
