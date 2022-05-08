import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/api/timeset.dart';
import 'package:heathee/controller/album/album_main_controller.dart';
import 'package:heathee/model/album/album_list.dart';
import 'package:heathee/screen/album/widget/album_button_bar.dart';
import 'package:heathee/screen/album/widget/album_post_widget.dart';
import 'package:heathee/screen/album/widget/album_sliver_header.dart';

class AlbumSliverWidget extends StatelessWidget {

  final List<List<AlbumList>> albumList;
  final AlbumMainController albumMainController;

  AlbumSliverWidget({this.albumMainController,this.albumList});

  @override
  Widget build(BuildContext context) {
    print("뿅");
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: albumMainController.mainScrollController,
      slivers: List.generate(albumList.length*2, (sideIndex){
        return (sideIndex%2 == 1) ? SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5,),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return AlbumPost(albumMainController,albumList[(sideIndex/2).floor()][index]);
            },
            childCount: albumList[(sideIndex/2).floor()].length,
          ),
        ) : makeHeader(getDate(albumList[(sideIndex/2).floor()][0].AL_Creation_Date, "MONTH").toString()+"월");
      })

//      _buildList(getDate(albumList[][0].AL_Creation_Date, "MONTH").toString()+"월")
    );
  }
//List.generate(albumList.length, (index){
//return SliverList(
//delegate: SliverChildListDelegate(_buildList(index)),
//);
  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: Get.height*0.07,
        maxHeight: Get.height*0.1,
        child: AlbumMenuBar(albumMainController,headerText,'추가'),
      ),
    );
  }
}
