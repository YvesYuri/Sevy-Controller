import 'dart:convert';

import 'package:http/http.dart' as http;

class UnsplashService {
  Future<String> getSingleRandomImage(String searchImage) async {
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/random?client_id=WwIS-hL8pbXSqW8q5ApGFL0h9WRRN_82asHryIyZV9o&query=$searchImage'));
    var imgData = json.decode(response.body);
    var result = imgData['urls']['thumb'].toString();
    return result;
  }

  Future<List<String>> getRandomImages() async {
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/random?client_id=WwIS-hL8pbXSqW8q5ApGFL0h9WRRN_82asHryIyZV9o&count=21'));
    List imgData = json.decode(response.body);
    var result = imgData.map((e) => e['urls']['thumb'].toString()).toList();
    return result;
  }

  Future<List<String>> getImages(String searchImage) async {
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/random?client_id=WwIS-hL8pbXSqW8q5ApGFL0h9WRRN_82asHryIyZV9o&query=$searchImage&count=21'));
    List imgData = json.decode(response.body);
    var result = imgData.map((e) => e['urls']['thumb'].toString()).toList();
    return result;
  }
}
