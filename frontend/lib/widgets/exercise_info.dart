import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/exercise_viewmodel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseInfo extends StatefulWidget {
  final List<String> images;
  final ExerciseViewModel exercise;

  const ExerciseInfo({super.key, required this.images, required this.exercise});

  @override
  State<ExerciseInfo> createState() => _ExerciseInfoState();
}

class _ExerciseInfoState extends State<ExerciseInfo> {
  // for embedded tutorial
  late final String videoId;
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.exercise.tutorialLink)!;
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: SafeArea(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.lightBlue,
              ),
            ),
          ),
          Text(widget.exercise.exerciseName),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
