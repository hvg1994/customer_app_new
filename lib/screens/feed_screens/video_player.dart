import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:wakelock/wakelock.dart';

import '../../widgets/constants.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/widgets.dart';

class VideoPlayerMeedu extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerMeedu({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerMeedu> createState() => _VideoPlayerMeeduState();
}

class _VideoPlayerMeeduState extends State<VideoPlayerMeedu> {
  // VlcPlayerController? _controller;
  // final _key = GlobalKey<VlcPlayerWithControlsState>();
  //
  // initVideoView(String url) {
  //   print("init url: $url");
  //   _controller = VlcPlayerController.network(
  //     // url ??
  //     Uri.parse(
  //         url
  //       // 'https://gwc.disol.in/storage/uploads/users/recipes/Calm Module - Functional (AR).mp4'
  //     )
  //         .toString(),
  //     hwAcc: HwAcc.full,
  //     options: VlcPlayerOptions(
  //       advanced: VlcAdvancedOptions([
  //         VlcAdvancedOptions.networkCaching(2000),
  //       ]),
  //       subtitle: VlcSubtitleOptions([
  //         VlcSubtitleOptions.boldStyle(true),
  //         VlcSubtitleOptions.fontSize(30),
  //         VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
  //         VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
  //         // works only on externally added subtitles
  //         VlcSubtitleOptions.color(VlcSubtitleColor.navy),
  //       ]),
  //       http: VlcHttpOptions([
  //         VlcHttpOptions.httpReconnect(true),
  //       ]),
  //       rtp: VlcRtpOptions([
  //         VlcRtpOptions.rtpOverRtsp(true),
  //       ]),
  //     ),
  //
  //   );
  //
  //
  //   print(
  //       "_controller.isReadyToInitialize: ${_controller!.isReadyToInitialize}");
  //   _controller!.addOnInitListener(() async {
  //     await _controller!.startRendererScanning();
  //   });
  //   final _ori = MediaQuery.of(context).orientation;
  //   print(_ori.name);
  //   bool isPortrait = _ori == Orientation.portrait;
  //   if(isPortrait){
  //     AutoOrientation.landscapeAutoMode();
  //   }
  //
  // }

  @override
  void initState() {
    super.initState();
    // The following line will enable the Android and iOS wakelock.
    // _playerEventSubs = _meeduPlayerController.onPlayerStatusChanged.listen(
    //       (PlayerStatus status) {
    //     if (status == PlayerStatus.playing) {
    //       Wakelock.enable();
    //     } else {
    //       Wakelock.disable();
    //     }
    //   },
    // );

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // _init();
      initVideoChewieView(widget.videoUrl);
    });
  }

  VideoPlayerController? videoPlayerController;
  ChewieController? _chewieController;

  initVideoChewieView(String url) {
    print("init url: $url");

    videoPlayerController = VideoPlayerController.network(url);
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        fullScreenByDefault: true,
        hideControlsTimer: Duration(seconds: 3),
        showControls: true);

    final _ori = MediaQuery.of(context).orientation;
    print(_ori.name);
    bool isPortrait = _ori == Orientation.portrait;
    if (isPortrait) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

      // AutoOrientation.landscapeAutoMode();
    }

    setState(() {});
  }

  wake() async {
    if (!await Wakelock.enabled) {
      Wakelock.enable();
    }
  }

  @override
  void dispose() async {
    // if(_controller != null ) _controller!.dispose();
    if (await Wakelock.enabled) {
      Wakelock.disable();
    }
    if (_chewieController != null) _chewieController!.dispose();
    if (videoPlayerController != null) videoPlayerController!.dispose();

    super.dispose();
  }

  // _init() {
  //   _meeduPlayerController.setDataSource(
  //     DataSource(
  //       type: DataSourceType.network,
  //       source: widget.videoUrl,
  //     ),
  //     autoplay: true,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: gWhiteColor,
            centerTitle: false,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: gsecondaryColor,
                    size: 2.h,
                  ),
                ),
                SizedBox(width: 2.w),
                SizedBox(
                  height: 5.h,
                  child: const Image(
                    image: AssetImage("assets/images/Gut welness logo.png"),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (_, constraints) {
                print("_chewieController: $_chewieController");
                return Container(
                  color: Colors.black,
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: constraints.maxWidth / constraints.maxHeight,
                      child: (_chewieController == null)
                          ? Center(
                        child: buildCircularIndicator(),
                      )
                          : Chewie(
                        controller: _chewieController!,
                      ),
                      // child: VlcPlayerWithControls(
                      //   key: _key,
                      //   controller: _controller!,
                      //   virtualDisplay: true,
                      //   showVolume: false,
                      //   showVideoProgress: true,
                      //   seekButtonIconSize: 10.sp,
                      //   playButtonIconSize: 14.sp,
                      //   replayButtonSize: 14.sp,
                      //   showFullscreenBtn: true,
                      // )
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        onWillPop: () {
          final _ori = MediaQuery.of(context).orientation;
          bool isPortrait = _ori == Orientation.portrait;
          if (!isPortrait) {
            SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp],
            );
            // AutoOrientation.portraitUpMode();
          }
          print("isPortrait: $isPortrait");
          return (isPortrait) ? Future.value(true) : Future.value(false);
        });
  }
}
