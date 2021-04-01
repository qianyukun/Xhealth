import 'dart:async';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:health/common/EventConstants.dart';
import 'package:health/report/ReportUtil.dart';
import 'package:health/widget/SeekBar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'AudioController.dart';
import 'package:health/extension/ScreenExtension.dart';

class SoundRoute extends StatefulWidget {
  static const String soundName = "sound";

  @override
  State<StatefulWidget> createState() {
    return _SoundRouteState();
  }
}

class _SoundRouteState extends State<SoundRoute> {
  AudioPlayer _player;
  int currentPlaylistIndex = 0;
  bool panelVisible = true;

  var playlistPosition = Duration();
  var playlistBufferedPosition = Duration();
  var lastPosition = Duration();
  var lastBufferedPosition = Duration();

  List<String> bgList = [
    "imgs/sound/backgroud_sounds_1.jpg",
    "imgs/sound/backgroud_sounds_2.jpg",
    "imgs/sound/backgroud_sounds_3.jpg",
    "imgs/sound/backgroud_sounds_4.jpg",
    "imgs/sound/backgroud_sounds_5.jpg",
  ];

  int bg_index = 0;
  final _playlist = [
    LoopingAudioSource(
        child: AudioSource.uri(
            Uri.parse("asset:///audio/2 - Stream Flowing.mp3"),
            tag: AudioMetadata(
                "Stream Flowing", "asset:///audio/2 - Stream Flowing.mp3")),
        count: 11),
    LoopingAudioSource(
        child: AudioSource.uri(
            Uri.parse("asset:///audio/3 -Greek Meditation.mp3"),
            tag: AudioMetadata(
                "Greek Meditation", "asset:///audio/3 -Greek Meditation.mp3")),
        count: 3),
    LoopingAudioSource(
        child: AudioSource.uri(Uri.parse("asset:///audio/4 - Thunder.mp3"),
            tag: AudioMetadata("Thunder", "asset:///audio/4 - Thunder.mp3")),
        count: 30),
    LoopingAudioSource(
        child: AudioSource.uri(
            Uri.parse("asset:///audio/7 - Walking in Snow.mp3"),
            tag: AudioMetadata(
                "Walking in Snow", "asset:///audio/7 - Walking in Snow.mp3")),
        count: 30),
    LoopingAudioSource(
        child: AudioSource.uri(Uri.parse("asset:///audio/8 - Horse Eating.mp3"),
            tag: AudioMetadata(
                "Horse Eating", "asset:///audio/8 - Horse Eating.mp3")),
        count: 80),
    LoopingAudioSource(
        child: AudioSource.uri(Uri.parse("asset:///audio/9 - Evening .mp3"),
            tag: AudioMetadata("Evening", "asset:///audio/9 - Evening .mp3")),
        count: 14),
    LoopingAudioSource(
        child: AudioSource.uri(
            Uri.parse("asset:///audio/10 - Farm Morning.mp3"),
            tag: AudioMetadata(
                "Farm Morning", "asset:///audio/10 - Farm Morning.mp3")),
        count: 9),
    LoopingAudioSource(
        child: AudioSource.uri(Uri.parse("asset:///audio/11 - Crickets.mp3"),
            tag: AudioMetadata("Crickets", "asset:///audio/11 - Crickets.mp3")),
        count: 14),
    LoopingAudioSource(
        child: AudioSource.uri(Uri.parse("asset:///audio/13 - Fire.mp3"),
            tag: AudioMetadata("Fire", "asset:///audio/13 - Fire.mp3")),
        count: 5),
  ];

  Timer autoInvisible;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setLoopMode(LoopMode.off);
    bg_index = Random(DateTime.now().millisecond).nextInt(bgList.length);
    _initPlayer();
    autoInvisible = Timer(Duration(seconds: 10), () {
      if (_player.playing) {
        if (panelVisible) {
          setState(() {
            panelVisible = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  buildBody() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(bgList[bg_index % bgList.length]),
              fit: BoxFit.cover)),
      child: Container(
        child: Stack(
          children: [
            Opacity(
              opacity: panelVisible ? 1.0 : 0.0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    panelVisible = !panelVisible;
                    if (panelVisible) {
                      startAutoVisible();
                    } else {
                      autoInvisible?.cancel();
                    }
                  });
                },
                child: _buildVisiblePanel(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: AudioController(
                  _player, panelVisible, _nextAudio, _preAudio, _retryAudio),
            ),
            SafeArea(
                child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                iconSize: 54.pt,
                icon: Image.asset("imgs/common/bt_close_white.png"),
                onPressed: _onBackPress,
              ),
            ))
          ],
        ),
      ),
    );
  }

  _buildSeekBar() {
    return StreamBuilder<Duration>(
      stream: _player.durationStream,
      builder: (context, snapshot) {
        final singleAudioDuration = snapshot.data ?? Duration.zero;
        final totalDuration =
            singleAudioDuration * (_player.effectiveIndices?.length ?? 1);
        return StreamBuilder<PositionData>(
            stream: Rx.combineLatest2<Duration, Duration, PositionData>(
                _player.positionStream, _player.bufferedPositionStream,
                (_position, _bufferedPosition) {
              if (lastPosition - _position > singleAudioDuration ~/ 2) {
                playlistPosition += singleAudioDuration;
              }

              if (_bufferedPosition < lastBufferedPosition) {
                playlistBufferedPosition += singleAudioDuration;
              }
              var positionData = PositionData(playlistPosition + _position,
                  playlistBufferedPosition + _bufferedPosition);

              lastPosition = _position;
              lastBufferedPosition = _bufferedPosition;

              return positionData;
            }),
            builder: (context, snapshot) {
              final positionData =
                  snapshot.data ?? PositionData(Duration.zero, Duration.zero);

              var position = positionData.position;
              if (position > totalDuration) {
                position = totalDuration;
              }

              var bufferedPosition = positionData.bufferedPosition;
              if (bufferedPosition > totalDuration) {
                bufferedPosition = totalDuration;
              }
              return SeekBar(
                duration: totalDuration,
                bufferedPosition: bufferedPosition,
                position: position,
                // onChangeEnd: (newPosition) {
                //   _player.seek(newPosition);
                // },
              );
            });
      },
    );
  }

  _buildVisiblePanel() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black.withOpacity(0.1),
      child: StreamBuilder<SequenceState>(
        stream: _player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state?.sequence?.isEmpty ?? true) return SizedBox();
          final metadata = state.currentSource.tag as AudioMetadata;
          return SafeArea(
              child: Container(
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 128.pt),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            metadata.title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.pt,
                                fontWeight: FontWeight.w600),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: _buildSeekBar(),
                          ))
                    ],
                  )));
        },
      ),
    );
  }

  Future<void> _initPlayer() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration.speech());
      await _player
          .setAudioSource(_playlist[currentPlaylistIndex % _playlist.length]);
      await _player.play();
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occur $e");
    }
  }

  _nextAudio() async {
    if (!panelVisible) {
      return;
    }
    startAutoVisible();
    try {
      _reportSoundPlayedDuration();
      ReportUtil.getInstance()
          .trackEvent(eventName: EventConstants.sounds_next);
      playlistPosition = Duration();
      playlistBufferedPosition = Duration();
      lastPosition = Duration();
      lastBufferedPosition = Duration();
      setState(() {
        bg_index = Random(DateTime.now().millisecond).nextInt(bgList.length);
      });
      await _player
          .setAudioSource(_playlist[++currentPlaylistIndex % _playlist.length]);
      await _player.play();
    } catch (e) {
      print("An error occur $e");
    }
  }

  _preAudio() async {
    if (!panelVisible) {
      return;
    }
    startAutoVisible();
    try {
      _reportSoundPlayedDuration();
      ReportUtil.getInstance()
          .trackEvent(eventName: EventConstants.sounds_previous);
      playlistPosition = Duration();
      playlistBufferedPosition = Duration();
      lastPosition = Duration();
      lastBufferedPosition = Duration();
      setState(() {
        bg_index = Random(DateTime.now().millisecond).nextInt(bgList.length);
      });
      await _player
          .setAudioSource(_playlist[--currentPlaylistIndex % _playlist.length]);
      await _player.play();
    } catch (e) {
      print("An error occur $e");
    }
  }

  _retryAudio() async {
    _reportSoundPlayedDuration();
    try {
      playlistPosition = Duration();
      playlistBufferedPosition = Duration();
      lastPosition = Duration();
      lastBufferedPosition = Duration();
      await _player
          .setAudioSource(_playlist[currentPlaylistIndex % _playlist.length]);
      await _player.play();
    } catch (e) {
      print("An error occur $e");
    }
  }

  @override
  void dispose() {
    _reportSoundPlayedDuration();
    _player.dispose();
    autoInvisible?.cancel();
    super.dispose();
  }

  void _onBackPress() {
    ReportUtil.getInstance().trackEvent(eventName: EventConstants.sounds_back);
    Navigator.of(context).pop();
  }

  void startAutoVisible() {
    autoInvisible?.cancel();
    autoInvisible = Timer(Duration(seconds: 10), () {
      if (_player.playing) {
        if (panelVisible) {
          setState(() {
            panelVisible = false;
          });
        }
      }
    });
  }

  void _reportSoundPlayedDuration() {
    Map<String, dynamic> map = Map();
    try {
      map.putIfAbsent(
          "name",
          () => (_playlist[currentPlaylistIndex % _playlist.length]
                  .sequence[0]
                  .tag as AudioMetadata)
              .title);
    } catch (e) {}
    map.putIfAbsent("duration", () => lastPosition.inMilliseconds);
    ReportUtil.getInstance()
        .trackEvent(eventName: EventConstants.sounds_duration, parameters: map);
  }
}

class AudioMetadata {
  String title;
  String path;

  AudioMetadata(this.title, this.path);
}

class PositionData {
  final Duration position;

  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);

  @override
  String toString() {
    return 'PositionData{position: $position, bufferedPosition: $bufferedPosition}';
  }
}
