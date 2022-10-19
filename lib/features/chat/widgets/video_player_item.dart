import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlay = false;
  bool finishedPlaying = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then(
        (value) => videoPlayerController.setVolume(1),
      );
    videoPlayerController.addListener(() {
      setState(() {
      });
      if (videoPlayerController.value.duration == videoPlayerController.value.position) {
        setState(() {
          isPlay = false;
          finishedPlaying = true;
        });
      } else {
        setState(() {
          finishedPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (finishedPlaying) {
                  videoPlayerController.seekTo(Duration.zero);
                  videoPlayerController.play(); // Replay the video
                }
                if (isPlay) {
                  videoPlayerController.pause();
                } else {
                  videoPlayerController.play();
                }
                setState(() {
                  isPlay = !isPlay;
                });
              },
              icon: Icon(
                finishedPlaying
                    ? Icons.replay
                    : isPlay
                        ? Icons.pause_circle
                        : Icons.play_circle,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
