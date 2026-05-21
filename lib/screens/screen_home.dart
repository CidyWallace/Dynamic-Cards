import 'package:card_dinamico/models/card.dart';
import 'package:card_dinamico/screens/screen_sub_itens.dart';
import 'package:card_dinamico/utils/DB/database_helper.dart';
import 'package:card_dinamico/widgets/widget_cards.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dbHelper = DatabaseHelper();
  List<DynamicCard> _myCards = [];

  @override
  void initState() {
    super.initState();
    _refreshCards();
  }

  // ignore: unused_element
  Future<void> _addNewCards(String title) async {
    final newCard = DynamicCard(title: title);

    await _dbHelper.addCard(newCard);

    setState(() {
      _myCards.add(newCard);
    });

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              screenSubItens(card: newCard, onUpdate: _refreshCards),
        ),
      );
    }
  }

  void _refreshCards() async {
    final syncCard = await _dbHelper.getAllCards();

    setState(() {
      _myCards = syncCard;
    });
  }

  void _showBoxAddCard() {
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Novo Card"),
          content: TextField(
            controller: titleController,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Digite o título do card...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                String title = titleController.text.trim();
                if (title.isNotEmpty) {
                  Navigator.pop(dialogContext);
                  _addNewCards(title);
                }
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

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

        onPressed: () => _showBoxAddCard(),
        child: Icon(Icons.add),
      ),
      body: _myCards.isEmpty
          ? const Center(child: Text("Nenhum card criado"))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _myCards.length,
              itemBuilder: (context, index) {
                return WidgetCard(card: _myCards[index]);
              },
            ),
    );
  }
}
