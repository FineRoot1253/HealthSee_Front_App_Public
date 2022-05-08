import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/exercise/list_page/exercise_list_controller.dart';
import 'package:heathee/controller/exercise/list_page/exercise_list_page_controller.dart';
import 'package:heathee/controller/exercise/list_page/list_scroll_controller.dart';
import 'package:heathee/screen/exercise/widget/exercise_list.dart';

class ExerciseSearchListPage extends StatefulWidget {
  @override
  _ExerciseSearchListPageState createState() => _ExerciseSearchListPageState();
}

class _ExerciseSearchListPageState extends State<ExerciseSearchListPage> {
  String keyword = Get.arguments;
  ExerciseListPageController exerciseListPageController =
      Get.put(ExerciseListPageController());
  ExerciseSearchedListController exerciseSearchedListController =
      Get.put(ExerciseSearchedListController());
  SearchedListScrollController searchedListScrollController =
      Get.put(SearchedListScrollController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(keyword);
    exerciseListPageController.search(keyword);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
            future: exerciseListPageController.initalizeControllerFuture2,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Scaffold(
                  appBar: AppBar(
                    title: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                          controller:
                              exerciseListPageController.textEditingController,
                        )),
                        IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              exerciseListPageController.search(
                                  exerciseListPageController
                                      .textEditingController.text);
                            })
                      ],
                    ),
                  ),
                  body: GetX<ExerciseSearchedListController>(
                      builder: (_) => ListView.builder(
                            controller:
                                searchedListScrollController.scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: _.items.length,
                            itemBuilder: (context, i) =>
                                GetX<ExerciseSearchedListController>(
                                    builder: (controller) => ExerciseListWidget(
                                          exerciseList: controller.items[i],
                                        )),
                          )),
                );
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
