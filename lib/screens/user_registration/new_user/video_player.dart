import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/vlc_player/vlc_player_with_controls.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  final _key = GlobalKey<VlcPlayerWithControlsState>();

  late VlcPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VlcPlayerController.network(
      'https://gwc.disol.in/img/small.mp4',
      // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
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
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AspectRatio(
        aspectRatio: 16/9,
        child: VlcPlayerWithControls(
          key: _key,
          controller: _videoPlayerController,
          showVolume: false,
        ),
      ),
    );
  }
}
