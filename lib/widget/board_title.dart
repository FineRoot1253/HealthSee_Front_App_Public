import 'package:flutter/material.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';

class BoardTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onLongPress: null,
      onPressed: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          color: CONTENT_COLOR,
          child: ListTile(
            trailing: Text(
              '''
            추천수 : 100
            조회수 : 100
            댓글수 : 100
            ''',
              style: LITTLE_TEXT_STYLE,
            ),
            title: Text(
              "글제목",
              style: TITLE_TEXT_STYLE,
            ),
            subtitle: Text(
              "작성자 : " + "홍종표",
              style: MENUBAR_TEXT_STYLE,
            ),
          ),
        ),
      ),
    );
  }
}
