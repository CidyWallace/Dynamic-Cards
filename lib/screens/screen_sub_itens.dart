import 'package:card_dinamico/models/card.dart';
import 'package:card_dinamico/models/subItem.dart';
import 'package:card_dinamico/utils/DB/database_helper.dart';
import 'package:card_dinamico/widgets/sub_item_check_box.dart';
import 'package:card_dinamico/widgets/sub_item_list_tile.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class screenSubItens extends StatefulWidget {
  final DynamicCard card;
  final VoidCallback onUpdate;
  const screenSubItens({super.key, required this.card, required this.onUpdate});

  @override
  State<screenSubItens> createState() => _screenSubItensState();
}

// ignore: camel_case_types
class _screenSubItensState extends State<screenSubItens> {
  final _dbHelper = DatabaseHelper();

  Future<void> _saveSubItem(SubItem newItem) async {
    await _dbHelper.addSubItem(newItem, widget.card.id);

    widget.card.updateAt = DateTime.now();
    await _dbHelper.addCard(widget.card);

    setState(() {
      bool exists = widget.card.itens.any((item) => item.id == newItem);
      if (!exists) {
        widget.card.itens.add(newItem);
      }
    });

    widget.onUpdate();
  }

  void _showPanelNewSubItem() {
    final titleController = TextEditingController();
    final valueController = TextEditingController();
    final maxController = TextEditingController();
    final amountController = TextEditingController();

    bool isCounter = false;

    String? titleError;
    String? valueError;
    String? maxError;
    String? amountError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),

              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Novo Sub-Item',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    SwitchListTile(
                      title: const Text('É do tipo contagem?'),
                      value: isCounter,
                      onChanged: (value) {
                        setModalState(() {
                          isCounter = value;

                          if (!isCounter) {
                            valueError = null;
                            maxError = null;
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: titleController,
                      onChanged: (value) {
                        if (titleError != null) {
                          setModalState(() => titleError = null);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Titulo do sub-item',
                        border: const OutlineInputBorder(),
                        errorText: titleError,
                      ),
                    ),

                    if (isCounter) ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: valueController,
                        onChanged: (value) {
                          if (valueError != null) {
                            setModalState(() => valueError = null);
                          }
                        },
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Valor Unitário (opcional)',
                          border: OutlineInputBorder(),
                          prefixText: 'R\$ ',
                          errorText: valueError,
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: maxController,
                        onChanged: (value) {
                          if (maxError != null) {
                            setModalState(() => maxError = null);
                          }
                        },
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          labelText: 'Quantas pessoas vão dividir?',
                          border: OutlineInputBorder(),
                          errorText: maxError,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: amountController,
                        onChanged: (value) {
                          if (amountError != null) {
                            setModalState(() => amountError = null);
                          }
                        },
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          labelText: 'São quantos produtos?',
                          border: OutlineInputBorder(),
                          errorText: amountError,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        bool hasError = false;

                        if (titleController.text.trim().isEmpty) {
                          setModalState(() {
                            titleError = 'O titulo não pode ficar vazio';
                          });
                          hasError = true;
                        }

                        if (amountController.text.trim().isEmpty) {
                          setModalState(() {
                            amountError = 'Digite um valor válido';
                          });
                        }

                        double valueParse = 0.0;
                        if (isCounter && valueController.text.isNotEmpty) {
                          String value = valueController.text.replaceAll(
                            ',',
                            '.',
                          );
                          double? value_parse = double.tryParse(value);

                          if (value_parse == null) {
                            setModalState(() {
                              valueError = 'Digite um valor válido';
                            });
                            hasError = true;
                          } else {
                            valueParse = value_parse;
                          }
                        } else if (isCounter && valueController.text.isEmpty) {
                          setModalState(() {
                            valueError = 'Esse campos não pode ficar vazio';
                          });
                          hasError = true;
                        }

                        int maxParse = 0;
                        if (isCounter && maxController.text.isNotEmpty) {
                          String max = maxController.text;
                          int? max_parse = int.tryParse(max);

                          if (max_parse == null) {
                            setModalState(() {
                              maxError = 'Digite um número válido';
                            });
                            hasError = true;
                          } else {
                            maxParse = max_parse;
                          }
                        } else if (isCounter && maxController.text.isEmpty) {
                          setModalState(() {
                            maxError = 'Esse campos não pode ficar vazio';
                          });
                          hasError = true;
                        }

                        if (hasError) return;

                        final newSubItem = SubItem(
                          subTitle: titleController.text,
                          isCounter: isCounter,
                          value: valueParse,
                          amount: maxParse,
                          max: maxParse,
                        );

                        _saveSubItem(newSubItem);
                        Navigator.pop(context);
                      },
                      child: Text('Salvar sub-item'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.card.title)),
      body: widget.card.itens.isEmpty
          ? const Center(child: Text("Nenhum sub-item Adicionado"))
          : ListView.builder(
              itemCount: widget.card.itens.length,
              itemBuilder: (context, index) {
                final item = widget.card.itens[index];

                return item.isCounter
                    ? SubItemListTile(item: item, onSaved: () => {})
                    : SubItemCheckBox(item: item, onSaved: () => {});
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: _showPanelNewSubItem,
        label: const Text('Novo sub-item'),
        icon: Icon(Icons.playlist_add),
      ),
    );
  }
}
