// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bitbank_app/repositories/conta_repository.dart';
import 'package:bitbank_app/widgets/block_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configs/app_settings.dart';
import '../models/moeda.dart';

class MoedaDetalhesPage extends StatefulWidget {
  Moeda moeda;

  MoedaDetalhesPage({
    Key? key,
    required this.moeda,
  }) : super(key: key);

  @override
  State<MoedaDetalhesPage> createState() => _MoedaDetalhesPageState();
}

class _MoedaDetalhesPageState extends State<MoedaDetalhesPage> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final _formKey = GlobalKey<FormState>();
  final _valor = TextEditingController();
  double qtd = 0;
  bool btnEnabled = false;

  late ContaRepository conta;

  readNumberFormat() {
    final lang = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: lang['locale'], name: lang['name']);
  }

  submitComprar() async {
    if (_formKey.currentState!.validate()) {
      await conta.comprar(widget.moeda, double.parse(_valor.text));

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[800],
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check,
                color: Colors.white,
              ),
              Text(
                ' Compra realizada com sucesso',
              ),
            ],
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    readNumberFormat();

    conta = Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(widget.moeda.nome)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Image.asset(widget.moeda.icone),
                  ),
                  Container(width: 10),
                  Text(
                    real.format(widget.moeda.preco),
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                        color: Colors.grey[800]),
                  ),
                ]),
          ),
          (qtd > 0)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(color: Colors.teal.withOpacity(0.05)),
                    child: Text('$qtd ${widget.moeda.sigla}',
                        style:
                            const TextStyle(color: Colors.teal, fontSize: 20)),
                  ))
              : Container(
                  margin: const EdgeInsets.only(bottom: 24),
                ),
          Form(
              key: _formKey,
              child: TextFormField(
                controller: _valor,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Valor',
                  prefix: Text('R\$ '),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  setState(() {
                    btnEnabled = value.isNotEmpty;
                    qtd = value.isEmpty
                        ? 0
                        : double.parse(value) / widget.moeda.preco;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o valor da compra';
                  } else if (double.parse(value) < 50) {
                    return 'Compra minima de R\$ 50,00';
                  } else if (double.parse(value) > conta.saldo) {
                    return 'Você não tem saldo suficiente';
                  }
                  return null;
                },
              )),
          Container(
              margin: const EdgeInsets.only(top: 24),
              child: BlockButton(
                  onPressed: btnEnabled ? () => submitComprar() : null,
                  icon: Icons.add_shopping_cart_outlined,
                  label: 'Comprar'))
        ]),
      ),
    );
  }
}
