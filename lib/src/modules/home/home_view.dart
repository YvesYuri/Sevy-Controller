import 'dart:convert';

import 'package:auto_animated/auto_animated.dart';
import 'package:controller/src/modules/home/widgets/delete_room_widget.dart';
import 'package:controller/src/modules/home/widgets/room_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:strings/strings.dart';

import '../../data/models/room_model.dart';
import 'home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void showRoom() {
    showDialog(
      context: context,
      builder: (context) {
        return const RoomWidget();
      },
    );
  }

  void showDeleteRoom(RoomModel room) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteRoomWidget(
          room: room,
        );
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
  void initState() {
    final homeController = Provider.of<HomeController>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await homeController.getRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    return ScaffoldPage(
      header: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Text(
          "Home",
          style: TextStyle(
            // color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // padding: const EdgeInsets.all(
      //   10,
      // ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: CommandBar(
              mainAxisAlignment: MainAxisAlignment.start,
              overflowBehavior: CommandBarOverflowBehavior.dynamicOverflow,
              compactBreakpointWidth: 768,
              primaryItems: [
                CommandBarButton(
                  icon: Icon(FluentIcons.room,
                      color: FluentTheme.of(context).accentColor),
                  label: const Text('New Room'),
                  onPressed: () {
                    homeController.setNewRoom();
                    showRoom();
                  },
                ),
                CommandBarButton(
                  icon: Icon(FluentIcons.lightbulb,
                      color: FluentTheme.of(context).accentColor),
                  label: const Text('New Device'),
                  onPressed: () {},
                ),
                CommandBarButton(
                  icon: Icon(FluentIcons.sort,
                      color: FluentTheme.of(context).accentColor),
                  label: const Text('Sort'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 78,
            width: double.maxFinite,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    homeController.clearCurrentRoom();
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: double.maxFinite,
                      width: 118,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: homeController.currentRoom == null
                            ? Border.all(
                                color: FluentTheme.of(context).accentColor,
                                width: 2,
                              )
                            : null,
                      ),
                      margin: const EdgeInsets.only(
                        left: 24,
                      ),
                      child: Column(
                        children: [
                          Flexible(
                            flex: 70,
                            child: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4)),
                              ),
                              child: Icon(
                                FluentIcons.lightbulb,
                                color: FluentTheme.of(context).accentColor,
                                size: 30,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 30,
                            child: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: const Text(
                                "All Devices",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: LiveGrid.options(
                    itemBuilder: (context, index, animation) {
                      var room = homeController.rooms[index];
                      return FadeTransition(
                        opacity: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(animation),
                        child: GestureDetector(
                          onTap: () {
                            homeController.setCurrentRoom(room.id!);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                border: homeController.currentRoom == room.id
                                    ? Border.all(
                                        color:
                                            FluentTheme.of(context).accentColor,
                                        width: 2,
                                      )
                                    : null,
                                image: DecorationImage(
                                  image: Image.memory(base64Decode(room.cover!))
                                      .image,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(
                                  5,
                                ),
                                decoration: BoxDecoration(
                                  color: FluentTheme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.7),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      capitalize(room.name!),
                                      style: const TextStyle(
                                        // color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                    ),
                                    material.Material(
                                      color: Colors.transparent,
                                      child: material.PopupMenuButton(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        color:
                                            FluentTheme.of(context).menuColor,
                                        // icon: const Icon(
                                        //   FluentIcons.more,
                                        //   size: 16,
                                        // ),
                                        splashRadius: 0,
                                        tooltip: "Options for this room",
                                        itemBuilder: (context) => [
                                          material.PopupMenuItem(
                                            height: 30,
                                            value: 1,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  FluentIcons.power_button,
                                                  size: 14,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Turn on all devices",
                                                  style: FluentTheme.of(context)
                                                      .typography
                                                      .body,
                                                ),
                                              ],
                                            ),
                                          ),
                                          material.PopupMenuItem(
                                            height: 30,
                                            value: 2,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  FluentIcons.power_button,
                                                  size: 14,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Turn off all devices",
                                                  style: FluentTheme.of(context)
                                                      .typography
                                                      .body,
                                                ),
                                              ],
                                            ),
                                          ),
                                          material.PopupMenuItem(
                                            height: 30,
                                            value: 3,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  FluentIcons.edit,
                                                  size: 14,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Edit",
                                                  style: FluentTheme.of(context)
                                                      .typography
                                                      .body,
                                                ),
                                              ],
                                            ),
                                          ),
                                          material.PopupMenuItem(
                                            height: 30,
                                            value: 4,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  FluentIcons.delete,
                                                  size: 14,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Delete",
                                                  style: FluentTheme.of(context)
                                                      .typography
                                                      .body,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        onSelected: (value) {
                                          if (value == 1) {
                                          } else if (value == 2) {
                                          } else if (value == 3) {
                                            homeController.setEditRoom(room);
                                            showRoom();
                                          } else if (value == 4) {
                                            showDeleteRoom(room);
                                          }
                                        },
                                        child: const Icon(
                                          FluentIcons.more,
                                          size: 18,
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: homeController.rooms.isNotEmpty
                        ? Axis.horizontal
                        : Axis.vertical,
                    padding: const EdgeInsets.only(
                      right: 24,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisSpacing: 15,
                      maxCrossAxisExtent: 100,
                      childAspectRatio: 10 / 15,
                    ),
                    itemCount: homeController.rooms.length,
                    options: const LiveOptions(
                      delay: Duration(milliseconds: 250),
                      showItemInterval: Duration(milliseconds: 125),
                      showItemDuration: Duration(milliseconds: 250),
                      visibleFraction: 0.02,
                      reAnimateOnVisibility: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: LiveGrid.options(
              itemBuilder: (context, index, animation) {
                return FadeTransition(
                  opacity: Tween<double>(
                    begin: 0,
                    end: 1,
                  ).animate(animation),
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color:
                          FluentTheme.of(context).accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 0,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Flexible(
                          flex: 70,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 20,
                                  child: Container(
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor:
                                          FluentTheme.of(context).accentColor,
                                      child: const Icon(
                                        FluentIcons.lightbulb_solid,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 60,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Device $index",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 20,
                                  child: Container(
                                    height: 24,
                                    width: 44,
                                    alignment: Alignment.center,
                                    child: ToggleSwitch(
                                      thumbBuilder: (context, states) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                            right: 2,
                                            left: 2,
                                          ),
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      checked: true,
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 30,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Slider(
                              value: 50,
                              style: SliderThemeData(
                                thumbRadius: ButtonState.all(
                                  0,
                                ),
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 200 / 70,
                maxCrossAxisExtent: 300,
              ),
              itemCount: 6,
              options: const LiveOptions(
                delay: Duration(milliseconds: 250),
                showItemInterval: Duration(milliseconds: 125),
                showItemDuration: Duration(milliseconds: 250),
                visibleFraction: 0.02,
                reAnimateOnVisibility: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
