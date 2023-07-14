import 'package:client/app_theme.dart';
import 'package:client/component/custom_stepper.dart';
import 'package:client/component/loader_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/service_detail_response.dart';
import 'package:client/screens/map/map_screen.dart';
import 'package:client/services/location_service.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/images.dart';
import 'package:client/utils/permissions.dart';
import 'package:client/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingServiceStep2 extends StatefulWidget {
  final ServiceDetailResponse data;
  final bool? isSlotAvailable;

  BookingServiceStep2({required this.data, this.isSlotAvailable});

  @override
  _BookingServiceStep2State createState() => _BookingServiceStep2State();
}

class _BookingServiceStep2State extends State<BookingServiceStep2> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController dateTimeCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  DateTime currentDateTime = DateTime.now();
  DateTime? selectedDate;
  DateTime? finalDate;
  TimeOfDay? pickedTime;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.data.serviceDetail!.dateTimeVal != null) {
      if (widget.isSlotAvailable.validate()) {
        dateTimeCont.text = formatDate(widget.data.serviceDetail!.dateTimeVal.validate(), format: DATE_FORMAT_1);
        selectedDate = DateTime.parse(widget.data.serviceDetail!.dateTimeVal.validate());
        pickedTime = TimeOfDay.fromDateTime(selectedDate!);
      }
      addressCont.text = widget.data.serviceDetail!.address.validate();
    }
  }

  void selectDateAndTime(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: selectedDate ?? currentDateTime,
      firstDate: currentDateTime,
      lastDate: currentDateTime.add(30.days),
      locale: Locale(appStore.selectedLanguageCode),
      cancelText: language.lblCancel,
      confirmText: language.lblOk,
      helpText: language.lblSelectDate,
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
          child: child!,
        );
      },
    ).then((date) async {
      if (date != null) {
        await showTimePicker(
          context: context,
          initialTime: pickedTime ?? TimeOfDay.now(),
          cancelText: language.lblCancel,
          confirmText: language.lblOk,
          builder: (_, child) {
            return Theme(
              data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
              child: child!,
            );
          },
        ).then((time) {
          if (time != null) {
            finalDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);

            DateTime now = DateTime.now().subtract(1.minutes);
            if (date.isToday && finalDate!.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
              return toast(language.selectedOtherBookingTime);
            }

            selectedDate = date;
            pickedTime = time;
            widget.data.serviceDetail!.dateTimeVal = finalDate.toString();
            dateTimeCont.text = "${formatDate(selectedDate.toString(), format: DATE_FORMAT_3)} ${pickedTime!.format(context).toString()}";
          }
        }).catchError((e) {
          toast(e.toString());
        });
      }
    });
  }

  void _handleSetLocationClick() {
    Permissions.cameraFilesAndLocationPermissionsGranted().then((value) async {
      await setValue(PERMISSION_STATUS, value);

      if (value) {
        String? res = await MapScreen(latitude: getDoubleAsync(LATITUDE), latLong: getDoubleAsync(LONGITUDE)).launch(context);

        if (res != null) {
          addressCont.text = res;
          setState(() {});
        }
      }
    });
  }

  void _handleCurrentLocationClick() {
    Permissions.cameraFilesAndLocationPermissionsGranted().then((value) async {
      await setValue(PERMISSION_STATUS, value);

      if (value) {
        appStore.setLoading(true);

        await getUserLocation().then((value) {
          addressCont.text = value;
          widget.data.serviceDetail!.address = value.toString();
          setState(() {});
        }).catchError((e) {
          log(e);
          toast(e.toString());
        });

        appStore.setLoading(false);
      }
    }).catchError((e) {
      //
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 24, right: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Text(language.lblStepper1Title, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                20.height,
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Container(
                    decoration: boxDecorationDefault(color: context.cardColor),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.isSlotAvailable.validate(value: true))
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.lblDateAndTime, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                              8.height,
                              AppTextField(
                                textFieldType: TextFieldType.OTHER,
                                controller: dateTimeCont,
                                isValidationRequired: true,
                                validator: (value) {
                                  if (value!.isEmpty) return language.requiredText;
                                  return null;
                                },
                                readOnly: true,
                                onTap: () {
                                  selectDateAndTime(context);
                                },
                                decoration: inputDecoration(context, prefixIcon: ic_calendar.iconImage(size: 10).paddingAll(14)).copyWith(
                                  fillColor: context.scaffoldBackgroundColor,
                                  filled: true,
                                  hintText: language.lblEnterDateAndTime,
                                  hintStyle: secondaryTextStyle(),
                                ),
                              ),
                              20.height,
                            ],
                          ),
                        Text(language.lblYourAddress, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                        8.height,
                        AppTextField(
                          textFieldType: TextFieldType.MULTILINE,
                          controller: addressCont,
                          maxLines: 2,
                          onFieldSubmitted: (s) {
                            widget.data.serviceDetail!.address = s;
                          },
                          decoration: inputDecoration(
                            context,
                            prefixIcon: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ic_location.iconImage(size: 22).paddingOnly(top: 8),
                              ],
                            ),
                          ).copyWith(
                            fillColor: context.scaffoldBackgroundColor,
                            filled: true,
                            hintText: language.lblEnterYourAddress,
                            hintStyle: secondaryTextStyle(),
                          ),
                        ),
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: Text(language.lblChooseFromMap, style: boldTextStyle(color: primaryColor, size: 13)),
                              onPressed: () {
                                _handleSetLocationClick();
                              },
                            ).flexible(),
                            TextButton(
                              onPressed: _handleCurrentLocationClick,
                              child: Text(language.lblUseCurrentLocation, style: boldTextStyle(color: primaryColor, size: 13),textAlign: TextAlign.right),
                            ).flexible(),
                          ],
                        ),
                        16.height,
                        Text("${language.hintDescription}:", style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                        8.height,
                        AppTextField(
                          textFieldType: TextFieldType.MULTILINE,
                          controller: descriptionCont,
                          maxLines: 10,
                          minLines: 4,
                          isValidationRequired: false,
                          onFieldSubmitted: (s) {
                            widget.data.serviceDetail!.bookingDescription = s;
                          },
                          decoration: inputDecoration(context).copyWith(
                            fillColor: context.scaffoldBackgroundColor,
                            filled: true,
                            hintText: language.lblEnterDescription,
                            hintStyle: secondaryTextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                16.height,
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                if (!widget.isSlotAvailable.validate())
                  AppButton(
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
                    onTap: () {
                      customStepperController.previousPage(duration: 200.milliseconds, curve: Curves.easeInOut);
                    },
                    text: language.lblPrevious,
                    textColor: textPrimaryColorGlobal,
                  ).expand(),
                if (!widget.isSlotAvailable.validate()) 16.width,
                AppButton(
                  onTap: () {
                    hideKeyboard(context);
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      widget.data.serviceDetail!.bookingDescription = descriptionCont.text;
                      widget.data.serviceDetail!.address = addressCont.text;
                      customStepperController.nextPage(duration: 200.milliseconds, curve: Curves.easeOut);
                    }
                  },
                  text: language.btnNext,
                  textColor: Colors.white,
                  width: context.width(),
                  color: context.primaryColor,
                ).expand(),
              ],
            ),
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
