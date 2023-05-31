import 'package:bitbank_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  bool loading = false;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  late IconData icon;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLoginPage = acao;
      if (isLoginPage) {
        titulo = "Bem Vindo";
        actionButton = "Login";
        toggleButton = "Ainda não tem conta ? Cadastre-se agora";
        icon = Icons.login;
      } else {
        titulo = "Crie uma conta";
        actionButton = "Cadastrar";
        toggleButton = "Voltar ao login";
        icon = Icons.person_add_outlined;
      }
    });
  }

  signIn() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().signIn(email.text, password.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  signUp() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().signUp(email.text, password.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
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
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: BlockButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (isLoginPage) {
                              signIn();
                            } else {
                              signUp();
                            }
                          }
                        },
                        loading: loading,
                        icon: icon,
                        label: actionButton),
                  ),
                  TextButton(
                    child: Text(toggleButton),
                    onPressed: () => setFormAction(!isLoginPage),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
