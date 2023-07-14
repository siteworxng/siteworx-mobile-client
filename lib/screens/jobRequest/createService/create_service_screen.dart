import 'dart:convert';
import 'dart:io';

import 'package:client/component/base_scaffold_widget.dart';
import 'package:client/component/cached_image_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/category_model.dart';
import 'package:client/model/service_data_model.dart';
import 'package:client/network/network_utils.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/images.dart';
import 'package:client/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class CreateServiceScreen extends StatefulWidget {
  final ServiceData? data;

  CreateServiceScreen({this.data});

  @override
  _CreateServiceScreenState createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ImagePicker picker = ImagePicker();

  TextEditingController serviceNameCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode serviceNameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  List<XFile> imageFiles = [];
  List<String> typeList = [SERVICE_TYPE_FIXED, SERVICE_TYPE_HOURLY];
  List<CategoryData> categoryList = [];

  CategoryData? selectedCategory;
  String serviceType = '';

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.data != null;

    if (isUpdate) {
      serviceNameCont.text = widget.data!.name.validate();
      descriptionCont.text = widget.data!.description.validate();
      imageFiles.addAll(widget.data!.attachments!.map((e) => XFile(e.validate().toString())));
    }
    await getCategoryData();
  }

  Future<void> getCategoryData() async {
    appStore.setLoading(true);
    await getCategoryList(CATEGORY_LIST_ALL).then((value) {
      if (value.categoryList!.isNotEmpty) {
        categoryList.addAll(value.categoryList.validate());
      }

      if (isUpdate) {
        selectedCategory = value.categoryList!.firstWhere((element) => element.id == widget.data!.categoryId.validate());
      }

      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> getMultipleFile() async {
    await picker.pickMultiImage().then((value) {
      imageFiles.addAll(value);
      setState(() {});
    });
  }

  Future<void> createServiceRequest() async {
    appStore.setLoading(true);

    MultipartRequest multiPartRequest = await getMultiPartRequest('service-save');
    multiPartRequest.fields[CreateService.name] = serviceNameCont.text.validate();
    multiPartRequest.fields[CreateService.description] = descriptionCont.text.validate();
    multiPartRequest.fields[CreateService.type] = SERVICE_TYPE_FIXED;
    multiPartRequest.fields[CreateService.price] = '0';
    multiPartRequest.fields[CreateService.addedBy] = appStore.userId.toString().validate();
    multiPartRequest.fields[CreateService.providerId] = appStore.userId.toString();
    multiPartRequest.fields[CreateService.categoryId] = selectedCategory!.id.toString();
    multiPartRequest.fields[CreateService.status] = '1';
    multiPartRequest.fields[CreateService.duration] = "0";

    log("multiPart Request: ${multiPartRequest.fields}");

    if (isUpdate) {
      multiPartRequest.fields[CreateService.id] = widget.data!.id.validate().toString();
    }

    if (imageFiles.isNotEmpty) {
      List<XFile> tempImages = imageFiles.where((element) => !element.path.contains("https")).toList();

      multiPartRequest.files.clear();
      await Future.forEach<XFile>(tempImages, (element) async {
        int i = tempImages.indexOf(element);
        multiPartRequest.files.add(await MultipartFile.fromPath('${CreateService.serviceAttachment + i.toString()}', element.path));
      });

      if (tempImages.isNotEmpty) multiPartRequest.fields[CreateService.attachmentCount] = tempImages.length.toString();
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        toast(jsonDecode(data)['message'], print: true);

        finish(context, true);
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

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.createServiceRequest,
      child: AnimatedScrollView(
        padding: EdgeInsets.all(16),
        listAnimationType: ListAnimationType.FadeIn,
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        children: [
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: context.width(),
                  height: 120,
                  child: DottedBorderWidget(
                    color: primaryColor.withOpacity(0.6),
                    strokeWidth: 1,
                    gap: 6,
                    radius: 12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(selectImage, height: 25, width: 25, color: appStore.isDarkMode ? white : gray),
                        8.height,
                        Text(language.chooseImages, style: boldTextStyle()),
                      ],
                    ).center().onTap(borderRadius: radius(), () async {
                      getMultipleFile();
                    }),
                  ),
                ),
                HorizontalList(
                  itemCount: imageFiles.length,
                  itemBuilder: (context, i) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        if (imageFiles[i].path.contains("https"))
                          CachedImageWidget(url: imageFiles[i].path, height: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(16)
                        else
                          Image.file(File(imageFiles[i].path), width: 90, height: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(16),
                        Container(
                          decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: primaryColor),
                          margin: EdgeInsets.only(right: 8, top: 4),
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, size: 16, color: white),
                        ).onTap(() {
                          imageFiles.removeAt(i);
                          setState(() {});
                        }),
                      ],
                    );
                  },
                ).paddingBottom(16).visible(imageFiles.isNotEmpty),
                20.height,
                DropdownButtonFormField<CategoryData>(
                  decoration: inputDecoration(context, labelText: language.lblCategory),
                  hint: Text(language.selectCategory, style: secondaryTextStyle()),
                  value: selectedCategory,
                  validator: (value) {
                    if (value == null) return errorThisFieldRequired;

                    return null;
                  },
                  dropdownColor: context.scaffoldBackgroundColor,
                  items: categoryList.map((data) {
                    return DropdownMenuItem<CategoryData>(
                      value: data,
                      child: Text(data.name.validate(), style: primaryTextStyle()),
                    );
                  }).toList(),
                  onChanged: isUpdate
                      ? null
                      : (CategoryData? value) async {
                          selectedCategory = value!;
                          setState(() {});
                        },
                ),
                16.height,
                AppTextField(
                  controller: serviceNameCont,
                  textFieldType: TextFieldType.NAME,
                  nextFocus: descriptionFocus,
                  errorThisFieldRequired: language.requiredText,
                  decoration: inputDecoration(context, labelText: language.serviceName),
                ),
                16.height,
                AppTextField(
                  controller: descriptionCont,
                  textFieldType: TextFieldType.MULTILINE,
                  errorThisFieldRequired: language.requiredText,
                  maxLines: 2,
                  focus: descriptionFocus,
                  decoration: inputDecoration(context, labelText: language.serviceDescription),
                  validator: (value) {
                    if (value!.isEmpty) return language.requiredText;
                    return null;
                  },
                ),
                16.height,
                AppButton(
                  text: isUpdate ? language.lblUpdate : language.save,
                  color: context.primaryColor,
                  width: context.width(),
                  onTap: () {
                    hideKeyboard(context);

                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      ///Image file field is required
                      if (imageFiles.isEmpty) {
                        return toast(language.pleaseAddImage);
                      }

                      showConfirmDialogCustom(
                        context,
                        title: "${language.lblAreYouSureWant} ${isUpdate ? language.lblUpdate : language.lblAdd} ${language.lblThisService}?",
                        positiveText: language.lblYes,
                        negativeText: language.lblNo,
                        primaryColor: primaryColor,
                        onAccept: (p0) {
                          createServiceRequest();
                        },
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
