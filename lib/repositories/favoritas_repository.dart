import 'dart:collection';

import 'package:bitbank_app/models/moeda.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../adapters/moedas_hive.dart';

class FavoritasRepository extends ChangeNotifier {
  List<Moeda> _list = [];
  late LazyBox box;

  FavoritasRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _openBox();
    await _readFavoritas();
  }

  _openBox() async {
    Hive.registerAdapter(MoedaHiveAdapter());
    box = await Hive.openLazyBox<Moeda>('moedas_favoritas');
  }

  _readFavoritas() {
    box.keys.forEach((moeda) async {
      Moeda m = await box.get(moeda);
      _list.add(m);
      notifyListeners();
    });
  }

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_list);

  saveAll(List<Moeda> moedas) {
    moedas.forEach((moeda) {
      // if (!_list.contains(moeda)) _list.add(moeda);
      if (!_list.any((elAtual) => elAtual.sigla == moeda.sigla)) {
        _list.add(moeda);
        box.put(moeda.sigla, moeda);
      }
    });
    notifyListeners();
  }

  remove(Moeda moeda) {
    _list.remove(moeda);
    notifyListeners();
  }
}
