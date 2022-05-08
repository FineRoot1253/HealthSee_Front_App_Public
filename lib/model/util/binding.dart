import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    try {
      Get.put<AccountController>(AccountController());
    }catch(e){
      print(e);
    }
  }
}
