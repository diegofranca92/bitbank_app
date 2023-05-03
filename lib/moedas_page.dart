import 'package:bitbank_app/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/moeda.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final tabela = MoedaRepository.tabela;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<Moeda> selecionadas = [];

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(title: const Center(child: Text('Bit Bank')));
    } else {
      return AppBar(
        title: Center(child: Text('${selecionadas.length} selecionadas')),
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              selecionadas = [];
            });
          },
        ),
        backgroundColor: Colors.blueGrey,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int moeda) {
            return ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              leading: selecionadas.contains(tabela[moeda])
                  ? const CircleAvatar(
                      child: Icon(Icons.check),
                    )
                  : SizedBox(
                      width: 40, child: Image.asset(tabela[moeda].icone)),
              title: Text(
                tabela[moeda].nome,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
              trailing: Text(real.format(tabela[moeda].preco)),
              selected: selecionadas.contains(tabela[moeda]),
              selectedTileColor: Colors.indigo[50],
              onLongPress: () {
                setState(() {
                  (selecionadas.contains(tabela[moeda]))
                      ? selecionadas.remove(tabela[moeda])
                      : selecionadas.add(tabela[moeda]);
                });
              },
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          padding: const EdgeInsets.all(16),
          itemCount: tabela.length),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selecionadas.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.star),
              label: const Text(
                'FAVORITAR',
                style:
                    TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.6),
              ))
          : null,
    );
  }
}
