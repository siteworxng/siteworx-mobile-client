import 'package:client/main.dart';
import 'package:client/model/user_data_model.dart';
import 'package:client/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';

import 'base_services.dart';

class UserService extends BaseService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  UserService() {
    ref = fireStore.collection(USER_COLLECTION);
  }

  Future<UserData> getUser({String? key, String? email}) {
    return ref!.where(key ?? "email", isEqualTo: email).limit(1).get().then((value) {
      if (value.docs.isNotEmpty) {
        return UserData.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw language.userNotFound;
      }
    });
  }

  Future<UserData?> getUserNull({String? key, String? email}) {
    return ref!.where(key ?? "email", isEqualTo: email).limit(1).get().then((value) {
      if (value.docs.isNotEmpty) {
        return UserData.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  Stream<List<UserData>> users({String? searchText}) {
    return ref!.where('caseSearch', arrayContains: searchText.validate().isEmpty ? null : searchText!.toLowerCase()).snapshots().map((x) {
      return x.docs.map((y) {
        return UserData.fromJson(y.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<UserData> userByEmail(String? email) async {
    return await ref!.where('email', isEqualTo: email).limit(1).get().then((value) {
      if (value.docs.isNotEmpty) {
        return UserData.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw '${language.lblNoUserFound}';
      }
    });
  }

  Stream<UserData> singleUser(String? id, {String? searchText}) {
    return ref!.where('uid', isEqualTo: id).limit(1).snapshots().map((event) {
      return UserData.fromJson(event.docs.first.data() as Map<String, dynamic>);
    });
  }

  Future<UserData> userByMobileNumber(String? phone) async {
    log("Phone $phone");
    return await ref!.where('phoneNumber', isEqualTo: phone).limit(1).get().then(
      (value) {
        log(value);
        if (value.docs.isNotEmpty) {
          return UserData.fromJson(value.docs.first.data() as Map<String, dynamic>);
        } else {
          throw "${language.lblNoUserFound}";
        }
      },
    );
  }

  Future<void> saveToContacts({required String senderId, required String receiverId}) async {
    return ref!.doc(senderId).collection(CONTACT_COLLECTION).doc(receiverId).update({'lastMessageTime': DateTime.now().millisecondsSinceEpoch}).catchError((e) {
      throw "${language.lblUserNotCreated}";
    });
  }

  Future<bool> isReceiverInContacts({required String senderUserId, required String receiverUserId}) async {
    final contactRef = ref!.doc(senderUserId).collection(CONTACT_COLLECTION).doc(receiverUserId);

    final contactSnapshot = await contactRef.get();
    return contactSnapshot.exists;
  }

  Future<void> updatePlayerIdInFirebase({required String email, required String playerId}) async {
    await userByEmail(email).then((value) {
      ref!.doc(value.uid.validate()).update({
        'player_id': playerId,
        'updated_at': Timestamp.now().toDate().toString(),
      });
    }).catchError((e) {
      toast(e.toString());
    });
  }

  Future<void> deleteUser() async {
    await FirebaseAuth.instance.currentUser!.delete().then((value) {
      //
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
    await FirebaseAuth.instance.signOut();
  }
}
