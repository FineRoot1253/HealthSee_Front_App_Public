import 'package:flutter/material.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';

class CommentBar extends StatelessWidget {
  var controller;
  CommentBar(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                (controller is PlanDetailController) ?
                "평가 ${controller.commentCount}":"댓글 ${controller.commentCount}",
              ),
              Container(
                height: 30,
                child: IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.refresh),
                    onPressed: () async {
                      await controller.getPageComment(
                          controller.detail.code, controller.nowPage);
                    }),
              ),
              Expanded(child: Container()),
              (controller.nowPage > 1)
                  ? GestureDetector(
                      onTap: () async {
                        await controller.getPageComment(
                            controller.detail.code, controller.nowPage - 1);
                      },
                      child: Icon(Icons.arrow_back_ios, color: Colors.white),
                    )
                  : Container(),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(text: controller.nowPage.toString()),
                  TextSpan(text: " / "),
                  TextSpan(text: controller.lastPage.toString()),
                ]),
              ),
              (controller.nowPage < controller.lastPage)
                  ? GestureDetector(
                      onTap: () async {
                        await controller.getPageComment(
                            controller.detail.code, controller.nowPage + 1);
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
