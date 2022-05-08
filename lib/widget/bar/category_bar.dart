import 'package:flutter/material.dart';

import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';

class CategoryBar extends StatelessWidget {
  String title;
  CategoryBar(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          color: CONTENT_COLOR,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: MENUBAR_TEXT_STYLE,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
