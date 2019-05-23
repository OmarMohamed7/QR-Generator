

class Autho {

  final String token;
  final String userId;

  Autho({this.token,this.userId});


  factory Autho.fromJson(Map<String, dynamic> json) {
    return Autho(
      token: json["token"],
      userId: json["userId"],
    );
  }
}
