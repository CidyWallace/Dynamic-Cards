import 'package:card_dinamico/models/card.dart';
import 'package:card_dinamico/models/subItem.dart';
import 'package:card_dinamico/widgets/cards.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DinamiCard> myCards = [
    DinamiCard(
      title: "Contas de Maio",
      itens: [
        SubItem(
          subTitle: "Aluguel",
          isCounter: true,
          current: 3,
          max: 3,
          value: 30,
        ),
        SubItem(
          subTitle: "Energia",
          isCounter: true,
          current: 1,
          max: 3,
          value: 130,
        ),
      ],
    ),
    DinamiCard(
      title: "Lista de compras",
      itens: [
        SubItem(subTitle: "Feijão", isCounter: false, amount: 3, marker: true),
        SubItem(subTitle: "Arroz", isCounter: false, amount: 5, marker: true),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus cards"),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,

        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Futuramente para criar novos Cards!"),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: myCards.isEmpty
          ? const Center(child: Text("Nenhum card criado"))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: myCards.length,
              itemBuilder: (context, index) {
                return WidgetCard(card: myCards[index]);
              },
            ),
    );
  }
}
