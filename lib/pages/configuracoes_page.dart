import 'package:bitbank_app/repositories/conta_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configs/app_settings.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppSettings>().locale;
    NumberFormat real =
        NumberFormat.currency(locale: lang['locale'], name: lang['name']);

    final conta = context.watch<ContaRepository>();

    return Scaffold(
      appBar: AppBar(title: Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          ListTile(
            title: const Text('Saldo'),
            subtitle: Text(
              real.format(conta.saldo),
              style: const TextStyle(fontSize: 25, color: Colors.indigo),
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: updateSaldo,
            ),
          ),
          Divider()
        ]),
      ),
    );
  }

  updateSaldo() async {
    final form = GlobalKey<FormState>();
    final valor = TextEditingController();
    final conta = context.read<ContaRepository>();

    valor.text = conta.saldo.toString();

    AlertDialog dialog = AlertDialog(
      title: Text('Atualizar saldo'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('CANCELAR')),
        TextButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                conta.setSaldo(double.parse(valor.text));
                Navigator.pop(context);
              }
            },
            child: Text('SALVAR'))
      ],
      content: Form(
          key: form,
          child: TextFormField(
            controller: valor,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
            ],
            validator: (value) {
              if (value!.isEmpty) return 'Informe o valor do saldo';
              return null;
            },
          )),
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}
