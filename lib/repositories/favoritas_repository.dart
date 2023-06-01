import 'dart:collection';

import 'package:bitbank_app/database/db_firestore.dart';
import 'package:bitbank_app/models/moeda.dart';
import 'package:bitbank_app/repositories/moeda_repository.dart';
import 'package:bitbank_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

// import '../adapters/moedas_hive.dart';

class FavoritasRepository extends ChangeNotifier {
  List<Moeda> _list = [];
  // Hive - late LazyBox box;
  MoedaRepository moedas;

  late FirebaseFirestore db;
  late AuthService auth;

  FavoritasRepository({required this.auth, required this.moedas}) {
    _startRepository();
  }

  _startRepository() async {
    // await _openBox();
    await _startFirestore();
    await _readFavoritas();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  // _openBox() async {
  //   Hive.registerAdapter(MoedaHiveAdapter());
  //   box = await Hive.openLazyBox<Moeda>('moedas_favoritas');
  // }

  _readFavoritas() async {
    // Hive
    // box.keys.forEach((moeda) async {
    //   Moeda m = await box.get(moeda);
    //   _list.add(m);
    //   notifyListeners();
    // });

    if (auth.usuario != null && _list.isEmpty) {
      final snapshot =
          await db.collection('usuarios/${auth.usuario!.uid}/favoritas').get();

      snapshot.docs.forEach((doc) {
        Moeda m = moedas.tabela
            .firstWhere((moeda) => moeda.sigla == doc.get('sigla'));
        _list.add(m);
        notifyListeners();
      });
    }
  }

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_list);

  saveAll(List<Moeda> moedas) {
    moedas.forEach((moeda) async {
      // if (!_list.contains(moeda)) _list.add(moeda);
      if (!_list.any((elAtual) => elAtual.sigla == moeda.sigla)) {
        _list.add(moeda);
        // box.put(moeda.sigla, moeda);
        await db
            .collection('usuarios/${auth.usuario!.uid}/favoritas')
            .doc(moeda.sigla)
            .set({
          'moeda': moeda.nome,
          'sigla': moeda.sigla,
          'preco': moeda.preco
        });
      }
    });
    notifyListeners();
  }

  remove(Moeda moeda) async {
    // box.delete(moeda.sigla);
    await db
        .collection('usuarios/${auth.usuario!.uid}/favoritas')
        .doc(moeda.sigla)
        .delete();
    _list.remove(moeda);
    notifyListeners();
  }
}
