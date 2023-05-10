import 'package:bitbank_app/configs/app_settings.dart';
import 'package:bitbank_app/mostrar_detalhes.dart';
import 'package:bitbank_app/repositories/favoritas_repository.dart';
import 'package:bitbank_app/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'models/moeda.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final tabela = MoedaRepository.tabela;
  late NumberFormat real;
  late Map<String, String> lang;
  List<Moeda> selecionadas = [];
  late FavoritasRepository favoritas;

  readNumberFormat() {
    lang = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: lang['locale'], name: lang['name']);
  }

  changeLanguage() {
    final locale = lang['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = lang['locale'] == 'pt_BR' ? '\$' : 'R\$';

    return PopupMenuButton(
        tooltip: 'Mudar moeda',
        icon: const Icon(Icons.language),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  title: Text('Usar $locale'),
                  leading: const Icon(Icons.swap_vert),
                  onTap: () {
                    context.read<AppSettings>().setLocale(locale, name);
                    Navigator.pop(context);
                  },
                ),
              )
            ]);
  }

  limparSelecionadas() {
    setState(() {
      selecionadas = [];
    });
  }

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
        title: const Center(child: Text('Bit Bank')),
        actions: [changeLanguage()],
      );
    } else {
      return AppBar(
        title: Center(child: Text('${selecionadas.length} selecionadas')),
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => limparSelecionadas(),
        ),
        backgroundColor: Colors.blueGrey,
      );
    }
  }

  mostrarDetalhes(Moeda moeda) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => MoedaDetalhesPage(moeda: moeda)));
  }

  @override
  Widget build(BuildContext context) {
    // favoritas = Provider.of<FavoritasRepository>(context);
    favoritas = context.watch<FavoritasRepository>();
    readNumberFormat();

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
              title: Row(
                children: [
                  Text(
                    tabela[moeda].nome,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  if (favoritas.lista
                      .any((fav) => fav.sigla == tabela[moeda].sigla))
                    const Icon(
                      Icons.circle,
                      color: Colors.amber,
                      size: 8,
                    )
                ],
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
              onTap: () => mostrarDetalhes(tabela[moeda]),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          padding: const EdgeInsets.all(16),
          itemCount: tabela.length),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selecionadas.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                favoritas.saveAll(selecionadas);
                limparSelecionadas();
              },
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
