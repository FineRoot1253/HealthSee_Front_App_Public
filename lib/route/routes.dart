import 'package:get/get.dart';
import 'package:heathee/screen/album/album_choose_page.dart';
import 'package:heathee/screen/album/album_chosen_page.dart';
import 'package:heathee/screen/album/album_edit_page.dart';
import 'package:heathee/screen/album/others_album_page.dart';
import 'package:heathee/screen/album/my_album_page.dart';
import 'package:heathee/screen/album/album_write_page.dart';
import 'package:heathee/screen/auth/sign_in_page.dart';
import 'package:heathee/screen/auth/sign_up_page.dart';
import 'package:heathee/screen/board/board_detail_page.dart';
import 'package:heathee/screen/board/board_list_page.dart';
import 'package:heathee/screen/board/board_main_page.dart';
import 'package:heathee/screen/board/board_search_page.dart';
import 'package:heathee/screen/board/board_edit_page.dart';
import 'package:heathee/screen/board/board_write_page.dart';
import 'package:heathee/screen/exercise/exercise_description_page.dart';
import 'package:heathee/screen/exercise/exercise_detail_page.dart';
import 'package:heathee/screen/exercise/exercise_list_page.dart';
import 'package:heathee/screen/exercise/exercise_review_reading.dart';
import 'package:heathee/screen/exercise/exercise_review_writhing.dart';
import 'package:heathee/screen/exercise/exercise_search_page.dart';
import 'package:heathee/screen/main_page.dart';
import 'package:heathee/screen/mypage/mypage_edit_page.dart';
import 'package:heathee/screen/mypage/mypage_other_page.dart';
import 'package:heathee/screen/mypage/mypage_profile_edit_page.dart';
import 'package:heathee/screen/mypage/mypage_profile_send_page.dart';
import 'package:heathee/screen/mypage/mypage_user_own_board.dart';
import 'package:heathee/screen/plan/plan_copy_page.dart';
import 'package:heathee/screen/plan/plan_detail_page.dart';
import 'package:heathee/screen/plan/plan_edit_page.dart';
import 'package:heathee/screen/plan/plan_main_page.dart';
import 'package:heathee/screen/plan/plan_search_page.dart';
import 'package:heathee/screen/plan/plan_write_page.dart';
import 'package:heathee/screen/training/training_result_page.dart';
import 'package:heathee/screen/training/training_webview_page.dart';

final routes = [
  GetPage(name: '/signin', page: () => SigninPage()),
  GetPage(name: '/signup/:platform', page: () => SignupPage()),
  GetPage(name: '/main', page: () => MainPage()),
  GetPage(name: '/boardMain', page: () => BoardMainPage()),
  GetPage(name: '/boardList', page: () => BoardListPage()),
  GetPage(name: '/boardWrite', page: () => BoardWritePage()),
  GetPage(name: '/boardSearch', page: () => BoardSearchPage()),
  GetPage(name: '/boardUpdate', page: () => BoardEditPage()),
  GetPage(name: '/boardDetail', page: () => BoardDetailPage()),
  GetPage(name: '/myPageOthers', page: () => MyPageOtherPage()),
  GetPage(name: '/myPageEdit', page: () => MyPageEditPage()),
  GetPage(name: '/myPageProfileMake', page: () => MyPageProfileEditPage()),
  GetPage(name: '/myPageProfileSend', page: () => MypageProfileSendPage()),
  GetPage(name: '/myPageOwnBoard', page: () => MyPageUserOwnBoard()),
  GetPage(name: '/othersAlbum', page: () => OthersAlbumPage()),
  GetPage(name: '/albumChoose', page: () => AlbumChoosePage()),
  GetPage(name: '/albumChosen', page: () => AlbumChosenPage()),
  GetPage(name: '/albumWrite', page: () => AlbumWritePage()),
  GetPage(name: '/albumEdit', page: () => AlbumEditPage()),
  GetPage(name: '/myAlbum', page: () => MyAlbumPage()),
  GetPage(name: '/planMain', page: () => PlanMainPage()),
  GetPage(name: '/planSearch', page: () => PlanSearchPage()),
  GetPage(name: '/planWrite', page: () => PlanWritePage()),
  GetPage(name: '/planEdit', page: () => PlanEditPage()),
  GetPage(name: '/planDetail', page: () => PlanDetailPage()),
  GetPage(name: '/planCopy', page: () => PlanCopyPage()),
  GetPage(name: '/exercise', page: () => ExerciseDetailPage()),
  GetPage(name: '/exerciseDescription', page: () => ExerciseDescriptionPage()),
  GetPage(name: '/exerciseReviewWriting', page: () => ExerciseReviewWriting()),
  GetPage(name: '/exerciseReviewReading', page: () => ExerciseReviewReading()),
  GetPage(name: '/exerciseList', page: () => ExerciseListPage()),
  GetPage(name: '/exerciseSearchList', page: () => ExerciseSearchListPage()),
  GetPage(name: '/trainingWebview', page: () => TrainingWebviewPage()),
  GetPage(name: '/trainingResult', page: () => TrainingResultPage())

];
