import 'package:flutter/material.dart';
import 'package:tokokita/bloc/registrasi_bloc.dart';
import 'package:tokokita/widget/success_dialog.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
                _namaTextField(),
                _emailTextField(),
                _passwordTextField(),
                _passwordKonfirmasiTextField(),
                _buttonRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _namaTextField() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Nama",
        ),
        keyboardType: TextInputType.text,
        controller: _namaController,
        validator: (value) => (value?.length ?? 0) < 3
            ? "Nama harus diisi minimal 3 karakter"
            : null,
      );

  Widget _emailTextField() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Email",
        ),
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return "Email harus diisi";
          }

          if (!RegExp(
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
              .hasMatch(value!)) {
            return "Email tidak valid";
          }
          return null;
        },
      );

  Widget _passwordTextField() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Password",
        ),
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: _passwordController,
        validator: (value) => (value?.length ?? 0) < 6
            ? "Password harus diisi minimal 6 karakter"
            : null,
      );

  Widget _passwordKonfirmasiTextField() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Password Konfirmasi",
        ),
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: _confirmPasswordController,
        validator: (value) => value != _confirmPasswordController.text
            ? "Password konfirmasi tidak sama"
            : null,
      );

  Widget _buttonRegistrasi() => ElevatedButton(
        child: const Text('Registrasi'),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              _submit();
            }
          }
        },
      );

  void _submit() {
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    RegistrasiBloc.registrasi(
      nama: _namaController.text,
      email: _emailController.text,
      password: _passwordController.text,
    ).then(
      (value) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SuccessDialog(
          description: 'Registrasi Berhasil, Silahkan login',
          okClick: () {
            Navigator.pop(context);
          },
        ),
      ),
      onError: (error) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const WarningDialog(
          description: 'Registrasi Gagal, Silahkan coba lagi',
        ),
      ),
    ).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
