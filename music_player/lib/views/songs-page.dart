import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/models/position-data.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/models/token.dart';
import 'package:music_player/services/song-service.dart';
import 'package:rxdart/rxdart.dart';

class SongsPage extends StatefulWidget {
  Token token;
  SongsPage({super.key, required this.token});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  late SongService songService;
  late Future<List<Song>?> songs;
  late Song? currentSong;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    songService = SongService();
    songs = songService.getSongs(widget.token.accessToken);
    currentSong = null;
    audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: MusicPlayer()));
  }

  Widget MusicPlayer() {
    return Column(children: [SongPlayer(currentSong), SongsList()]);
  }

  Widget SongsList() {
    return FutureBuilder(
      future: songs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (snapshot.data == null) {
            return Center(child: Text('Lấy danh sách bài hát thất bại'));
          }
          if (snapshot.data!.isEmpty) {
            return Center(child: Text('Không tồn tại bài hát nào'));
          }
          return Expanded(child: Songs(snapshot.data!));
        } else {
          return Expanded(child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget Songs(List<Song> songs) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
      itemCount: songs.length,

      itemBuilder: (context, index) {
        return SongItem(songs[index]);
      },

      separatorBuilder: (context, index) {
        return SizedBox(height: 5);
      },
    );
  }

  Widget SongItem(Song song) {
    return InkWell(
      onTap: () {
        setState(() {
          currentSong = song;
          audioPlayer.dispose();
          audioPlayer = AudioPlayer();
          audioPlayer.setUrl(song.source);
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          spacing: 20,
          children: [
            SizedBox(
              width: 20,
              child: Text(
                '${song.id}',
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(6),
              child: Image.network(
                song.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${song.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    '${song.singer}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget SongPlayer(Song? song) {
    if (song == null) {
      return Text('Bài hát chưa được tải');
    }
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(song.image, width: 200, height: 200, fit: BoxFit.cover),
          Text(song.name),
          Text(song.singer),
          SongSlider(),
          ToggleButton(),
        ],
      ),
    );
  }

  Widget ToggleButton() {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;

        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return const CircularProgressIndicator();
        }

        if (playing == false) {
          return IconButton(
            icon: const Icon(Icons.play_circle_filled),
            iconSize: 80,
            color: Colors.blue,
            onPressed: audioPlayer.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause_circle_filled),
            iconSize: 80,
            color: Colors.orange,
            onPressed: audioPlayer.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay_circle_filled),
            iconSize: 80,
            color: Colors.grey,
            onPressed: () {
              audioPlayer.pause();
              audioPlayer.seek(Duration.zero);
              audioPlayer.play();
            },
          );
        }
      },
    );
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        audioPlayer.positionStream,
        audioPlayer.bufferedPositionStream,
        audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          progress: position,
          buffered: bufferedPosition,
          duration: duration ?? Duration.zero,
        ),
      );

  Widget SongSlider() {
    return StreamBuilder<PositionData>(
      stream: _positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;

        final position = positionData?.progress ?? Duration.zero;
        final buffered = positionData?.buffered ?? Duration.zero;
        final duration = positionData?.duration ?? Duration.zero;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ProgressBar(
            progress: position,
            buffered: buffered,
            total: duration,

            onSeek: (duration) {
              audioPlayer.pause();
              audioPlayer.seek(duration);
              audioPlayer.play();
            },

            progressBarColor: Colors.red,
            baseBarColor: Colors.grey.withOpacity(0.24),
            bufferedBarColor: Colors.grey.withOpacity(0.24),
            thumbColor: Colors.red,
            barHeight: 5.0,
            thumbRadius: 8.0,
            timeLabelLocation: TimeLabelLocation.below,
          ),
        );
      },
    );
  }

  // Widget NextButton() {
  //   return IconButton(onPressed: () {}, icon: icon);
  // }
}
