class Produk {
  int id;
  String kode;
  String nama;
  int harga;

  Produk({
    required this.id,
    required this.kode,
    required this.nama,
    required this.harga,
  });

  factory Produk.fromJson(Map<String, dynamic> map) {
    return Produk(
      id: map['id'],
      kode: map['kode_produk'],
      nama: map['nama_produk'],
      harga: map['harga'],
    );
  }
}
