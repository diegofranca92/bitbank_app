import 'package:flutter/material.dart';

import '../widgets/block_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLoginPage = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;

  @override
  void initState() {
    super.initState();
    setFormState(true);
  }

  setFormState(bool acao) {
    setState(() {
      isLoginPage = acao;
      if (isLoginPage) {
        titulo = "Bem Vindo";
        actionButton = "Login";
        toggleButton = "Ainda não tem conta ? Cadastre-se agora";
      } else {
        titulo = "Crie uma conta";
        actionButton = "Cadastrar";
        toggleButton = "Voltar ao login";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: TextFormField(
                      controller: email,
                      style: const TextStyle(fontSize: 22),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe um email válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: TextFormField(
                      controller: password,
                      obscureText: true,
                      style: const TextStyle(fontSize: 22),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Senha',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe sua senha';
                        } else if (value.length < 6) {
                          return 'Sua senha deve ter no minimo 6 digitos';
                        }
                        return null;
                      },
                    ),
                  ),
                  BlockButton(
                      onPressed: () {}, icon: Icons.login, label: actionButton),
                  TextButton(
                    child: Text(toggleButton),
                    onPressed: setFormState(!isLoginPage),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
