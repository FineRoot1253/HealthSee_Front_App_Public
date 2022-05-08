import 'package:heathee/keyword/key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

//class SharedPreferencesManager extends GetController, {
//
////  static Future<SharedPreferencesManager>  get to async => await Get.putAsync<SharedPreferencesManager>(()=>SharedPreferencesManager.getinstace());
//
//
////  static SharedPreferences sharedPreferences;
////  static SharedPreferencesManager sharedPreferencesManager;
//
//  static Future<SharedPreferencesManager> getinstace() async {
//    if(sharedPreferences == null){
//      sharedPreferences= await SharedPreferences.getInstance();
//    }
//    if(sharedPreferencesManager == null){
//      sharedPreferencesManager = SharedPreferencesManager();
//    }
//    return  sharedPreferencesManager;
//  }
//
//Future<void> putInit()async{
//  Get.putAsync<SharedPreferences>(() async{
//    final prefs = await SharedPreferences.getInstance();
//    return prefs;
//  });
//}
//
//  static Future<void> putUserInfo ({ String nickname, String email})async{
//    Get.putAsync<SharedPreferences>(() async{
//      final prefs = await SharedPreferences.getInstance();
//      await prefs.setString(keyUsername, nickname);
//      await prefs.setString(keyEmail, email);
//
//      return prefs;
//    });
//
//  }
//  static Future<void> putToken ({ String accessToken, String refreshToken})async{
//    Get.putAsync<SharedPreferences>(() async{
//      final prefs = await SharedPreferences.getInstance();
//      await prefs.setString(keyAccessToken, accessToken);
//      await prefs.setString(keyRefreshToken, refreshToken);
//
//      return prefs;
//    });
//
//  }
//  static Future<void> putPlatformInfo(int platform)async{
//    Get.putAsync<SharedPreferences>(() async{
//      final prefs = await SharedPreferences.getInstance();
//      await prefs.setInt(keyPlaform, platform);
//      return prefs;
//    });
//  }
//
//  static Future<String> getString(String key) async {
//    Get.putAsync<SharedPreferences>(() async{
//      final prefs = await SharedPreferences.getInstance();
//      return prefs;
//    }).then((prefs) { return prefs.getString(key);});
//  }
//}