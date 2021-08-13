import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:videoplayer_demo/example/video.dart';

// class VideoInfo {
//   final String url;
//   final String title;

//   VideoInfo(this.url, this.title);
// }

class VideoListController {
  VideoListController();

  void setPageContrller(PageController pageController) {
    pageController.addListener(() {
      var p = pageController.page;
      if (p % 1 == 0) {
        int target = p ~/ 1;
        if (index.value == target) return;

        var oldIndex = index.value;
        var newIndex = target;
        playerOfIndex(oldIndex).seekTo(0);
        playerOfIndex(oldIndex).pause();
        playerOfIndex(newIndex).start();

        index.value = target;
      }
    });
  }

  FijkPlayer playerOfIndex(int index) => playerList[index];

  int get videoCount => playerList.length;

  addVideoInfo(List<UserVideo> list) {
    for (var info in list) {
      playerList.add(
        FijkPlayer()
          ..setDataSource(
            info.url,
            autoPlay: playerList.length == 0,
            showCover: true,
          )
          ..setLoop(0),
      );
    }
  }

  /// 初始化
  init(PageController pageController, List<UserVideo> initialList) {
    addVideoInfo(initialList);
    setPageContrller(pageController);
  }

  /// 目前的视频序号
  ValueNotifier<int> index = ValueNotifier<int>(0);

  /// 视频列表
  List<FijkPlayer> playerList = [];

  ///
  FijkPlayer get currentPlayer => playerList[index.value];

  bool get isPlaying => currentPlayer.state == FijkState.started;

  /// 销毁全部
  void dispose() {
    // 销毁全部
    for (var player in playerList) {
      player.dispose();
    }
    playerList = [];
  }
}
