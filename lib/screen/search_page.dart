import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/mypage/mypage_search_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/screen/mypage/widget/user_list_widget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController keyword = TextEditingController();
  bool isSearched = false;
  Future<void> userList;

  @override
  void dispose() {
    // TODO: implement dispose
    keyword?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: BACKGROUND_COLOR,
          appBar: AppBar(
            backgroundColor: CONTENT_COLOR,
            centerTitle: true,
            title: Text('유저 검색'),
          ),
          body: GetBuilder<MyPageSearchController>(
              init: MyPageSearchController(),
              builder: (_) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      _buildTextField(),
                      Divider(
                        height: 1.0,
                        color: Colors.white60,
                      ),
                      Expanded(
                        child: ConditionalBuilder(
                          condition: !isSearched,
                          builder: (context) {
                            return Center(
                              child: Text("검색어를 입력해주세요"),
                            );
                          },
                          fallback: (context) {
                            return FutureBuilder(
                                future: userList,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState
                                          .done) if (_.userList.isEmpty)
                                    return Center(
                                      child: Text("검색 결과가 없습니다."),
                                    );
                                  else
                                    return MyPageListWidget(
                                        users: _.userList,
                                        controller: _.scrollController);
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }

  Row _buildTextField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
            child: TextField(
          controller: keyword,
          style: LITTLE_TEXT_STYLE,
          decoration: InputDecoration(
            fillColor: CONTENT_COLOR,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: CONTENT_COLOR,
              ),
            ),
          ),
        )),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: FlatButton(
              color: Colors.blue,
              onPressed: () async {
                if (keyword.text.toString() != "") {
                  isSearched = true;
                  MyPageSearchController.to.reset();
                  userList = MyPageSearchController.to.init(
                    keyword: keyword.text,
                  );
                } else {
                  MyPageSearchController.to.reset();
                }
              },
              child: Text('검색')),
        ),
      ],
    );
  }
}
