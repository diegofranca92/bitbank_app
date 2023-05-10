import 'package:bitbank_app/repositories/favoritas_repository.dart';
import 'package:bitbank_app/widgets/moeda_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritasPage extends StatefulWidget {
  const FavoritasPage({super.key});

  @override
  State<FavoritasPage> createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritas'),
      ),
      body: Container(
          color: Colors.indigo.withOpacity(0.05),
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(12),
          child: Consumer<FavoritasRepository>(
            builder: (context, favoritas, child) {
              return favoritas.lista.isEmpty
                  ? ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Ainda não há moedas favoritas'),
                    )
                  : ListView.builder(
                      itemCount: favoritas.lista.length,
                      itemBuilder: (_, index) {
                        return MoedaCard(moeda: favoritas.lista[index]);
                      },
                    );
            },
          )),
    );
  }
}