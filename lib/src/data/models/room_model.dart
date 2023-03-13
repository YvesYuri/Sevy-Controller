class RoomModel {
  String? id;
  String? name;
  String? cover;
  String? owner;

  RoomModel({this.id, this.name, this.cover, this.owner});

  RoomModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    owner = json['owner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    data['owner'] = owner;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'cover': cover,
      'owner': owner,
    };
    return map;
  }
}