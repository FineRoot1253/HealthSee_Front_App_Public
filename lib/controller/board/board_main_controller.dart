import 'package:get/get.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/board/post_list.dart';
import 'package:intl/intl.dart';

class BoardMainController extends GetxController {
  List<PostL> best3Free = new List<PostL>();
  int index = 0;
  String value = "추천순";
  List<String> valueList = ["추천순", "조회순", "댓글순"];
  String category = "BO_Healthsee_Count";
  List<String> categoryList = [
    "BO_Healthsee_Count",
    "BO_Hit",
    "BO_Comment_Count"
  ];

  parsingList(postListsData) {
    for (var board in postListsData['free']) {
      PostL postL = PostL(
          board['BO_Code'],
          board['BO_Title'],
          DateFormat("yyyy-MM-dd HH:mm").format(
              DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                  .parseUTC(board['BO_Creation_Date'])
                  .toLocal()),
          board['BO_Hit'],
          board['BO_Report_Count'],
          board['BO_Healthsee_Count'],
          board['BO_Comment_Count'],
          board['BO_Writer_NickName'],
          board['BO_State']);

      best3Free.add(postL);
    }
  }

  getBest() async {
    best3Free = [];
    String url = 'http://$IP$BOARDLIST/$category&3';
    var responseData = await HttpController.to.httpManeger("GET", url);
    parsingList(responseData);
    update();
  }

  onChanged(String value) async {
    if (value == "추천순") {
      index = 0;
      this.value = valueList[index];
      category = categoryList[index];
    } else if (value == "조회순") {
      index = 1;
      this.value = valueList[index];
      category = categoryList[index];
    } else {
      index = 2;
      this.value = valueList[index];
      category = categoryList[index];
    }
    best3Free = [];
    await getBest();

    update();
  }
}
