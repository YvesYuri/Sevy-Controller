import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../../data/models/room_model.dart';
import '../home_controller.dart';

class DeleteRoomWidget extends StatelessWidget {
  final RoomModel? room;
  const DeleteRoomWidget({super.key, this.room});

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
            title: const Text('Delete'),
            content:
                Text('Are you sure you want to delete room "${room!.name!}"?'),
            actions: [
              Button(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FilledButton(
                child: const Text('Delete'),
                onPressed: () async {
                  await homeController.deleteRoom(room!.id!);
                  if (homeController.deleteRoomState ==
                      DeleteRoomState.success) {
                    showMessage(context, 'Success', 'Room deleted successfully',
                        InfoBarSeverity.success);
                    Navigator.pop(context);
                  } else if (homeController.deleteRoomState ==
                      DeleteRoomState.error) {
                    showMessage(context, 'Error', 'Room not deleted',
                        InfoBarSeverity.error);
                  }
                },
              ),
            ],
          ),
          Visibility(
            visible: homeController.deleteRoomState == DeleteRoomState.loading,
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
