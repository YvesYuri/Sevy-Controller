class UserModel {
  String? displayName;
  String? email;
  String? registerDate;

  UserModel({this.displayName, this.email, this.registerDate});

  UserModel.fromJson(Map<dynamic, dynamic> json) {
    displayName = json['displayName'];
    email = json['email'];
    registerDate = json['registerDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['displayName'] = displayName;
    data['email'] = email;
    data['registerDate'] = registerDate;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'register_date': registerDate,
    };
    return map;
  }
}