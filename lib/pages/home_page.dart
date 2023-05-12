import 'package:bitbank_app/pages/favoritas_page.dart';
import 'package:bitbank_app/pages/moedas_page.dart';
import 'package:bitbank_app/pages/configuracoes_page.dart';
import 'package:flutter/material.dart';

import 'carteira_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: setPaginaAtual,
        controller: pc,
        children: [
          MoedasPage(),
          FavoritasPage(),
          CarteiraPage(),
          ConfiguracoesPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(label: 'Todas', icon: Icon(Icons.list)),
          BottomNavigationBarItem(label: 'Favoritas', icon: Icon(Icons.star)),
          BottomNavigationBarItem(
              label: 'Carteira', icon: Icon(Icons.account_balance_wallet)),
          BottomNavigationBarItem(label: 'Conta', icon: Icon(Icons.settings))
        ],
        onTap: (pagina) {
          pc.animateToPage(pagina,
              duration: const Duration(milliseconds: 400), curve: Curves.ease);
        },
      ),
    );
  }
}
