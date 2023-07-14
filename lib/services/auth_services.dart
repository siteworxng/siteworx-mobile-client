import 'dart:convert';

import 'package:client/main.dart';
import 'package:client/model/login_model.dart';
import 'package:client/model/user_data_model.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/auth/auth_user_services.dart';
import 'package:client/screens/auth/opt_dialog_component.dart';
import 'package:client/screens/auth/sign_up_screen.dart';
import 'package:client/screens/dashboard/dashboard_screen.dart';
import 'package:client/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //region Google Login
  Future<(UserData, LoginResponse?)> signInWithGoogle(BuildContext context) async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      assert(!user.isAnonymous);

      final User currentUser = _auth.currentUser!;
      assert(user.uid == currentUser.uid);

      await googleSignIn.signOut();

      String firstName = '';
      String lastName = '';
      if (currentUser.displayName.validate().split(' ').length >= 1) firstName = currentUser.displayName.splitBefore(' ');
      if (currentUser.displayName.validate().split(' ').length >= 2) lastName = currentUser.displayName.splitAfter(' ');

      /// Create a temporary request to send
      UserData tempUserData = UserData()
        ..contactNumber = currentUser.phoneNumber.validate()
        ..email = currentUser.email.validate()
        ..firstName = firstName.validate()
        ..lastName = lastName.validate()
        ..profileImage = currentUser.photoURL.validate()
        ..socialImage = currentUser.photoURL.validate()
        ..userType = USER_TYPE_USER
        ..loginType = LOGIN_TYPE_GOOGLE
        ..playerId = getStringAsync(PLAYERID)
        ..uid = user.uid
        ..username = (currentUser.email.validate().splitBefore('@').replaceAll('.', '')).toLowerCase();
      return await loginCurrentUsers(context, req: tempUserData.toJson(), isSocialLogin: true);
    } else {
      appStore.setLoading(false);
      throw USER_NOT_CREATED;
    }
  }

//endregion

  //region Email

  Future<String> signUpWithEmailPassword(BuildContext context, {required UserData userData}) async {
    return await _auth.createUserWithEmailAndPassword(email: userData.email.validate(), password: DEFAULT_FIREBASE_PASSWORD).then((userCredential) async {
      User currentUser = userCredential.user!;

      userData.uid = currentUser.uid.validate();
      userData.createdAt = Timestamp.now().toDate().toString();
      userData.updatedAt = Timestamp.now().toDate().toString();
      userData.playerId = getStringAsync(PLAYERID);

      log("Step 1 ${userData.toFirebaseJson()}");

      return await setRegisterData(userData: userData);
    }).catchError((e) {
      throw "User is Not Registered in Firebase";
    });
  }

  Future<String> signInWithEmailPassword({required String email, String? uid, bool isSocialLogin = false}) async {
    if (isSocialLogin) {
      return uid.validate();
    }
    return await _auth.signInWithEmailAndPassword(email: email, password: DEFAULT_FIREBASE_PASSWORD).then((value) async {
      return value.user!.uid.validate();
    }).catchError((e) async {
      appStore.setLoading(false);
      log(e.toString());
      throw language.userNotFound;
    });
  }

  //endregion

  Future<String> setRegisterData({required UserData userData}) async {
    return await userService.addDocumentWithCustomId(userData.uid.validate(), userData.toFirebaseJson()).then((value) async {
      return value.id.validate();
    }).catchError((e) {
      throw false;
    });
  }

  //region Google OTP
  Future loginWithOTP(BuildContext context, {String phoneNumber = "", String? countryCode, String? countryISOCode}) async {
    log("PHONE NUMBER VERIFIED +$countryCode$phoneNumber");

    return await _auth.verifyPhoneNumber(
      phoneNumber: "+$countryCode$phoneNumber",
      verificationCompleted: (PhoneAuthCredential credential) {
        toast(language.verified);
      },
      verificationFailed: (FirebaseAuthException e) {
        appStore.setLoading(false);
        if (e.code == 'invalid-phone-number') {
          toast(language.theEnteredCodeIsInvalidPleaseTryAgain, print: true);
        } else {
          toast(e.toString(), print: true);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        toast(language.otpCodeIsSentToYourMobileNumber);

        appStore.setLoading(false);

        /// Opens a dialog when the code is sent to the user successfully.
        await OtpDialogComponent(
          onTap: (otpCode) async {
            if (otpCode != null) {
              AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpCode);

              await _auth.signInWithCredential(credential).then((credentials) async {
                Map<String, dynamic> request = {
                  'username': phoneNumber,
                  'password': phoneNumber,
                  'player_id': getStringAsync(PLAYERID, defaultValue: ""),
                  'login_type': LOGIN_TYPE_OTP,
                  "uid": credentials.user!.uid.validate(),
                };

                log("OTP REQUEST $request");

                log("UID ${credentials.user!.uid}");

                await loginCurrentUsers(context, req: request, isSocialLogin: true, isOtpLogin: true).then((loginResponse) async {
                  if (loginResponse.$2!.isUserExist == null) {
                    toast(language.loginSuccessfully);

                    /// Register

                    if (loginResponse.$2!.userData!.status == 0) {
                      toast(language.contactAdmin);
                    } else {
                      if (await userService.isUserExistWithUid(loginResponse.$2!.userData!.uid)) {
                        await saveUserData(loginResponse.$2!.userData!);
                        DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                      } else {
                        return await authService.setRegisterData(userData: loginResponse.$2!.userData!).catchError((ee) {
                          throw "Cannot Register";
                        });
                      }
                    }
                  } else {
                    ///Not Register
                    toast(language.confirmOTP);
                    appStore.setLoading(false);
                    finish(context);
                    SignUpScreen(isOTPLogin: true, phoneNumber: phoneNumber, countryCode: countryISOCode, uid: credentials.user!.uid.validate()).launch(context);
                  }
                }).catchError((e) {
                  appStore.setLoading(false);
                  toast(e.toString(), print: true);
                });
              }).catchError((e) {
                if (e.code.toString() == 'invalid-verification-code') {
                  toast(language.theEnteredCodeIsInvalidPleaseTryAgain, print: true);
                } else {
                  toast(e.message.toString(), print: true);
                }
                appStore.setLoading(false);
              });
            }
          },
        ).launch(context);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //
      },
    );
  }

//endregion
  Future<void> loginFromFirebaseUser(User currentUser, {LoginResponse? loginData, String? displayName, String? loginType}) async {
    if (await userService.isUserExist(loginData!.userData!.email)) {
      log("Firebase User Exist");

      await userService.userByEmail(loginData.userData!.email).then((user) async {
        await saveUserData(loginData.userData!);
      }).catchError((e) {
        log(e);
        throw e;
      });
    } else {
      log("Creating Firebase User");

      loginData.userData!.uid = currentUser.uid.validate();
      loginData.userData!.userType = LOGIN_TYPE_USER;
      loginData.userData!.loginType = loginType;
      loginData.userData!.playerId = getStringAsync(PLAYERID);
      if (isIOS) {
        loginData.userData!.displayName = displayName;
      }

      await userService.addDocumentWithCustomId(currentUser.uid.validate(), loginData.userData!.toJson()).then((value) async {
        log("Firebase User Created");
        await saveUserData(loginData.userData!);
      }).catchError((e) {
        throw language.lblUserNotCreated;
      });
    }
  }

  // region Apple Sign
  Future<void> appleSignIn() async {
    if (await TheAppleSignIn.isAvailable()) {
      AuthorizationResult result = await TheAppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
            accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
          );

          final authResult = await _auth.signInWithCredential(credential);
          final user = authResult.user!;

          log('User:- $user');

          if (result.credential!.email != null) {
            appStore.setLoading(true);

            await saveAppleData(result).then((value) {
              appStore.setLoading(false);
            }).catchError((e) {
              appStore.setLoading(false);
              throw e;
            });
          }
          await setValue(APPLE_UID, user.uid.validate());

          await saveAppleDataWithoutEmail(user).then((value) {
            appStore.setLoading(false);
          }).catchError((e) {
            appStore.setLoading(false);
            throw e;
          });

          break;
        case AuthorizationStatus.error:
          throw ("${language.lblSignInFailed}: ${result.error!.localizedDescription}");
        case AuthorizationStatus.cancelled:
          throw ('${language.lblUserCancelled}');
      }
    } else {
      throw language.lblAppleSignInNotAvailable;
    }
  }

  Future<void> saveAppleData(AuthorizationResult result) async {
    await setValue(APPLE_EMAIL, result.credential!.email);
    await setValue(APPLE_GIVE_NAME, result.credential!.fullName!.givenName);
    await setValue(APPLE_FAMILY_NAME, result.credential!.fullName!.familyName);
  }

  Future<void> saveAppleDataWithoutEmail(User user) async {
    log('UID: ${getStringAsync(APPLE_UID)}');
    log('Email:- ${getStringAsync(APPLE_EMAIL)}');
    log('appleGivenName:- ${getStringAsync(APPLE_GIVE_NAME)}');
    log('appleFamilyName:- ${getStringAsync(APPLE_FAMILY_NAME)}');

    var req = {
      'email': getStringAsync(APPLE_EMAIL).isNotEmpty ? getStringAsync(APPLE_EMAIL) : getStringAsync(APPLE_UID) + '@gmail.com',
      'first_name': getStringAsync(APPLE_GIVE_NAME),
      'last_name': getStringAsync(APPLE_FAMILY_NAME),
      "username": getStringAsync(APPLE_EMAIL).isNotEmpty ? getStringAsync(APPLE_EMAIL) : getStringAsync(APPLE_UID) + '@gmail.com',
      "profile_image": '',
      "social_image": '',
      'accessToken': '12345678',
      'login_type': LOGIN_TYPE_APPLE,
      "user_type": LOGIN_TYPE_USER,
    };

    log("Apple Login Json" + jsonEncode(req));

    await loginUser(req, isSocialLogin: true).then((value) async {
      await loginFromFirebaseUser(user, loginData: value, displayName: value.userData!.displayName.validate(), loginType: LOGIN_TYPE_APPLE);
    }).catchError((e) {
      log(e.toString());
      throw e;
    });
  }

//endregion
}
