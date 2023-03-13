import 'dart:convert';

import 'package:controller/src/data/models/room_model.dart';
import 'package:controller/src/data/services/authentication_service.dart';
import 'package:controller/src/data/services/database_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../../data/services/unsplash_service.dart';

enum HomeState {
  initial,
  loading,
  success,
  error,
}

enum RoomState {
  initial,
  loading,
  success,
  error,
}

enum SelectImageState {
  initial,
  loading,
  success,
  error,
}

enum DeleteRoomState {
  initial,
  loading,
  success,
  error,
}

class HomeController extends ChangeNotifier {
  final unsplashService = UnsplashService();

  var homeState = HomeState.initial;
  var roomState = RoomState.initial;
  var deleteRoomState = DeleteRoomState.initial;
  var selectImageState = SelectImageState.initial;

  List<String> urlImages = [];
  TextEditingController searchImage = TextEditingController();
  String selectedImage = '';
  String storedImage = '';
  TextEditingController nameRoom = TextEditingController();
  List<RoomModel> rooms = [];
  FlyoutController menuController = FlyoutController();
  String editIdRoom = '';
  String? currentRoom;

  Future<void> getRandomImages() async {
    selectImageState = SelectImageState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    urlImages = await unsplashService.getRandomImages();
    selectImageState = SelectImageState.success;
    notifyListeners();
  }

  Future<void> searchImages(String searchImage) async {
    selectImageState = SelectImageState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    urlImages = await unsplashService.getImages(searchImage);
    selectImageState = SelectImageState.success;
    notifyListeners();
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : "");
  }

  void selectImage(String url) {
    selectedImage = url;
    notifyListeners();
  }

  void clearSelectImageForm() {
    selectedImage = '';
    searchImage.clear();
    notifyListeners();
  }

  void storeImage() {
    storedImage = selectedImage;
    notifyListeners();
  }

  void clearRoomForm() {
    nameRoom.clear();
    storedImage = '';
    notifyListeners();
  }

  bool validateRoomForm() {
    if (nameRoom.text.isEmpty) {
      return false;
    }
    if (storedImage.isEmpty) {
      return false;
    }
    return true;
  }

  bool validateSelectImageForm() {
    print(selectedImage);
    if (selectedImage.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> setNewRoom() async {
    roomState = RoomState.loading;
    notifyListeners();
    editIdRoom = '';
    nameRoom.clear();
    await Future.delayed(const Duration(seconds: 1));
    storedImage = await unsplashService.getSingleRandomImage('living room');
    roomState = RoomState.success;
    notifyListeners();
  }

  void setEditRoom(RoomModel room) {
    editIdRoom = room.id!;
    nameRoom.text = room.name!;
    storedImage = room.cover!;
    notifyListeners();
  }

  Future<void> createRoom() async {
    roomState = RoomState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    var currentUser = await AuthenticationService.instance.getCurrentUser();
    var cover = await networkImageToBase64(storedImage);
    try {
      await DatabaseService.instance.createRoom(
        RoomModel(
          id: Uuid().v4(),
          name: nameRoom.text,
          cover: cover,
          owner: currentUser.email,
        ),
      );
      clearSelectImageForm();
      clearRoomForm();
      await getRooms();
      roomState = RoomState.success;
    } catch (e) {
      roomState = RoomState.error;
    }
    notifyListeners();
  }

  Future<void> updateRoom() async {
    roomState = RoomState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    var currenUser = await AuthenticationService.instance.getCurrentUser();
    String cover;
    if (storedImage.length > 1000) {
      cover = storedImage;
    } else {
      cover = await networkImageToBase64(storedImage);
    }
    try {
      await DatabaseService.instance.updateRoom(
        RoomModel(
          id: editIdRoom,
          name: nameRoom.text,
          cover: cover,
          owner: currenUser.email,
        ),
      );
      clearSelectImageForm();
      clearRoomForm();
      await getRooms();
      roomState = RoomState.success;
    } catch (e) {
      roomState = RoomState.error;
    }
    notifyListeners();
  }

  Future<void> getRooms() async {
    homeState = HomeState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      rooms = await DatabaseService.instance.readRooms();
      homeState = HomeState.success;
    } catch (e) {
      homeState = HomeState.error;
    }
    notifyListeners();
  }

  Future<void> deleteRoom(String id) async {
    deleteRoomState = DeleteRoomState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      await DatabaseService.instance.deleteRoom(id);
      await getRooms();
      deleteRoomState = DeleteRoomState.success;
    } catch (e) {
      deleteRoomState = DeleteRoomState.error;
    }
    notifyListeners();
  }

  void setCurrentRoom(String id) {
    currentRoom = id;
    notifyListeners();
  }

  void clearCurrentRoom() {
    currentRoom = null;
    notifyListeners();
  }
}
