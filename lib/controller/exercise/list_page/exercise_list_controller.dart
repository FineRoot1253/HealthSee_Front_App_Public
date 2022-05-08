import 'package:get/get.dart';
import 'package:heathee/model/exercise/exercise_list.dart';

class ExerciseListController extends GetxController {
  RxList _items = List<ExerciseList>().obs;

  int offset = 0;
  bool isEnd = false;

  List<ExerciseList> get items => _items.value;

  set items(responseData) {
    List<ExerciseList> exerciseLists = [];
    if (responseData != null) {
      for (var r in responseData['exerciseList']) {
        ExerciseList exerciseList = ExerciseList.fromJson(r);
        exerciseLists.add(exerciseList);
      }
      _items.addAll(exerciseLists);
    }
    offset = responseData['exerciseListCount'];
    if (offset == null)
      isEnd = true;
    else if (offset <= 10)
      isEnd = true;
    else
      isEnd = false;
    print(items.length);
  }
}

class ExerciseSearchedListController extends GetxController {
  RxList _items = List<ExerciseList>().obs;
  int searchedOffset = 0;
  String searchedKeyword;
  bool isEnd = false;

  List<ExerciseList> get items => _items.value;

  set init(responseData) {
    List<ExerciseList> exerciseLists = [];
    if (responseData != null) {
      for (var r in responseData['exerciseList']) {
        ExerciseList exerciseList = ExerciseList.fromJson(r);
        exerciseLists.add(exerciseList);
      }
      _items.assignAll(exerciseLists);
    }
    if (responseData['exerciseListCount'] == null)
      isEnd = true;
    else if (responseData['exerciseListCount'] <= 10)
      isEnd = true;
    else
      isEnd = false;
  }

  set add(responseData) {
    List<ExerciseList> exerciseLists = [];
    if (responseData != null) {
      for (var r in responseData['exerciseList']) {
        ExerciseList exerciseList = ExerciseList.fromJson(r);
        exerciseLists.add(exerciseList);
      }
      _items.addAll(exerciseLists);
    }
    if (responseData['exerciseListCount'] == null)
      isEnd = true;
    else if (int.parse(responseData['exerciseListCount']) <= 10)
      isEnd = true;
    else
      isEnd = false;
  }
}
