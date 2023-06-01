import 'dart:async';
import 'dart:convert';

import 'package:bitbank_app/models/moeda.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import '../database/db.dart';

class MoedaRepository extends ChangeNotifier {
  List<Moeda> _tabela = [];
  late Timer intervalo;

  List<Moeda> get tabela => _tabela;

  MoedaRepository() {
    _setupMoedasTable();
    _setupDataTableMoedas();
    _readMoedasTable();
    _refreshMoedasTable();
  }

  _setupMoedasTable() async {
    const String table = '''
      CREATE TABLE IF NOT EXISTS moedas (
        baseId TEXT PRIMARY KEY,
        sigla TEXT,
        nome TEXT,
        icone TEXT,
        preco TEXT,
        timestamp INTEGER,
        mudancaHora TEXT,
        mudancaDia TEXT,
        mudancaSemana TEXT,
        mudancaMes TEXT,
        mudancaAno TEXT,
        mudancaPeriodoTotal TEXT
      );
    ''';
    Database db = await DB.instance.database;
    await db.execute(table);
  }

  _setupDataTableMoedas() async {
    if (await _moedasTableIsEmpty()) {
      String uri = 'https://api.coinbase.com/v2/assets/search?base=BRL';

      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> moedas = json['data'];
        Database db = await DB.instance.database;
        Batch batch = db.batch();

        moedas.forEach((moeda) {
          final preco = moeda['latest_price'];
          final timestamp = DateTime.parse(preco['timestamp']);

          batch.insert('moedas', {
            'preco': moeda['latest'],
            'timestamp': timestamp.millisecondsSinceEpoch,
            'mudancaHora': preco['percent_change']['hour'].toString(),
            'mudancaDia': preco['percent_change']['day'].toString(),
            'mudancaSemana': preco['percent_change']['week'].toString(),
            'mudancaMes': preco['percent_change']['month'].toString(),
            'mudancaAno': preco['percent_change']['year'].toString(),
            'mudancaPeriodoTotal': preco['percent_change']['all'].toString()
          });
        });

        await batch.commit(noResult: true);
      }
    }
  }

  _moedasTableIsEmpty() async {
    Database db = await DB.instance.database;
    List result = await db.query('moedas');
    return result.isEmpty;
  }

  _readMoedasTable() async {
    Database db = await DB.instance.database;
    List result = await db.query('moedas');

    _tabela = result.map((moeda) {
      return Moeda(
        baseId: moeda['baseId']!,
        icone: moeda['icone'],
        sigla: moeda['sigla'],
        nome: moeda['nome'],
        preco: double.parse(moeda['preco']),
        timestamp: DateTime.fromMillisecondsSinceEpoch(moeda['timestamp']),
        mudancaHora: double.parse(moeda['mudancaHora']),
        mudancaDia: double.parse(moeda['mudancaDia']),
        mudancaSemana: double.parse(moeda['mudancaSemana']),
        mudancaMes: double.parse(moeda['mudancaMes']),
        mudancaAno: double.parse(moeda['mudancaAno']),
        mudancaPeriodoTotal: double.parse(moeda['mudancaPeriodoTotal']),
      );
    }).toList();

    notifyListeners();
  }

  _refreshMoedasTable() async {
    intervalo = Timer.periodic(Duration(days: 1), (_) => checkPrecos());
  }

  checkPrecos() async {
    String uri = 'https://api.coinbase.com/v2/assets/search?base=BRL';

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> moedas = json['data'];
      Database db = await DB.instance.database;
      Batch batch = db.batch();

      _tabela.forEach((dadosAtual) {
        moedas.forEach((novosDados) {
          final moeda = novosDados['base_id'];
          final preco = moeda['latest_price'];
          final timestamp = DateTime.parse(preco['timesamp']);

          batch.update(
            'moedas',
            {
              'preco': moeda['latest'],
              'timestamp': timestamp.millisecondsSinceEpoch,
              'mudancaHora': preco['percent_change']['hour'].toString(),
              'mudancaDia': preco['percent_change']['day'].toString(),
              'mudancaSemana': preco['percent_change']['week'].toString(),
              'mudancaMes': preco['percent_change']['month'].toString(),
              'mudancaAno': preco['percent_change']['year'].toString(),
              'mudancaPeriodoTotal': preco['percent_change']['all'].toString()
            },
            where: 'baseId = ?',
            whereArgs: [dadosAtual.baseId],
          );
        });
      });
      await batch.commit(noResult: true);
      await _readMoedasTable();
    }
  }
}
