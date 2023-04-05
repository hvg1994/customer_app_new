import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:gwc_customer/widgets/vlc_player/vlc_player_with_controls.dart';
import 'package:sizer/sizer.dart';
import 'package:wakelock/wakelock.dart';

import '../../widgets/constants.dart';

class VideoPlayerMeedu extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerMeedu({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerMeedu> createState() => _VideoPlayerMeeduState();
}

class _VideoPlayerMeeduState extends State<VideoPlayerMeedu> {
  // read the documentation https://the-meedu-app.github.io/flutter-meedu-player/#/picture-in-picture
  // to enable the pip (picture in picture) support on Android
  // final _meeduPlayerController = MeeduPlayerController(
  //   controlsStyle: ControlsStyle.primary,
  // );

  VlcPlayerController? _controller;
  final _key = GlobalKey<VlcPlayerWithControlsState>();


  // StreamSubscription? _playerEventSubs;

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
      initVideoView(widget.videoUrl);
    });
  }

  initVideoView(String url) {
    print("init url: $url");
    _controller = VlcPlayerController.network(
      // url ??
      Uri.parse(
          url
        // 'https://gwc.disol.in/storage/uploads/users/recipes/Calm Module - Functional (AR).mp4'
      )
          .toString(),
      hwAcc: HwAcc.full,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(true),
          VlcSubtitleOptions.fontSize(30),
          VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
          VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
          // works only on externally added subtitles
          VlcSubtitleOptions.color(VlcSubtitleColor.navy),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),

    );


    print(
        "_controller.isReadyToInitialize: ${_controller!.isReadyToInitialize}");
    _controller!.addOnInitListener(() async {
      await _controller!.startRendererScanning();
    });
    final _ori = MediaQuery.of(context).orientation;
    print(_ori.name);
    bool isPortrait = _ori == Orientation.portrait;
    if(isPortrait){
      AutoOrientation.landscapeAutoMode();
    }

  }

  wake() async{
    if(!await Wakelock.enabled){
      Wakelock.enable();
    }
  }


  @override
  void dispose() async{
    // The next line disables the wakelock again.
    Wakelock.disable();
    if(_controller != null ) _controller!.dispose();
    if(await Wakelock.enabled){
      Wakelock.disable();
    }
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
          body: SafeArea(
            child: LayoutBuilder(
              builder: (_, constraints){
                return Container(
                  color: Colors.black,
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Center(
                    child: AspectRatio(
                        aspectRatio: constraints.maxWidth/constraints.maxHeight,
                        child: VlcPlayerWithControls(
                          key: _key,
                          controller: _controller!,
                          virtualDisplay: true,
                          showVolume: false,
                          showVideoProgress: true,
                          seekButtonIconSize: 10.sp,
                          playButtonIconSize: 14.sp,
                          replayButtonSize: 14.sp,
                          showFullscreenBtn: true,
                        )
                      // MeeduVideoPlayer(
                      //   controller: _meeduPlayerController,
                      // ),
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
          if(!isPortrait){
            AutoOrientation.portraitUpMode();
          }
          print("isPortrait: $isPortrait");
          return (isPortrait) ?  Future.value(true) : Future.value(false);
        }
    );
  }
}
