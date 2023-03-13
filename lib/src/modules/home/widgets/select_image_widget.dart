import 'package:auto_animated/auto_animated.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../home_controller.dart';

class SelectImageWidget extends StatelessWidget {
  const SelectImageWidget({super.key});

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
        children: [
          ContentDialog(
            constraints: const BoxConstraints.expand(
              height: 600,
              width: 800,
            ),
            title: const Text('Select Image'),
            content: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextBox(
                        controller: homeController.searchImage,
                        placeholder: 'Ex: Living Room',
                        expands: false,
                        prefix: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            FluentIcons.search,
                            color: FluentTheme.of(context).accentColor,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FilledButton(
                        child: Text(
                          "Search",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: FluentTheme.of(context).brightness ==
                                    Brightness.light
                                ? Colors.white
                                : Colors.black,
                          ),
                          maxLines: 1,
                        ),
                        onPressed: () async {
                          await homeController.searchImages(
                            homeController.searchImage.text,
                          );
                        }),
                  ],
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
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    homeController.urlImages[index].toString(),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 0,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                                border: homeController.selectedImage ==
                                        homeController.urlImages[index]
                                            .toString()
                                    ? Border.all(
                                        color:
                                            FluentTheme.of(context).accentColor,
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
                  Navigator.pop(context);
                  // Delete file here
                },
              ),
              FilledButton(
                child: const Text('Select'),
                onPressed: () {
                  if (homeController.validateSelectImageForm()) {
                    homeController.storeImage();
                    Navigator.pop(context);
                  } else {
                    showMessage(
                      context,
                      'Alert',
                      'please select an image.',
                      InfoBarSeverity.warning,
                    );
                  }
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
  }
}
