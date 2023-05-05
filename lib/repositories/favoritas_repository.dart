import 'dart:collection';

import 'package:bitbank_app/models/moeda.dart';
import 'package:flutter/material.dart';

class FavoritasRepository extends ChangeNotifier {
  List<Moeda> _list = [];

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_list);

  saveAll(List<Moeda> moedas) {
    moedas.forEach((moeda) {
      if (!_list.contains(moeda)) _list.add(moeda);
    });
    notifyListeners();
  }

  remove(Moeda moeda) {
    _list.remove(moeda);
    notifyListeners();
  }
}
