import 'dart:convert';

import 'package:auto_animated/auto_animated.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

import 'home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void showNewRoom() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HomeController>(
            builder: (context, homeController, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              ContentDialog(
                title: const Text('New Room'),
                content: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 20,
                        child: Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
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
                              showSelectImage();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 3,
                              ),
                              child: AutoSizeText(
                                "Name",
                                textAlign: TextAlign.center,
                                minFontSize: 1,
                                stepGranularity: 1,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextBox(
                              placeholder: 'Ex: Living Room',
                              expands: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Button(
                    child: const Text('Cancel'),
                    onPressed: () {
                      homeController.clearNewRoom();
                      Navigator.pop(context, 'User cancel new room');
                      // Delete file here
                    },
                  ),
                  FilledButton(
                    child: const Text('Add'),
                    onPressed: () {
                      Navigator.pop(context, 'User added new room');
                    },
                  ),
                ],
              ),
              Visibility(
                visible: homeController.newRoomState == NewRoomState.loading,
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
      },
    );
  }

  void showSelectImage() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HomeController>(
            builder: (context, homeController, child) {
          return Stack(
            children: [
              ContentDialog(
                constraints: const BoxConstraints.expand(
                  height: 600,
                  width: 800,
                ),
                title: const Text('Select Image'),
                content: Column(
                  children: [
                    Flexible(
                      flex: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 90,
                            child: TextBox(
                              controller: homeController.searchImage,
                              placeholder: 'Ex: Living Room',
                              expands: false,
                              prefix: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  FluentIcons.search,
                                  color: SystemTheme.accentColor.accent,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 10,
                            child: FilledButton(
                                child: const AutoSizeText(
                                  "Search",
                                  textAlign: TextAlign.center,
                                  minFontSize: 1,
                                  stepGranularity: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                ),
                                onPressed: () async {
                                  await homeController.searchImages(
                                    homeController.searchImage.text,
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Flexible(
                      flex: 90,
                      child: LiveGrid.options(
                        itemBuilder: (context, index, animation) {
                          return FadeTransition(
                            opacity: Tween<double>(
                              begin: 0,
                              end: 1,
                            ).animate(animation),
                            child: GestureDetector(
                              onTap: () {
                                homeController.selectImage(
                                  homeController.urlImages[index],
                                );
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  height: double.maxFinite,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[170],
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        homeController.urlImages[index]
                                            .toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    border: homeController.selectedImage ==
                                            homeController.urlImages[index]
                                                .toString()
                                        ? Border.all(
                                            color:
                                                SystemTheme.accentColor.accent,
                                            width: 3,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 16 / 9,
                        ),
                        itemCount: homeController.urlImages.length,
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
                actions: [
                  Button(
                    child: const Text('Cancel'),
                    onPressed: () {
                      homeController.clearSelectImageForm();
                      Navigator.pop(context, 'User cancel select image');
                      // Delete file here
                    },
                  ),
                  FilledButton(
                    child: const Text('Select'),
                    onPressed: () {
                      homeController.storeImage();
                      Navigator.pop(context, 'User selected image');
                    },
                  ),
                ],
              ),
              Visibility(
                visible:
                    homeController.selectImageState == SelectImageState.loading,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    return ScaffoldPage(
      header: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Text(
          "Home",
          style: TextStyle(
            // color: Colors.white,
            fontSize: 20,
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
              horizontal: 9,
            ),
            child: CommandBar(
              mainAxisAlignment: MainAxisAlignment.start,
              overflowBehavior: CommandBarOverflowBehavior.dynamicOverflow,
              compactBreakpointWidth: 768,
              primaryItems: [
                CommandBarButton(
                  icon: Icon(FluentIcons.room,
                      color: SystemTheme.accentColor.accent),
                  label: const Text('New Room'),
                  onPressed: () {
                    homeController.setNewRoom();
                    showNewRoom();
                  },
                ),
                CommandBarButton(
                  icon: Icon(FluentIcons.lightbulb,
                      color: SystemTheme.accentColor.accent),
                  label: const Text('New Device'),
                  onPressed: () {},
                ),
                CommandBarButton(
                  icon: Icon(FluentIcons.sort,
                      color: SystemTheme.accentColor.accent),
                  label: const Text('Sort'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Flexible(
            flex: 15,
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
                      color: Colors.grey[170],
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Flexible(
                          flex: 70,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4)),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 30,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  "Room $index",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                ),
                                IconButton(
                                  icon: Icon(FluentIcons.more,
                                      color: SystemTheme.accentColor.accent),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 15,
                childAspectRatio: 10 / 15,
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
          const SizedBox(
            height: 15,
          ),
          Flexible(
            flex: 85,
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
                      color: SystemTheme.accentColor.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
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
                                          SystemTheme.accentColor.accent,
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
                                    child: AutoSizeText(
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
                horizontal: 15,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 100 / 35,
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
