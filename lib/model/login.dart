class Login {
  int code;
  bool status;
  String token;
  int userId;
  String userEmail;

  Login({
    required this.code,
    required this.status,
    required this.token,
    required this.userId,
    required this.userEmail,
  });

  factory Login.fromJson(Map<String, dynamic> map) {
    return Login(
      code: map['code'],
      status: map['status'],
      token: map['data']['token'],
      userId: map['data']['user']['id'],
      userEmail: map['data']['user']['email'],
    );
  }
}
