import 'dart:convert';
import 'dart:io';

import 'package:client/component/base_scaffold_widget.dart';
import 'package:client/component/cached_image_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/city_list_model.dart';
import 'package:client/model/country_list_model.dart';
import 'package:client/model/login_model.dart';
import 'package:client/model/state_list_model.dart';
import 'package:client/network/network_utils.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/images.dart';
import 'package:client/utils/model_keys.dart';
import 'package:client/utils/string_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? imageFile;
  XFile? pickedFile;

  List<CountryListResponse> countryList = [];
  List<StateListResponse> stateList = [];
  List<CityListResponse> cityList = [];

  CountryListResponse? selectedCountry;
  StateListResponse? selectedState;
  CityListResponse? selectedCity;

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();

  int countryId = 0;
  int stateId = 0;
  int cityId = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });

    countryId = getIntAsync(COUNTRY_ID).validate();
    stateId = getIntAsync(STATE_ID).validate();
    cityId = getIntAsync(CITY_ID).validate();

    fNameCont.text = appStore.userFirstName.validate();
    lNameCont.text = appStore.userLastName.validate();
    emailCont.text = appStore.userEmail.validate();
    userNameCont.text = appStore.userName.validate();
    mobileCont.text = '${appStore.userContactNumber.validate()}';
    countryId = appStore.countryId.validate();
    stateId = appStore.stateId.validate();
    cityId = appStore.cityId.validate();
    addressCont.text = appStore.address.validate();

    if (getIntAsync(COUNTRY_ID) != 0) {
      await getCountry();
      await getStates(getIntAsync(COUNTRY_ID));
      if (getIntAsync(STATE_ID) != 0) {
        await getCity(getIntAsync(STATE_ID));
      }

      setState(() {});
    } else {
      await getCountry();
    }
  }

  Future<void> getCountry() async {
    await getCountryList().then((value) async {
      countryList.clear();
      countryList.addAll(value);
      setState(() {});
      value.forEach((e) {
        if (e.id == getIntAsync(COUNTRY_ID)) {
          selectedCountry = e;
        }
      });
    }).catchError((e) {
      toast('$e', print: true);
    });
    appStore.setLoading(false);
  }

  Future<void> getStates(int countryId) async {
    appStore.setLoading(true);
    await getStateList({UserKeys.countryId: countryId}).then((value) async {
      stateList.clear();
      stateList.addAll(value);
      log(stateList);
      value.forEach((e) {
        if (e.id == getIntAsync(STATE_ID)) {
          selectedState = e;
        }
      });
      setState(() {});
    }).catchError((e) {
      toast('$e', print: true);
    });
    appStore.setLoading(false);
  }

  Future<void> getCity(int stateId) async {
    appStore.setLoading(true);

    await getCityList({UserKeys.stateId: stateId}).then((value) async {
      cityList.clear();
      cityList.addAll(value);
      value.forEach((e) {
        if (e.id == getIntAsync(CITY_ID)) {
          selectedCity = e;
        }
      });
    }).catchError((e) {
      toast('$e', print: true);
    });
    appStore.setLoading(false);
  }

  Future<void> update() async {
    hideKeyboard(context);

    MultipartRequest multiPartRequest = await getMultiPartRequest('update-profile');
    multiPartRequest.fields[UserKeys.firstName] = fNameCont.text;
    multiPartRequest.fields[UserKeys.lastName] = lNameCont.text;
    multiPartRequest.fields[UserKeys.userName] = userNameCont.text;
    multiPartRequest.fields[UserKeys.userType] = LOGIN_TYPE_USER;
    multiPartRequest.fields[UserKeys.contactNumber] = mobileCont.text;
    multiPartRequest.fields[UserKeys.email] = emailCont.text;
    multiPartRequest.fields[UserKeys.countryId] = countryId.toString();
    multiPartRequest.fields[UserKeys.stateId] = stateId.toString();
    multiPartRequest.fields[UserKeys.cityId] = cityId.toString();
    multiPartRequest.fields[CommonKeys.address] = addressCont.text;
    multiPartRequest.fields[UserKeys.displayName] = '${fNameCont.text.validate() + " " + lNameCont.text.validate()}';
    if (imageFile != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath(UserKeys.profileImage, imageFile!.path));
    } else {
      Image.asset(ic_home, fit: BoxFit.cover);
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());
    appStore.setLoading(true);

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        if (data != null) {
          if ((data as String).isJson()) {
            LoginResponse res = LoginResponse.fromJson(jsonDecode(data));

            saveUserData(res.userData!);
            finish(context);
            toast(res.message.validate().capitalizeFirstLetter());
          }
        }
      },
      onError: (error) {
        toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  void _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
      setState(() {});
    }
  }

  _getFromCamera() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
      setState(() {});
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: language.lblGallery,
              leading: Icon(Icons.image, color: primaryColor),
              onTap: () {
                _getFromGallery();
                finish(context);
              },
            ),
            Divider(color: context.dividerColor),
            SettingItemWidget(
              title: language.camera,
              leading: Icon(Icons.camera, color: primaryColor),
              onTap: () {
                _getFromCamera();
                finish(context);
              },
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.editProfile,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: boxDecorationDefault(
                      border: Border.all(color: context.scaffoldBackgroundColor, width: 4),
                      shape: BoxShape.circle,
                    ),
                    child: imageFile != null
                        ? Image.file(
                            imageFile!,
                            width: 85,
                            height: 85,
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRect(40)
                        : Observer(
                            builder: (_) => CachedImageWidget(
                              url: appStore.userProfileImage,
                              height: 85,
                              width: 85,
                              fit: BoxFit.cover,
                              radius: 43,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: boxDecorationWithRoundedCorners(
                        boxShape: BoxShape.circle,
                        backgroundColor: primaryColor,
                        border: Border.all(color: Colors.white),
                      ),
                      child: Icon(AntDesign.camera, color: Colors.white, size: 12),
                    ).onTap(() async {
                      _showBottomSheet(context);
                    }),
                  ).visible(!isLoginTypeGoogle && !isLoginTypeApple)
                ],
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: fNameCont,
                focus: fNameFocus,
                errorThisFieldRequired: language.requiredText,
                nextFocus: lNameFocus,
                enabled: !isLoginTypeApple,
                decoration: inputDecoration(context, labelText: language.hintFirstNameTxt),
                suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: lNameCont,
                focus: lNameFocus,
                errorThisFieldRequired: language.requiredText,
                nextFocus: userNameFocus,
                enabled: !isLoginTypeApple,
                decoration: inputDecoration(context, labelText: language.hintLastNameTxt),
                suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: userNameCont,
                focus: userNameFocus,
                enabled: false,
                errorThisFieldRequired: language.requiredText,
                nextFocus: emailFocus,
                decoration: inputDecoration(context, labelText: language.hintUserNameTxt),
                suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.EMAIL_ENHANCED,
                controller: emailCont,
                errorThisFieldRequired: language.requiredText,
                focus: emailFocus,
                enabled: false,
                nextFocus: mobileFocus,
                decoration: inputDecoration(context, labelText: language.hintEmailTxt),
                suffix: ic_message.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: isAndroid ? TextFieldType.PHONE : TextFieldType.NAME,
                controller: mobileCont,
                focus: mobileFocus,
                maxLength: 13,
                buildCounter: (_, {required int currentLength, required bool isFocused, required int? maxLength}) {
                  return Offstage();
                },
                enabled: !isLoginTypeOTP,
                errorThisFieldRequired: language.requiredText,
                decoration: inputDecoration(context, labelText: language.hintContactNumberTxt),
                suffix: ic_calling.iconImage(size: 10).paddingAll(14),
                validator: (mobileCont) {
                  if (mobileCont!.isEmpty) return language.phnRequiredText;
                  if (isIOS && !RegExp(r"^([0-9]{1,5})-([0-9]{1,10})$").hasMatch(mobileCont)) {
                    return language.inputMustBeNumberOrDigit;
                  }
                  if (!mobileCont.trim().contains('-')) return '"-" ${language.requiredAfterCountryCode}';
                  return null;
                },
              ),
              4.height,
              Align(
                alignment: Alignment.topRight,
                child: mobileNumberInfoWidget(),
              ),
              16.height,
              Row(
                children: [
                  DropdownButtonFormField<CountryListResponse>(
                    decoration: inputDecoration(context, labelText: language.selectCountry),
                    isExpanded: true,
                    value: selectedCountry,
                    dropdownColor: context.cardColor,
                    items: countryList.map((CountryListResponse e) {
                      return DropdownMenuItem<CountryListResponse>(
                        value: e,
                        child: Text(
                          e.name!,
                          style: primaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (CountryListResponse? value) async {
                      hideKeyboard(context);
                      countryId = value!.id!;
                      selectedCountry = value;
                      selectedState = null;
                      selectedCity = null;
                      getStates(value.id!);

                      setState(() {});
                    },
                  ).expand(),
                  8.width.visible(stateList.isNotEmpty),
                  if (stateList.isNotEmpty)
                    DropdownButtonFormField<StateListResponse>(
                      decoration: inputDecoration(context, labelText: language.selectState),
                      isExpanded: true,
                      dropdownColor: context.cardColor,
                      value: selectedState,
                      items: stateList.map((StateListResponse e) {
                        return DropdownMenuItem<StateListResponse>(
                          value: e,
                          child: Text(
                            e.name!,
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (StateListResponse? value) async {
                        hideKeyboard(context);
                        selectedCity = null;
                        selectedState = value;
                        stateId = value!.id!;
                        await getCity(value.id!);
                        setState(() {});
                      },
                    ).expand(),
                ],
              ),
              16.height,
              if (cityList.isNotEmpty)
                DropdownButtonFormField<CityListResponse>(
                  decoration: inputDecoration(context, labelText: language.selectCity),
                  isExpanded: true,
                  value: selectedCity,
                  dropdownColor: context.cardColor,
                  items: cityList.map((CityListResponse e) {
                    return DropdownMenuItem<CityListResponse>(
                      value: e,
                      child: Text(e.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (CityListResponse? value) async {
                    hideKeyboard(context);
                    selectedCity = value;
                    cityId = value!.id!;
                    setState(() {});
                  },
                ),
              16.height,
              AppTextField(
                controller: addressCont,
                textFieldType: TextFieldType.MULTILINE,
                maxLines: 5,
                //minLines: 3,
                decoration: inputDecoration(context, labelText: language.hintAddress),
                suffix: ic_location.iconImage(size: 10).paddingAll(14),
                isValidationRequired: false,
              ),
              40.height,
              AppButton(
                text: language.save,
                color: primaryColor,
                textColor: white,
                width: context.width() - context.navigationBarHeight,
                onTap: () {
                  ifNotTester(() {
                    update();
                  });
                },
              ),
              24.height,
            ],
          ),
        ),
      ),
    );
  }
}
