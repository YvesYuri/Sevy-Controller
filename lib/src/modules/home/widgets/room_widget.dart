import 'dart:convert';

import 'package:controller/src/modules/home/widgets/select_image_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../home_controller.dart';

class RoomWidget extends StatelessWidget {
  const RoomWidget({super.key});

  void showSelectImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const SelectImageWidget();
      },
    );
  }

  void showMessage(BuildContext context, String title, String message,
      InfoBarSeverity severity) {
    displayInfoBar(
      context,
      builder: (context, close) {
        return InfoBar(
          title: Text(title),
          content: Text(message),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: severity,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(builder: (context, homeController, child) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ContentDialog(
            title: Text(homeController.editIdRoom != '' ? 'Edit Room' : 'New Room'),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(
                  builder: (context) {
                    if (homeController.storedImage.length > 1000) {
                      return Container(
                        height: 60,
                        width: 60,
                        alignment: Alignment.bottomRight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: Image.memory(
                              base64Decode(homeController.storedImage),
                            ).image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: IconButton(
                          style: ButtonStyle(
                            backgroundColor: ButtonState.all(
                              Colors.black.withOpacity(0.5),
                            ),
                          ),
                          icon: const Icon(
                            FluentIcons.camera,
                            size: 16,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            homeController.getRandomImages();
                            showSelectImage(context);
                          },
                        ),
                      );
                    } else {
                      return Container(
                        height: 60,
                        width: 60,
                        alignment: Alignment.bottomRight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: NetworkImage(
                              homeController.storedImage,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: IconButton(
                          style: ButtonStyle(
                            backgroundColor: ButtonState.all(
                              Colors.black.withOpacity(0.5),
                            ),
                          ),
                          icon: const Icon(
                            FluentIcons.camera,
                            size: 16,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            homeController.getRandomImages();
                            showSelectImage(context);
                          },
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 3,
                        ),
                        child: Text(
                          "Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextBox(
                        controller: homeController.nameRoom,
                        placeholder: 'Ex: Living Room',
                        expands: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Button(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                  homeController.clearRoomForm();
                },
              ),
              FilledButton(
                child: Text(homeController.editIdRoom != '' ? 'Save' : 'Add'),
                onPressed: () async {
                  if (homeController.validateRoomForm()) {
                    if (homeController.editIdRoom != '') {
                      await homeController.updateRoom();
                      if (homeController.roomState == RoomState.success) {
                        showMessage(context, "Success", "room saved.",
                            InfoBarSeverity.success);
                        Navigator.pop(context);
                      } else {
                        showMessage(context, "Error", "an error occurred.",
                            InfoBarSeverity.error);
                      }
                    } else {
                      await homeController.createRoom();
                      if (homeController.roomState == RoomState.success) {
                        showMessage(context, "Success", "new room added.",
                            InfoBarSeverity.success);
                        Navigator.pop(context);
                      } else {
                        showMessage(context, "Error", "an error occurred.",
                            InfoBarSeverity.error);
                      }
                    }
                  } else {
                    showMessage(context, "Alert", "please fill the name field.",
                        InfoBarSeverity.warning);
                  }
                },
              ),
            ],
          ),
          Visibility(
            visible: homeController.roomState == RoomState.loading,
            child: Container(
              // height: 60,
              // width: 60,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                height: 60,
                width: 60,
                child: const FittedBox(
                  fit: BoxFit.fill,
                  child: ProgressRing(
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
