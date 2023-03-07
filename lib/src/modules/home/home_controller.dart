import 'package:fluent_ui/fluent_ui.dart';

import '../../data/services/unsplash_service.dart';

enum HomeState {
  initial,
  loading,
  success,
  error,
}

enum NewRoomState {
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

class HomeController extends ChangeNotifier {
  final unsplashService = UnsplashService();

  var homeState = HomeState.initial;
  var newRoomState = NewRoomState.initial;
  var selectImageState = SelectImageState.initial;

  List<String> urlImages = [];
  TextEditingController searchImage = TextEditingController();
  String selectedImage = '';
  String storedImage = '';
  TextEditingController nameRoom = TextEditingController();

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

  void clearNewRoom() {
    nameRoom.clear();
    storedImage = '';
    notifyListeners();
  }

  Future<void> setNewRoom() async {
    newRoomState = NewRoomState.loading;
    notifyListeners();
    nameRoom.clear();
    await Future.delayed(const Duration(seconds: 1));
    storedImage = await unsplashService.getSingleRandomImage('living room');
    newRoomState = NewRoomState.success;
    notifyListeners();
  }
}
