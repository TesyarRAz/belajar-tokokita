import 'package:flutter/material.dart';
import 'package:tokokita/bloc/login_bloc.dart';
import 'package:tokokita/helpers/user_info.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/ui/registrasi_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _emailTextField(),
                _passwordTextField(),
                _buttonLogin(),
                const SizedBox(
                  height: 30,
                ),
                _menuRegistrasi()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Email",
        ),
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        validator: (value) =>
            value?.isEmpty ?? true ? "Email harus diisi" : null,
      );

  Widget _passwordTextField() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Password",
        ),
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: _passwordController,
        validator: (value) =>
            (value?.isEmpty ?? true) ? "Password harus diisi" : null,
      );

  Widget _buttonLogin() => ElevatedButton(
        child: const Text('Login'),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              _submit();
            }
          }
        },
      );

  Widget _menuRegistrasi() => Container(
        child: InkWell(
          child: const Text(
            'Registrasi',
            style: const TextStyle(color: Colors.blue),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RegistrasiPage(),
              ),
            );
          },
        ),
      );

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    LoginBloc.login(
      email: _emailController.text,
      password: _passwordController.text,
    ).then(
      (value) {
        Future.wait([
          UserInfo().setToken(value.token.toString()),
          UserInfo().setUserID(int.parse(value.userId.toString())),
        ]).whenComplete(
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProdukPage(),
              ),
            );
          },
        );
      },
      onError: (error) {
        print(error);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Login gagal, silahkan coba lagi",
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
