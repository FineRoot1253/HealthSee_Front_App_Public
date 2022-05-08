import 'package:flutter/material.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/widget/dialog.dart';

class BoardFilePart extends StatefulWidget {
  final file;
  const BoardFilePart({Key key, this.file}) : super(key: key);

  @override
  _BoardFilePartState createState() => _BoardFilePartState();
}

class _BoardFilePartState extends State<BoardFilePart> {
  var isOpen = false;
  bool downloading = false;
  bool isComplete = false;
  var blob;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.attachment,
                color: Colors.white,
              ),
              Text(
                (widget.file != []) ? " 첨부파일 ${widget.file.length}" : " 첨부파일 0",
                style: TextStyle(color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                child: Text(
                  (isOpen) ? " 접기 " : " 펴기 ",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        (isOpen)
            ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.file.length,
                itemBuilder: (context, i) {
                  return buildFile(i);
                })
            : Container()
      ],
    );
  }

  Widget buildFile(int i) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ((widget.file != []))
            ? GestureDetector(
                onTap: () async {
                  if (await yesOrNoDialog(
                      "파일 다운로드", "${widget.file[i].name}를 다운로드 하시겠습니까?")) {
                    downloadDialog("http://$IP$BOARDDOWNLOAD/", widget.file[i]);
                  }
                },
                child: Text(
                  "${widget.file[i].name}",
                  style: TextStyle(color: Colors.white),
                ),
              ) // 파일이 여러개일 수 있어서 일단 분해해둠.
            : Text(
                "첨부된 파일이 없습니다",
                style: TextStyle(color: Colors.white),
              ),
        Container(
          height: 10,
        )
      ],
    );
  }
}
