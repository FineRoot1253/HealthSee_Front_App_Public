import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';
import 'package:heathee/controller/plan/plan_write_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/screen/plan/widget/plan_exce_widget.dart';
import 'package:heathee/screen/plan/widget/plan_menu_bar.dart';

class PlanWriteWidget extends StatefulWidget {

  PlanWriteController controller;

  PlanWriteWidget(this.controller);

  @override
  _PlanWriteWidgetState createState() => _PlanWriteWidgetState();
}

class _PlanWriteWidgetState extends State<PlanWriteWidget> {



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PlanMenuBar(widget.controller, '운동명'),
        buildTitleTextField(),
        Divider(
          height: 1.0,
          color: Colors.white60,
        ),
        PlanMenuBar(widget.controller, '운동 선택', '선택'),
        Container(height: Get.height*0.28,child: buildPlanTiles()),
        buildDescriptionTextField(),
        Divider(
          height: 1.0,
          color: Colors.white60,
        ),
        PlanMenuBar(widget.controller, '운동 세부 설정'),
        buildPlanDetail(context),
      ],
    );
  }

  buildPlanTiles() {
    print(widget.controller.selectedExces.length);
    if(widget.controller.selectedExces.length==0)
    return Container(decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(12)),child: Center(child: Text("비어있음")));
    else
    return ReorderableListView(
      onReorder: widget.controller.onReorder,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: List.generate(widget.controller.selectedExces.length, (index) {
        return PlanExceWidget(widget.controller,index,Key('$index'));
      }),
    );
  }

  buildTitleTextField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: Get.height * 0.1,
      child: TextFormField(
        controller: widget.controller.titleEditingController,
        maxLines: 1,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            hintText: "코스명을 입력해주세요.",
            hintStyle: TextStyle(color: Colors.white),
            fillColor: CONTENT_COLOR,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: CONTENT_COLOR,
              ),
            )),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  buildDescriptionTextField() {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      height: Get.height * 0.2,
      child: TextFormField(
        controller: widget.controller.contentEditingController,
        maxLines: 10,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            hintText: "설명을 입력해주세요.",
            hintStyle: TextStyle(color: Colors.white),
            fillColor: CONTENT_COLOR,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: CONTENT_COLOR,
              ),
            )),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  buildPlanDetail(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(flex: 5, child: buildRestTimeTile(context),),
        Expanded(flex: 5, child: buildScopeSelectTile(),),
      ],
    );
  }

  buildRestTimeTile(context) {
    return Column(
      children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      color: CONTENT_COLOR,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '쉬는 시간',
                              style: MENUBAR_TEXT_STYLE,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            height: 35,
                            child: IconButton(
                              icon: Icon(Icons.timer),
                              onPressed: (){
                                widget.controller.selectTime(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
//        PlanMenuBar(controller, '쉬는 시간', '선택'),
        Text(format(widget.controller.restTime)),
        SizedBox(height: 47,)
      ],
    );
  }

  buildScopeSelectTile() {

    List<String> value = ["비공개","공개"];
print("스코프 상태 : ${widget.controller.scope}");
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              color: CONTENT_COLOR,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '비공개여부',
                      style: MENUBAR_TEXT_STYLE,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    height: 35,),
                ],
              ),
            ),
          ),
        ),
        Switch(
          value: widget.controller.isOpen,
          onChanged: (value){
            setState(() {
              widget.controller.isOpen = value;

              //TODO 주석 부분 완료 눌렀을때 부분에 추가해야됨
              if(value)
                widget.controller.scope = 1;
              else
                widget.controller.scope = 0;
            });
          },
        ),
        Text(value[widget.controller.scope])
      ],
    );
  }

  format(Duration d) =>
      d
          .toString()
          .split('.')
          .first
          .padLeft(8, "0");
}

