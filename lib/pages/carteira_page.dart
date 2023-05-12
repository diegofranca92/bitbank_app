import 'package:bitbank_app/models/posicao.dart';
import 'package:bitbank_app/repositories/conta_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configs/app_settings.dart';

class CarteiraPage extends StatefulWidget {
  const CarteiraPage({super.key});

  @override
  State<CarteiraPage> createState() => _CarteiraPageState();
}

class _CarteiraPageState extends State<CarteiraPage> {
  int index = 0;
  double totalCarteira = 0;
  double saldo = 0;
  late ContaRepository conta;
  late NumberFormat real;

  String graficoLabel = '';
  double graficoValor = 0;
  List<Posicao> carteira = [];

  @override
  Widget build(BuildContext context) {
    conta = context.watch<ContaRepository>();
    saldo = conta.saldo;

    final lang = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: lang['locale'], name: lang['name']);

    setTotalCarteira();

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 48),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(top: 48, bottom: 8),
            child: Text('Valor da Carteira', style: TextStyle(fontSize: 18)),
          ),
          Text(
            real.format(totalCarteira),
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.w500, letterSpacing: -1.5),
          ),
          loadGrafico(),
        ]),
      ),
    );
  }

  loadGrafico() {
    return (conta.saldo <= 0)
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(PieChartData(
                    sectionsSpace: 5,
                    centerSpaceRadius: 110,
                    sections: loadCarteira(),
                    pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) =>
                            setState(() {
                              if (event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                index = -1;
                                return;
                              }
                              index = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                              setGraficoDados(index);
                            })))),
              ),
              Column(
                children: [
                  Text(
                    graficoLabel,
                    style: TextStyle(fontSize: 20, color: Colors.teal),
                  ),
                  Text(
                    real.format(graficoValor),
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  )
                ],
              )
            ],
          );
  }

  setTotalCarteira() {
    final carteiraList = conta.carteira;
    setState(() {
      totalCarteira = conta.saldo;
      for (var posicao in carteiraList) {
        totalCarteira += posicao.moeda.preco * posicao.quantidade;
      }
    });
  }

  loadCarteira() {
    setGraficoDados(index);
    carteira = conta.carteira;
    final tamanhoLista = conta.carteira.length + 1;

    return List.generate(tamanhoLista, (i) {
      final isTouched = i == index;
      final isSaldo = i == tamanhoLista - 1;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];

      double porcenagem = 0;

      if (!isSaldo) {
        porcenagem =
            carteira[i].moeda.preco * carteira[i].quantidade / totalCarteira;
      } else {
        porcenagem = (conta.saldo > 0) ? conta.saldo / totalCarteira : 0;
      }

      porcenagem *= 100;

      return PieChartSectionData(
          color: color,
          value: porcenagem,
          title: '${porcenagem.toStringAsFixed(0)}%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87));
    });
  }

  setGraficoDados(int index) {
    if (index < 0) return;

    if (index == carteira.length) {
      graficoLabel = 'Saldo';
      graficoValor = conta.saldo;
    } else {
      graficoLabel = carteira[index].moeda.nome;
      graficoValor = carteira[index].moeda.preco * carteira[index].quantidade;
    }
  }
}
