import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/vlc_player/vlc_player_with_controls.dart';

class NewKnowMoreScreen extends StatefulWidget {
  final String knowMore;
  final String healAtHome;
  final String healAnywhere;
  final String whenToReachUs;
  const NewKnowMoreScreen(
      {Key? key,
      required this.knowMore,
      required this.healAtHome,
      required this.healAnywhere,
      required this.whenToReachUs})
      : super(key: key);

  @override
  State<NewKnowMoreScreen> createState() => _NewKnowMoreScreenState();
}

class _NewKnowMoreScreenState extends State<NewKnowMoreScreen> {
  final _key = GlobalKey<VlcPlayerWithControlsState>();
  VlcPlayerController? _videoPlayerController;

  addUrlToVideoPlayer(String url) {
    print("url" + url);
    _videoPlayerController = VlcPlayerController.network(
      Uri.parse(url).toString(),
      //  "https://gwc.disol.in/dist/img/GMG-Podcast-%20CMN.mp4",
      //  'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
      // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
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
    print('dispose');
    await _videoPlayerController!.stop();
    await _videoPlayerController!.stopRendererScanning();
    await _videoPlayerController!.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadAsset('placeholder.png');
  }

  ByteData? placeHolderImage;

  void loadAsset(String name) async {
    var data = await rootBundle.load('assets/images/$name');
    setState(() => placeHolderImage = data);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                buildAppBar(() {
                  Navigator.pop(context);
                }),
                TabBar(
                    // padding: EdgeInsets.symmetric(horizontal: 3.w),
                    labelColor: gBlackColor,
                    unselectedLabelColor: gHintTextColor,
                    isScrollable: true,
                    indicatorColor: gsecondaryColor,
                    labelPadding:
                        EdgeInsets.only(right: 8.w, top: 1.h, bottom: 1.h),
                    indicatorPadding: EdgeInsets.only(right: 5.w),
                    unselectedLabelStyle: TextStyle(
                        fontFamily: kFontBook,
                        color: gHintTextColor,
                        fontSize: 9.sp),
                    labelStyle: TextStyle(
                        fontFamily: kFontMedium,
                        color: gBlackColor,
                        fontSize: 11.sp),
                    tabs: const [
                      Text('Know More'),
                      Text("Heal At Home"),
                      Text('Heal Anywhere'),
                      Text("When To Reach Us?"),
                    ]),
                Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        buildKnowMoreDetails(),
                        buildHealAtHomeDetails(),
                        buildHealAnywhereDetails(),
                        buildWhenToReachUsDetails(),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildKnowMoreDetails() {
    final a = widget.knowMore;
    final file = a.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      addUrlToVideoPlayer(a);
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          // buildTestimonial(),
          buildZoomImage(widget.knowMore),
        ],
      ),
    );
  }

  buildHealAtHomeDetails() {
    final a = widget.healAtHome;
    final file = a.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      addUrlToVideoPlayer(a);
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          buildZoomImage(widget.healAtHome),
          // Container(
          //   height: 65.h,
          //   width: 100.w,
          //   margin: EdgeInsets.symmetric(vertical: 10.h),
          //   child: Center(
          //     child: PhotoView(
          //       imageProvider: CachedNetworkImageProvider(
          //           "${Uri.parse(widget.healAtHome)}"),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  buildHealAnywhereDetails() {
    final a = widget.healAnywhere;
    final file = a.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      addUrlToVideoPlayer(a);
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          buildZoomImage(widget.healAnywhere),
          // Container(
          //   height: 65.h,
          //   width: 100.w,
          //   margin: EdgeInsets.symmetric(vertical: 10.h),
          //   child: Center(
          //     child: PhotoView(
          //       imageProvider: CachedNetworkImageProvider(
          //           "${Uri.parse(widget.healAnywhere)}"),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  buildWhenToReachUsDetails() {
    final a = widget.whenToReachUs;
    final file = a.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      addUrlToVideoPlayer(a);
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          buildZoomImage(widget.whenToReachUs),
          // Container(
          //   height: 65.h,
          //   width: 100.w,
          //   margin: EdgeInsets.symmetric(vertical: 10.h),
          //   child: Center(
          //     child: PhotoView(
          //       imageProvider: CachedNetworkImageProvider(
          //           "${Uri.parse(widget.whenToReachUs)}"),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  buildZoomImage(String knowMore) {
    final file = knowMore.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Center(
          child: buildTestimonial(),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: InteractiveViewer(
          panEnabled: false, // Set it to false
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 0.5,
          maxScale: 2,
          child: Center(
            child: FadeInImage.memoryNetwork(
              placeholder: placeHolderImage!.buffer.asUint8List(),
              image: "${Uri.parse(knowMore)}",
            ),
          ),
          // Image.network(
          //   "${Uri.parse(knowMore)}",
          // ),
          // child: Center(
          //   child: PhotoView(
          //     imageProvider:
          //         CachedNetworkImageProvider("${Uri.parse(widget.knowMore)}"),
          //   ),
          // ),
        ),
      );
    }
  }

  buildTestimonial() {
    if (_videoPlayerController != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: gPrimaryColor, width: 1),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.3),
            //     blurRadius: 20,
            //     offset: const Offset(2, 10),
            //   ),
            // ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Center(
              child: VlcPlayerWithControls(
                key: _key,
                controller: _videoPlayerController!,
                showVolume: false,
                showVideoProgress: false,
                seekButtonIconSize: 10.sp,
                playButtonIconSize: 14.sp,
                replayButtonSize: 10.sp,
              ),
              // child: VlcPlayer(
              //   controller: _videoPlayerController!,
              //   aspectRatio: 16 / 9,
              //   virtualDisplay: false,
              //   placeholder: Center(child: CircularProgressIndicator()),
              // ),
            ),
          ),
          // child: Stack(
          //   children: <Widget>[
          //     ClipRRect(
          //       borderRadius: BorderRadius.circular(5),
          //       child: Center(
          //         child: VlcPlayer(
          //           controller: _videoPlayerController!,
          //           aspectRatio: 16 / 9,
          //           virtualDisplay: false,
          //           placeholder: Center(child: CircularProgressIndicator()),
          //         ),
          //       ),
          //     ),
          //     ControlsOverlay(controller: _videoPlayerController,)
          //   ],
          // ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  isPlaying() async {
    if (_videoPlayerController != null) {
      final value = await _videoPlayerController?.isPlaying();
      print("isPlaying: $value");
      return value;
    } else {
      return false;
    }
  }
}
