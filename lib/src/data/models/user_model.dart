class UserModel {
  String? displayName;
  String? email;

  UserModel({this.displayName, this.email});

  UserModel.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['displayName'] = displayName;
    data['email'] = email;
    return data;
  }
}