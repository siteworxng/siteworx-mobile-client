import 'package:client/main.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ThemeSelectionDaiLog extends StatefulWidget {
  @override
  ThemeSelectionDaiLogState createState() => ThemeSelectionDaiLogState();
}

class ThemeSelectionDaiLogState extends State<ThemeSelectionDaiLog> {
  List<String> themeModeList = [language.appThemeLight, language.appThemeDark, language.appThemeDefault];

  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    currentIndex = getIntAsync(THEME_MODE_INDEX, defaultValue: THEME_MODE_SYSTEM);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              width: context.width(),
              decoration: boxDecorationDefault(
                color: context.primaryColor,
                borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.chooseTheme, style: boldTextStyle(color: Colors.white)).flexible(),
                  IconButton(
                    onPressed: () {
                      finish(context);
                    },
                    icon: Icon(Icons.close, color: white),
                  )
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: themeModeList.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile(
                  value: index,
                  activeColor: primaryColor,
                  groupValue: currentIndex,
                  title: Text(themeModeList[index], style: primaryTextStyle()),
                  onChanged: (dynamic val) async {
                    currentIndex = val;

                    if (val == THEME_MODE_SYSTEM) {
                      appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
                    } else if (val == THEME_MODE_LIGHT) {
                      appStore.setDarkMode(false);
                    } else if (val == THEME_MODE_DARK) {
                      appStore.setDarkMode(true);
                    }
                    await setValue(THEME_MODE_INDEX, val);
                    setState(() {});

                    finish(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
