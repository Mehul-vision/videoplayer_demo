import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer_demo/player/videoplayer_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'Videos.dart';
import 'globals.dart';

class SlidingPanel extends StatefulWidget {
  final VideoModel video;
  SlidingPanel([this.video]);

  @override
  _SlidingPanelState createState() => _SlidingPanelState();
}

class _SlidingPanelState extends State<SlidingPanel>
    with SingleTickerProviderStateMixin {
  int videoId = 0;
  PanelController _pc = new PanelController();
  PanelController _pc2 = new PanelController();
  PanelController _pc3 = new PanelController();
  VideoPlayerController videoController;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int _active;
  var jsonData;
  var _getVideoResult;
  // var _playVideo;
  bool allPaused;
  Map<dynamic, dynamic> map = {};
  bool showLoader = true;
  bool likeShowLoader = false;
  int index = 1;
  int totalRows = 0;
  int nosVideos = 0;
  int page = 1;
  int loginUserId = 0;
  String appToken = '';
  List videoList = [];
  var response;
  int following = 0;
  int isFollowingVideos = 0;
  VideoModelList videoModelList;
  bool userFollowSuggestion = false;
  bool showFollowingPage = false;
  bool isLoggedIn = false;
  String totalLikes = '0';
  bool isLiked = false;
  bool videoInitialized = false;
  AnimationController animationController;
  //homepage Varaible end
  //action bar variable
  static const double ActionWidgetSize = 60.0;
  static const double ProfileImageSize = 50.0;
  // static const double PlusIconSize = 20.0;
  int soundId = 0;
  int userId = 0;
  String totalComments = '0';
  String userDP = '';
  String soundImageUrl = '';
  int isFollowing = 0;
  bool followUnfollowLoader = false;
  String encodedVideoId = '';
  String selectedType;
  String encKey = 'yfmtythd84n4h';
  String description = '';
  SwiperController swipeController;

  int swiperIndex = 0;
  bool initializePage = true;
  GlobalKey<FormState> _key = new GlobalKey();

  bool videoStarted = true;
  setVideoController(vController) {
    print("setVideoControllerabc");
    print(vController);
//    setState(() {
    videoController = vController;
//    });
//    if (videoController.value.position > Duration(seconds: 0)) {
  }

  checkLoggedInUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var userId =
          (pref.getInt('user_id') == null) ? 0 : pref.getInt('user_id');
      appToken = (pref.getString('app_token') == null)
          ? ''
          : pref.getString('app_token');
      loginUserId = userId;
      if (userId > 0) {
        isLoggedIn = true;
      } else {
        isLoggedIn = false;
      }
    });
  }

  final List<String> videos = [
    'https://assets.mixkit.co/videos/preview/mixkit-young-mother-with-her-little-daughter-decorating-a-christmas-tree-39745-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-taking-photos-from-different-angles-of-a-model-34421-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-cold-looking-woman-concept-video-39874-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-the-pool-1261-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'
  ];
  @override
  void initState() {
    super.initState();
    // _fabHeight = _initFabHeight;
    videoId = 1;
    // getUserId();
    checkLoggedInUser();
    _getVideoResult = _getVideos();
    // videoList.addAll(videos);
    super.initState();
    _active = 2;
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 10),
    );

    animationController.repeat();
    Timer(Duration(seconds: 2), () {
      checkVideoStarted();
    });
  }

  checkVideoStarted() {
    print("checkVideoStarted");
    if (videoController == null) {
      print("video Controller Null");
    } else {
      print("if videoController != null");
      videoController.initialize().then((_) {
        print("if videoController.initialize");
        setState(() {
          videoStarted = true;
        });
      });
    }
  }

  @override
  void dispose() {
    // Ensure disposing of the CachedVideoPlayerController to free up resources.
    videoController.pause();
    videoController.dispose();
    super.dispose();
  }

  onVideoChange(VideoModel video) {
    setState(() {
      videoId = video.videoId;
    });
  }

  _getVideos() async {
    print("_getVideos()");
    setState(() {
      showLoader = true;
    });
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int userId = 0;
    int videoId = 0;
    if (widget.video != null) {
      userId = widget.video.userId;
      videoId = widget.video.videoId;
    }
    Dio dio = new Dio();
    dio.options.baseUrl = apiUrlRoot;
    try {
      var response = await dio.get("api/v1/get-videos",
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'USER': apiUser,
              'KEY': apiKey,
            },
          ),
          queryParameters: {
            "page_size": 10,
            "search": "",
            "page": page,
            "user_id": userId,
            "video_id": videoId,
            "login_id":
                (pref.getInt('user_id') == null) ? 0 : pref.getInt('user_id'),
            "following": following,
          });
      if (response.data['status'] == 'success') {
        isFollowingVideos = response.data['is_following_videos'];
        jsonData = response.data;
        print("jsonData");
        print(jsonData);
        var map = Map<String, dynamic>.from(jsonData);
        var res = VideoModelPageList.fromJson(map);
        VideoModelPageList videoPageList = res;
        var mapVideoPageLst = Map<String, dynamic>.from(videoPageList.data);
        videoModelList = VideoModelList.fromJson(mapVideoPageLst);
        videoList.addAll(videoModelList.data);
        onVideoChange(videoList[0]);
        setState(() {
          totalRows = videoModelList.total;
          nosVideos = videoList.length;
          showLoader = false;
          userFollowSuggestion = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _onRefresh() async {
    print("_onRefresh");
    // monitor network fetch
//    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => HomePage(),
    //   ),
    // );
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Swiper(
      itemCount: videoList.length,
      scrollDirection: Axis.vertical,
      controller: swipeController,
      loop: false,
      onIndexChanged: (index) {
        print("index $index");
        onVideoChange(videoList[index]);
        setState(() {
          videoInitialized = false;
        });
        if (index > 0) {
          setState(() {
            initializePage = false;
          });
        }
        setState(() {
          swiperIndex = index;
          videoStarted = false;
        });
        if (totalRows > nosVideos && index == (nosVideos - 1)) {
          setState(() {
            page++;
            _getVideos();
          });
        }
      },
      itemBuilder: (BuildContext context, int index) {
        // VideoModel video = videoList[index];
        return new Stack(
          fit: StackFit.loose,
          children: <Widget>[
            Container(
              color: Colors.black,
              child: VideoPlayerApp(
                // _pc,
                _pc3,
                videoList[index],
                setVideoController,
                /* (videoInit) {
                                      print(
                                          "videoInitEnter $videoInitialized");
                                      setState(() {
                                        videoInitialized = videoInit;
                                        print(
                                            "videoInitLeave $videoInitialized");
                                      });
                                    }*/
              ),
            ),
            Column(
              children: <Widget>[
                // Top section
                // Middle expanded
                // Expanded(
                //   child: Container(
                //     child: Row(
                //         mainAxisSize: MainAxisSize.max,
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: <Widget>[
                //           VideoDescription(
                //             videoList[index],
                //             _pc3,
                //           ),
                //           // ActionsToolbar(
                //           //   widget._pc,
                //           //   widget._pc2,
                //           //   widget._pc3,
                //           //   videoList[index],
                //           //   this.updateLike,
                //           //   this.updateFollowingVariable,
                //           // ),
                //           sidebar(index)
                //         ]),
                //   ),
                // ),
                SizedBox(
                  height: 70.0,
                ),
              ],
            ),
            (swiperIndex == 0 && !initializePage)
                ? SafeArea(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width,
//                                            color: Colors.black87,
                      color: Colors.transparent,
                      child: RefreshConfiguration(
                        springDescription: SpringDescription(
                          stiffness: 170,
                          damping: 16,
                          mass: 1.9,
                        ), // custom spring back animate,the props meaning see the flutter api
                        child: SmartRefresher(
                          controller: _refreshController,
                          header: WaterDropMaterialHeader(
                            backgroundColor: Colors.pinkAccent,
                            color: Colors.black87,
                          ),
                          enablePullDown: (swiperIndex == 0) ? true : false,
                          onRefresh: _onRefresh,
                          child: SwipeDetector(
                            onSwipeUp: () {
                              print("onSwipeUp");
                              setState(() {
                                videoInitialized = true;
                              });
                            },
                            child: Container(),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      },
    ));
  }
}
