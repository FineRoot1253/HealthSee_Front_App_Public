import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/board/board_main_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';

class MenuBar extends StatelessWidget {
  String title;
  String content;
  MenuBar(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: ClipPath(
              clipper: TrapeziumClipper(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                color: CONTENT_COLOR,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        style: MENUBAR_TEXT_STYLE,
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        content,
                        style: MENUBAR_TEXT_STYLE,
                      ),
                      onPressed: callback(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  callback() {
    return () {
      Get.toNamed("/boardList")
          .then((value) => Get.find<BoardMainController>().getBest());
    };
  }
}

class TrapeziumClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width * 2 / 3, 0.0);
    path.lineTo(0.0, size.height * 3.5);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, 0.0);
    path.lineTo(size.width * 2 / 3 + 20, 0.0);
    path.lineTo(0.0, size.height * 3.5 + 20);
    path.lineTo(0.0, size.height * 3.5 + 40);
    path.lineTo(size.width * 2 / 3 + 40, 0.0);
    path.lineTo(size.width * 2 / 3 + 60, 0.0);
    path.lineTo(0.0, size.height * 3.5 + 60);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width * 2 / 3 + 60, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TrapeziumClipper oldClipper) => false;
}
