import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:videoplayer_demo/example/tikTokVideoPlayer.dart';
import 'package:videoplayer_demo/example/video.dart';
import 'package:videoplayer_demo/example/video_page.dart';

class ExampleHome extends StatefulWidget {
  const ExampleHome({Key key}) : super(key: key);

  @override
  _ExampleHomeState createState() => _ExampleHomeState();
}

class _ExampleHomeState extends State<ExampleHome> with WidgetsBindingObserver {
  PageController _pageController = PageController();
  VideoListController _videoListController = VideoListController();
  List<UserVideo> videoDataList = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _videoListController.currentPlayer.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoListController.currentPlayer.pause();
    super.dispose();
  }

  @override
  void initState() {
    videoDataList = UserVideo.fetchVideo();
    WidgetsBinding.instance.addObserver(this);
    _videoListController.init(
      _pageController,
      videoDataList,
    );
    // tkController.addListener(
    //   () {
    //     if (tkController.value == TikTokPagePositon.middle) {
    //       _videoListController.currentPlayer.start();
    //     } else {
    //       _videoListController.currentPlayer.pause();
    //     }
    //   },
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double a = MediaQuery.of(context).size.aspectRatio;
    bool hasBottomPadding = a < 0.55;
    return Scaffold(
      body: PageView.builder(
        key: Key('home'),
        controller: _pageController,
        pageSnapping: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _videoListController.videoCount,
        itemBuilder: (context, i) {
          var data = videoDataList[i];
          // bool isF = SafeMap(favoriteMap)[i].boolean ?? false;
          var player = _videoListController.playerOfIndex(i);

          // video
          Widget currentVideo = Center(
            child: FijkView(
              fit: FijkFit.fitHeight,
              player: player,
              color: Colors.black,
              panelBuilder: (_, __, ___, ____, _____) => Container(),
            ),
          );

          currentVideo = TikTokVideoPage(
            hidePauseIcon: player.state != FijkState.paused,
            aspectRatio: 9 / 16.0,
            key: Key(data.url + '$i'),
            tag: data.url,
            bottomPadding: hasBottomPadding ? 16.0 : 16.0,
            userInfoWidget: VideoUserInfo(
              desc: data.desc,
              bottomPadding: hasBottomPadding ? 16.0 : 50.0,
              // onGoodGift: () => showDialog(
              //   context: context,
              //   builder: (_) => FreeGiftDialog(),
              // ),
            ),
            onSingleTap: () async {
              if (player.state == FijkState.started) {
                await player.pause();
              } else {
                await player.start();
              }
              setState(() {});
            },
            onAddFavorite: () {
              // setState(() {
              //   favoriteMap[i] = true;
              // });
            },
            // rightButtonColumn: buttons,
            video: currentVideo,
          );
          return currentVideo;
        },
      ),
    );
  }
}
