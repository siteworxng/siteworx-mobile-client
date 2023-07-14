import 'dart:convert';
import 'dart:io';

import 'package:client/main.dart';
import 'package:client/screens/auth/sign_in_screen.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/configs.dart';
import 'package:client/utils/constant.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

Map<String, String> buildHeaderTokens({
  Map? extraKeys,
}) {
  /// Initialize & Handle if key is not present
  if (extraKeys == null) {
    extraKeys = {};
    extraKeys.putIfAbsent('isStripePayment', () => false);
    extraKeys.putIfAbsent('isFlutterWave', () => false);
    extraKeys.putIfAbsent('isSadadPayment', () => false);
  }

  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
  };

  if (appStore.isLoggedIn && extraKeys['isStripePayment']) {
    header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/x-www-form-urlencoded');
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${extraKeys!['stripeKeyPayment']}');
  } else if (appStore.isLoggedIn && extraKeys['isFlutterWave']) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer ${extraKeys!['flutterWaveSecretKey']}");
  } else if (appStore.isLoggedIn && extraKeys['isSadadPayment']) {
    header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json');
    if (extraKeys['sadadToken'].validate().isNotEmpty) header.putIfAbsent(HttpHeaders.authorizationHeader, () => extraKeys!['sadadToken']);
  } else {
    header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${appStore.token}');
    header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json; charset=utf-8');
  }

  log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$BASE_URL$endPoint');

  log('URL: ${url.toString()}');

  return url;
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  Map? extraKeys,
}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderTokens(extraKeys: extraKeys);
    Uri url = buildBaseUrl(endPoint);

    Response response;

    if (method == HttpMethodType.POST) {
      log('Request: ${jsonEncode(request)}');
      response = await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    log('Response (${method.name}) ${response.statusCode}: ${response.body}');

    return response;
  } else {
    throw errorInternetNotAvailable;
  }
}

Future handleResponse(Response response, {HttpResponseType httpResponseType = HttpResponseType.JSON, bool? avoidTokenError, bool? isSadadPayment}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  if (response.statusCode == 401) {
    if (!avoidTokenError.validate()) LiveStream().emit(LIVESTREAM_TOKEN, true);

    push(SignInScreen(isRegeneratingToken: true));
    throw '${language.lblTokenExpired}';
  } else if (response.statusCode == 400) {
    throw '${language.badRequest}';
  } else if (response.statusCode == 403) {
    throw '${language.forbidden}';
  } else if (response.statusCode == 404) {
    throw '${language.pageNotFound}';
  } else if (response.statusCode == 429) {
    throw '${language.tooManyRequests}';
  } else if (response.statusCode == 500) {
    throw '${language.internalServerError}';
  } else if (response.statusCode == 502) {
    throw '${language.badGateway}';
  } else if (response.statusCode == 503) {
    throw '${language.serviceUnavailable}';
  } else if (response.statusCode == 504) {
    throw '${language.gatewayTimeout}';
  }

  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    if (isSadadPayment.validate()) {
      try {
        var body = jsonDecode(response.body);
        throw parseHtmlString(body['error']['message']);
      } on Exception catch (e) {
        log(e);
        throw errorSomethingWentWrong;
      }
    } else {
      try {
        var body = jsonDecode(response.body);
        throw parseHtmlString(body['message']);
      } on Exception catch (e) {
        log(e);
        throw errorSomethingWentWrong;
      }
    }
  }
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  String url = '${baseUrl ?? buildBaseUrl(endPoint).toString()}';
  log(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());
  print("Result: ${response.statusCode}");

  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body);
  } else {
    onError?.call(errorSomethingWentWrong);
  }
}

String parseStripeError(String response) {
  try {
    var body = jsonDecode(response);
    return parseHtmlString(body['error']['message']);
  } on Exception catch (e) {
    log(e);
    throw errorSomethingWentWrong;
  }
}
