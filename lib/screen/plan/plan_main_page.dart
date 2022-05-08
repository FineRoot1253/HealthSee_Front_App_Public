import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/plan/plan_list_controller.dart';
import 'package:heathee/controller/plan/plan_main_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/screen/plan/widget/plan_list_widget.dart';
import 'package:heathee/screen/plan/widget/plan_menu_bar.dart';

class PlanMainPage extends StatefulWidget {
  @override
  _PlanMainPageState createState() => _PlanMainPageState();
}

class _PlanMainPageState extends State<PlanMainPage> {
  int selectedIndex = 0;
  Future result;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlanMainController>(
      init: PlanMainController(),
      initState: (_){PlanMainController.to.init();},
      builder: (_){
        return buildMain(_);
      },
    );
  }
  buildMain(controller){
    return Scaffold(
            appBar: buildAppBar(controller),
            bottomNavigationBar: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                unselectedItemColor: Colors.grey[900],
                selectedItemColor: Colors.black,
                type: BottomNavigationBarType.fixed,
                backgroundColor: CONTENT_COLOR,
                items: [
              _bottomNavigationBarItem(activeIcon: Icons.dehaze, icon: Icons.dehaze, title: "운동 세트 목록"),
              _bottomNavigationBarItem(activeIcon: null, icon: Icons.search, title: "운동 세트 검색"),
              _bottomNavigationBarItem(activeIcon: null, icon: Icons.create, title: "운동 세트 작성"),
            ],
              currentIndex: selectedIndex,
              onTap: (index) => onItemTapped(index, controller),
            ),
            body: GetBuilder<PlanListController>(
                init: PlanListController(),
              initState: (_) {controller.planListController.result = controller.planListController.init();} ,
              builder: (_){
                  return FutureBuilder(
                    future: controller.planListController.result,
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done)
                        return buildListBody(_);
                      else if(snapshot.hasError)
                        return Center(child: Text('에러발생\n${snapshot.error}'),);
                      else
                        return Center(child: CircularProgressIndicator());
                    },
                  );
//                  return buildListBody(_);
              },
            )
    );
  }


  buildAppBar(controller){
    return AppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: () => Get.back(),),
      centerTitle: true,
        title: Text(controller.value),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            DropdownButton(
                value: controller.value,
                items: controller
                    .valueList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) async =>
                await controller.dropDownBtn(value))
          ],
        ),
      ],
    );
  }

  buildListBody(controller){
    print("받은 길이 : ${controller.getList.length}");
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        controller.refreshPostLists();
      },
      child: Column(
        children: <Widget>[
          PlanMenuBar(controller, controller.value),
          Expanded(child: PlanListWidget(controller: controller, planList: controller.getList,)),
        ],
      ),
    );
  }



  void onItemTapped(int index, PlanMainController controller) {
    switch (index) {
      case 0:
        break;
      case 1:
        Get.toNamed("/planSearch");
        break;
      case 2:
        Get.toNamed("/planWrite",arguments: controller);
        break;
    }
  }
  BottomNavigationBarItem _bottomNavigationBarItem({IconData activeIcon, IconData icon, String title}){
    return BottomNavigationBarItem(
      activeIcon:
      (activeIcon != null) ? Icon(activeIcon, color: Colors.white) : null,
      icon: Icon(icon),
      title: Text(title),
    );
  }
}
