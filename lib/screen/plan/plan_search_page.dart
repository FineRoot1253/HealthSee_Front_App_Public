import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/plan/plan_list_controller.dart';
import 'package:heathee/controller/plan/plan_search_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/screen/plan/widget/plan_list_widget.dart';

class PlanSearchPage extends StatelessWidget {

  final TextEditingController textEditingController = TextEditingController();
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    return buildSearchList();
  }

  buildSearchList() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("운동 세트 검색"),
      ),
        body: GetBuilder<PlanSearchController>(
            init: PlanSearchController(),
            builder: (_) {
              return Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    textField(_),
                    Divider(
                      height: 1.0,
                      color: Colors.white60,
                    ),
                    Expanded(
                      child:  (_.planList.isNotEmpty)
                          ? PlanListWidget(
                          planList: _.planList,
                          controller: _)
                          : (!_.isSearched)
                          ? Center(
                        child: Text("검색어를 입력해주세요"),
                      )
                          : Center(
                        child: Text("검색 결과가 없습니다."),
                      )
                    )
                  ],
                ),
              );
            })
    );
  }

  textField(controller){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildDropButton(controller),
        Expanded(
            child: TextField(
              controller: textEditingController,
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
                if (textEditingController.text.toString() != "") {
                  isSearched = true;
                  PlanSearchController.to.reset();
                  PlanSearchController.to.keyword = textEditingController.text;
                  await PlanSearchController.to.init();
                } else
                  Get.find<PlanSearchController>().reset();
                PlanSearchController.to.update();
              },
              child: Text('검색')),
        ),
      ],
    );
  }
  searchBtn(){
    return RaisedButton(
      child: Text('검색'),
    );
  }
  DropdownButton<String> _buildDropButton(controller) {
    return DropdownButton(
      value: controller.nameValue,
      items: controller.names.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {
        controller.nameValue = newValue;
        if(newValue=="제목")
          controller.searchCategory = "PL_Title";
        else
          controller.searchCategory = "PL_Writer_NickName";
        controller.update();
      },
    );
  }
}
