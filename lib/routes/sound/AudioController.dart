import 'package:flutter/material.dart';
import 'package:health/common/EventConstants.dart';
import 'package:health/report/ReportUtil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:health/extension/ScreenExtension.dart';

class AudioController extends StatelessWidget {
  final AudioPlayer player;
  final VoidCallback _nextAudio;
  final VoidCallback _preAudio;
  final VoidCallback _retryAudio;
  final bool panelVisible;

  AudioController(this.player, this.panelVisible, this._nextAudio,
      this._preAudio, this._retryAudio);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // IconButton(
        //   icon: Icon(Icons.volume_up),
        //   onPressed: () {
        //     _showSliderDialog(
        //       context: context,
        //       title: "Adjust volume",
        //       divisions: 10,
        //       min: 0.0,
        //       max: 1.0,
        //       stream: player.volumeStream,
        //       onChanged: player.setVolume,
        //     );
        //   },
        // ),
        // StreamBuilder<SequenceState?>(
        //   stream: player.sequenceStateStream,
        //   builder: (context, snapshot) => IconButton(
        //     icon: Icon(Icons.skip_previous),
        //     onPressed: player.hasPrevious ? player.seekToPrevious : null,
        //   ),
        // ),
        Expanded(
            child: Opacity(
          opacity: panelVisible ? 1.0 : 0.0,
          child: IconButton(
            padding: EdgeInsets.only(right: 60),
            icon: Image.asset("imgs/sound/bt_sounds_previous.png"),
            onPressed: _preAudio,
          ),
        )),
        Expanded(
            child: StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return
                  // Container(
                  // margin: EdgeInsets.all(8.0.pt),
                  // width: 104.0.pt,
                  // height: 104.0.pt,
                  // child: CircularProgressIndicator(),
                  // );

                  IconButton(
                icon: Image.asset("imgs/sound/bt_pause_normal.png"),
                iconSize: 104.0.pt,
                onPressed: () {},
              );
            } else if (playing != true) {
              return IconButton(
                icon: Image.asset("imgs/sound/bt_play_normal.png"),
                iconSize: 104.0.pt,
                onPressed: () {
                  player.play();
                },
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Image.asset("imgs/sound/bt_pause_normal.png"),
                iconSize: 104.0.pt,
                onPressed: () {
                  ReportUtil.getInstance()
                      .trackEvent(eventName: EventConstants.sounds_pause);
                  player.pause();
                },
              );
            } else {
              return IconButton(
                  icon: Image.asset("imgs/sound/bt_replay_normal.png"),
                  iconSize: 104.0.pt,
                  onPressed: _retryAudio
                  // () =>
                  // player.seek(Duration.zero,
                  // index: player.effectiveIndices!.first),
                  );
            }
          },
        )),
        // StreamBuilder<SequenceState?>(
        //   stream: player.sequenceStateStream,
        //   builder: (context, snapshot) => IconButton(
        //     icon: Icon(Icons.skip_next),
        //     onPressed: player.hasNext ? player.seekToNext : null,
        //   ),
        // ),

        Expanded(
            child: Opacity(
          opacity: panelVisible ? 1.0 : 0.0,
          child: IconButton(
            padding: EdgeInsets.only(left: 60),
            icon: Image.asset("imgs/sound/bt_sounds_next.png"),
            onPressed: _nextAudio,
          ),
        )),
        // StreamBuilder<double>(
        //   stream: player.speedStream,
        //   builder: (context, snapshot) => IconButton(
        //     icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
        //         style: TextStyle(fontWeight: FontWeight.bold)),
        //     onPressed: () {
        //       _showSliderDialog(
        //         context: context,
        //         title: "Adjust speed",
        //         divisions: 10,
        //         min: 0.5,
        //         max: 1.5,
        //         stream: player.speedStream,
        //         onChanged: player.setSpeed,
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
