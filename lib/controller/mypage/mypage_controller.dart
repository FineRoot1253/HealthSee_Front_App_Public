import 'package:get/get.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/mypage/user.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MyPageController extends GetxController {
  static MyPageController get to => Get.find();

  User myUser;
  bool myUserIsChanged = true;
  bool isExist;
  User otherUser;

  myPageUpdate() {
    update();
  }

  setTempProfileImage(File file) {
    myUser.tempProfileImage = file;
    update();
  }

  Future<User> readMyPage(String nickname) async {
    // 나일 때 이미 정보를 가지고 있으며, change가 되지 않았을 경우 그냥 리턴하고 끝내준다.

    if (!myUserIsChanged) return myUser;

    var url = 'http://$IP$MYPAGEREAD$nickname';
    var responseData = await HttpController.to.httpManeger("GET", url);

    myUserIsChanged = false;
    myUser = User.fromJson(responseData);

    if (myUser.picture != null) isExist = true;

    update();
    return myUser;
  }

  Future<User> readOtherUserMyPage(String nickname) async {
    var url = 'http://$IP$MYPAGEREAD$nickname';
    var responseData = await HttpController.to.httpManeger("GET", url);
    otherUser = User.fromJson(responseData);
    return otherUser;
  }

  readOtherUserPage() {}

  updateMyPage(String nickname, int scope, int gender, String weight,
      String height, String birth) async {
    var url = 'http://$IP$MYPAGE';
    List<File> uploadFiles;
    var responseData;
    Map<String, String> fields = {
      "Account_AC_NickName": nickname,
      'ME_Scope': scope.toString(),
      'ME_Weight': weight,
      'ME_Height': height,
      'ME_Birth': birth,
      'ME_Gender': gender.toString()
    };

    if (myUser.picture != null) {
      String filename =
          "${DateTime.now()}${myUser.nickname}_profile.${myUser.picture_type.substring(6)}";
      final path = join((await getTemporaryDirectory()).path, filename);
      myUser.nowProfileImage = File(path);
      await myUser.nowProfileImage.writeAsBytesSync(myUser.picture);
    }

    if (myUser.tempProfileImage != null || myUser.nowProfileImage != null) {
      (myUser.tempProfileImage != null)
          ? uploadFiles = [myUser.tempProfileImage]
          : uploadFiles = [myUser.nowProfileImage];
      responseData = await HttpController.to.StartUploading('PATCH', url,
          uploadFiles: uploadFiles, fields: fields);
    } else {
      responseData =
          await HttpController.to.StartUploading('PATCH', url, fields: fields);
    }
    myUserIsChanged = true;
  }

  readMyBoard() {}
  readMyAlbum() {}
}

// ---------------- 프로필 이미지만 변경하거나, 프로필 이미지 외에 전부 변경하는 경우

//  updateOnlyProfileImage(File file, String nickname) async {
//    var url = 'http://$IP$MYPAGEONLYPROFILE';
//    List<File> uploadFiles = [file];
//    Map<String, String> fields = {"Account_AC_NickName": nickname};
//    var responseData = await HttpController.to
//        .StartUploading('PATCH', url, uploadFiles: uploadFiles, fields: fields);
//    myUser = await User.fromJson(responseData);
//    update();
//  }
//
//  updateExceptProfileImage(String nickname, int scope, int gender,
//      String weight, String height, String birth) async {
//    var url = 'http://$IP$MYPAGEOTHERS';
//    Map<String, String> fields = {
//      "Account_AC_NickName": nickname,
//      'ME_Scope': scope.toString(),
//      'ME_Weight': weight,
//      'ME_Height': height,
//      'ME_Birth': birth,
//      'ME_Gender': gender.toString()
//    };
//    var responseData =
//        await HttpController.to.httpManeger('PATCH', url, fields);
//    myUser = User.fromJson(responseData);
//    update();
//  }
