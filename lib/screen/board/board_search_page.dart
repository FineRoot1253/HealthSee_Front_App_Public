import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/board/board_search_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/screen/board/widget/board_list_widget.dart';

class BoardSearchPage extends StatefulWidget {
  @override
  _BoardSearchPageState createState() => _BoardSearchPageState();
}

class _BoardSearchPageState extends State<BoardSearchPage> {
  PostSearchController postLists = new PostSearchController();
  List<String> conditionValues = ['제목', '작성자'];
  String nameValue;
  String searchCategory;
  TextEditingController keyword = TextEditingController();
  bool isSearched;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameValue = '제목';
    searchCategory = 'BO_Title';
    isSearched = false;
  }

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
          appBar: AppBar(
            centerTitle: true,
            title: Text('게시글 검색'),
          ),
          body: GetBuilder<PostSearchController>(
              init: PostSearchController(),
              builder: (_) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _buildDropButton(),
                        ],
                      ),
                      _buildTextField(),
                      Divider(
                        height: 1.0,
                        color: Colors.white60,
                      ),
                      Expanded(
                        child: (_.postLists.isNotEmpty)
                            ? PostListWidget(
                                posts: _.postLists,
                                controller: _.scrollController)
                            : (!isSearched)
                                ? Center(
                                    child: Text("검색어를 입력해주세요"),
                                  )
                                : Center(
                                    child: Text("검색 결과가 없습니다."),
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
                  Get.find<PostSearchController>().reset();
                  await Get.find<PostSearchController>()
                      .init(name: searchCategory, keyword: keyword.text);
                } else
                  Get.find<PostSearchController>().reset();
              },
              child: Text('검색')),
        ),
      ],
    );
  }

  DropdownButton<String> _buildDropButton() {
    return DropdownButton(
      value: nameValue,
      items: conditionValues.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {
        nameValue = newValue;
        setState(() {
          if (newValue == "제목")
            searchCategory = "BO_Title";
          else
            searchCategory = "BO_Writer_NickName";
        });
      },
    );
  }
}
