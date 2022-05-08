//import 'package:flutter/material.dart';
//import 'package:heathee/keyword/color.dart';
//
//class BottomAppBar extends StatefulWidget {
//  @override
//  _BottomAppBarState createState() => _BottomAppBarState();
//}
//
//class _BottomAppBarState extends State<BottomAppBar> {
//  PageController _pageCon;
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _pageCon = PageController(initialPage: 2);
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        bottomNavigationBar: BottomAppBar(
//          color: CONTENT_COLOR,
//          child: Row(
//            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              IconButton(
//                color: Colors.white,
//                disabledColor: BACKGROUND_COLOR,
//                icon: Icon(Icons.person),
//                onPressed: () {
//                  setState(() {
//                    print('마이페이지 눌림');
//                    _pageCon.jumpToPage(0);
//                  });
//                },
//              ),
//              IconButton(
//                color: Colors.white,
//                disabledColor: BACKGROUND_COLOR,
//                icon: Icon(Icons.person_add),
//                onPressed: () {
//                  setState(() {
//                    print('구독페이지 눌림');
//                    _pageCon.jumpToPage(1);
//                  });
//                },
//              ),
//              IconButton(
//                color: Colors.white,
//                disabledColor: BACKGROUND_COLOR,
//                icon: Icon(Icons.home),
//                onPressed: () {
//                  setState(() {
//                    print('home 눌림');
//                    _pageCon.jumpToPage(2);
//                  });
//                },
//              ),
//              IconButton(
//                color: Colors.white,
//                disabledColor: BACKGROUND_COLOR,
//                icon: Icon(Icons.chat_bubble),
//                onPressed: () {
//                  setState(() {
//                    print('chat 눌림');
//                    _pageCon.jumpToPage(3);
//                  });
//                },
//              ),
//              IconButton(
//                  color: Colors.white,
//                  disabledColor: BACKGROUND_COLOR,
//                  icon: Icon(Icons.brightness_low),
//                  onPressed: () async {
//                    setState(() {
//                      print('환경설정 눌림');
//                      _pageCon.jumpToPage(4);
//                    });
////                    var result = await send('/logout');
////                    if (result.ok) {
////                      login.logout();
////                      Provider.of<MyUser>(context, listen: false)
////                          .setMyUser(null, null, false);
////                      Navigator.of(context).popUntil((route) => route.isFirst);
////                    }
//                  })
//            ],
//          ),
//        ),
//        backgroundColor: Color(0xff7C8395),
//        body: PageView(
//          controller: _pageCon,
//          onPageChanged: (int) {
//            print('page changed');
//          },
//          children: <Widget>[
//
//            Center(
//              child: Container(
//                child: Text('마이페이지'),
//              ),
//            ),
//            Center(
//              child: Container(
//                child: Text('구독 페이지'),
//              ),
//            ),
//            Center(
//              child: Container(
//                child: Text('환경설정페이지'),
//              ),
//            ),
//          ],
//        )
//    );
//  }
//}
