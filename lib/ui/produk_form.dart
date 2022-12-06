import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String judul = "Tambah Produk";
  String tombolSubmit = "Simpan";

  final _kodeController = TextEditingController();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    isUpdate();
  }

  void isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "Ubah Produk";
        tombolSubmit = "Ubah";
        _kodeController.text = widget.produk?.kode ?? "";
        _namaController.text = widget.produk?.nama ?? "";
        _hargaController.text = widget.produk?.harga?.toString() ?? "";
      });
    } else {
      judul = "Tambah Produk";
      tombolSubmit = "Simpan";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _kodeTextField(),
                _namaTextField(),
                _hargaTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kodeTextField() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Kode Produk",
        ),
        keyboardType: TextInputType.text,
        controller: _kodeController,
        validator: (value) =>
            value?.isEmpty ?? true ? "Kode Produk harus diisi" : null,
      );

  Widget _namaTextField() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Nama Produk",
        ),
        keyboardType: TextInputType.text,
        controller: _namaController,
        validator: (value) =>
            value?.isEmpty ?? true ? "Nama Produk harus diisi" : null,
      );

  Widget _hargaTextField() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Harga Produk",
        ),
        keyboardType: TextInputType.number,
        controller: _hargaController,
        validator: (value) =>
            value?.isEmpty ?? true ? "Harga Produk harus diisi" : null,
      );

  Widget _buttonSubmit() => ElevatedButton(
        child: Text(tombolSubmit),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.produk != null) {
                _ubah();
              } else {
                _simpan();
              }
            }
          }
        },
      );

  void _simpan() {
    setState(() {
      _isLoading = true;
    });
    Produk createProduk = Produk(
      id: 0,
      kode: _kodeController.text,
      nama: _namaController.text,
      harga: int.parse(_hargaController.text),
    );
    ProdukBloc.addProduk(produk: createProduk).then(
      (value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => const ProdukPage(),
          ),
        );
      },
      onError: (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Simpan gagal, silahkan coba lagi",
          ),
        );
      },
    );
    setState(() {
      _isLoading = false;
    });
  }

  _ubah() {
    setState(() {
      _isLoading = true;
    });
    Produk updateProduk = Produk(
      id: widget.produk!.id,
      kode: _kodeController.text,
      nama: _namaController.text,
      harga: int.parse(_hargaController.text),
    );
    ProdukBloc.updateProduk(produk: updateProduk).then(
      (value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => const ProdukPage(),
          ),
        );
      },
      onError: (error) {
        print(error);
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Permintaan ubah data gagal, silahkan coba lagi",
          ),
        );
      },
    );
    setState(() {
      _isLoading = false;
    });
  }
}
