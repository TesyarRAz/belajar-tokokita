class Registrasi {
  int code;
  bool status;
  String data;

  Registrasi({
    required this.code,
    required this.status,
    required this.data,
  });

  factory Registrasi.fromJson(Map<String, dynamic> map) {
    return Registrasi(
      code: map['code'],
      status: map['status'],
      data: map['data'],
    );
  }
}
