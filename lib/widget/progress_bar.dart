import 'package:flutter/material.dart';
import 'package:heathee/keyword/color.dart';

Widget progressTile(String item) {
  return ListTile(
    leading: Text(item),
    title: progressIndicator(),
    onTap: () {},
  );
}

Widget progressIndicator() {
  return Container(
    decoration:
        BoxDecoration(border: Border.all(width: 1.0, color: Colors.white)),
    child: LinearProgressIndicator(
      value: 0.5,
      valueColor: AlwaysStoppedAnimation(Colors.white),
      backgroundColor: BACKGROUND_COLOR,
      semanticsLabel: 'test',
    ),
  );
}

Widget progressContent(items) {
  return (items.length == 0)
      ? Text(
          "+를 눌러 목표를 추가해보세요",
          style:
              TextStyle(fontFamily: "JUA", fontSize: 20, color: Colors.white),
        )
      : Flexible(
          child: Container(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index < items.length) {
                    return progressTile(items[index]);
                  }
                  return Container(
                    width: 0.0,
                    height: 0.0,
                  );
                }),
          ),
        );
}
