import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';

class CommentWriter extends StatefulWidget {
  CommentWriter(this.controller, [this.code, this.content]);
  var controller;
  int code;
  String content;

  @override
  _CommentWriterState createState() => _CommentWriterState();
}

class _CommentWriterState extends State<CommentWriter> {
  TextEditingController textInputController = TextEditingController();
  String str;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textInputController.text = widget.content;
    str = (widget.controller is PlanDetailController) ? "평가" : "댓글";
  }

  @override
  void dispose() {
    textInputController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[buildTextField(), buildButton()],
          ),
        ],
      ),
    );
  }

  Expanded buildTextField() {
    return Expanded(
      child: TextField(
        autocorrect: false,
        maxLines: 2,
        style: LITTLE_TEXT_STYLE,
        controller: textInputController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: (widget.code == null) ? "$str${(str=='댓글') ? '을' : '를'} 입력하세요" : "답글을 입력하세요",
          hintStyle: TextStyle(color: Colors.white),
          filled: true,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Padding buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FlatButton(
        onPressed: () async {
          if (textInputController.text.toString() != "") {
            if (widget.content == null) {
              await widget.controller.writeComment(textInputController.text,
                  widget.controller.detail.code, widget.code);
            } else {
              await widget.controller
                  .updateComments(textInputController.text, widget.code);
            }
            textInputController.clear();
            Get.back();
          } else {
            Get.snackbar("작성 에러", "$str 내용을 작성해주세요");
          }
        },
        child: Text(
          "$str 전송",
          style: LITTLE_TEXT_STYLE,
        ),
        color: Colors.blue,
      ),
    );
  }
}
