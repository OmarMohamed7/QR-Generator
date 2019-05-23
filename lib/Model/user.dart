
class User{
  String _userID;
  String _userPassword;

  User(this._userID , this._userPassword);

  User.map(dynamic obj){
    this._userID = obj["email"];
    this._userPassword = obj["password"];
  }

  String get userID => _userID;
  String get userPassword => _userPassword;

  set userID(String val) => _userID = val;
  set userPassword(String val) => _userPassword = val;

  Map<String , dynamic> toMap(){
    var map = new Map<String , dynamic>();
    map["email"] = _userID;
    map["password"] = _userPassword;

    return map;
  }

}