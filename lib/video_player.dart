

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VidoePlayer extends StatefulWidget {
//   const VidoePlayer({ Key key }) : super(key: key);

//   @override
//   _VidoePlayerState createState() => _VidoePlayerState();
// }

// class _VidoePlayerState extends State<VidoePlayer> {

//    VideoPlayerController _controller;
//   bool initialized = false;
//   bool isLiked = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset("http://techslides.com/demos/sample-videos/small.mp4")
//       ..initialize().then((value) {
//         setState(() {
//           _controller.setLooping(true);
//           initialized = true;
//         });
//       });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }