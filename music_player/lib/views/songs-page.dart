import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/models/position-data.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/models/token.dart';
import 'package:music_player/services/song-service.dart';
import 'package:music_player/views/user-detail-page.dart';
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
  late List<Song> catchedSong;
  late Song? currentSong;
  late AudioPlayer audioPlayer;
  late Random random;
  late bool isRepeated;

  @override
  void initState() {
    super.initState();
    songService = SongService();
    songs = songService.getSongs(widget.token.accessToken);
    currentSong = null;
    random = Random();
    isRepeated = false;

    audioPlayer = AudioPlayer();
    audioPlayer.currentIndexStream.listen((index) {
      if (index != null && catchedSong.isNotEmpty) {
        setState(() {
          currentSong = catchedSong[index];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF1DB954)),
                child: Expanded(
                  child: Center(
                    child: Text(
                      'Umac 🎧',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Thông tin cá nhân'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailPage(token: widget.token),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Trình phát nhạc'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Umac 🎧',
            style: TextStyle(
              color: Color(0xFF1DB954),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: MusicPlayer(),
      ),
    );
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

          catchedSong = snapshot.data!;
          if (audioPlayer.sequence == null || audioPlayer.sequence.isEmpty) {
            audioPlayer.setAudioSources([
              for (Song song in catchedSong)
                AudioSource.uri(Uri.parse(song.source)),
            ]);
          }

          return Expanded(child: Songs(catchedSong));
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
        return SongItem(index, songs[index]);
      },

      separatorBuilder: (context, index) {
        return SizedBox(height: 5);
      },
    );
  }

  Widget SongItem(int index, Song song) {
    return InkWell(
      onTap: () {
        setState(() {
          currentSong = song;
        });
        audioPlayer.seek(Duration.zero, index: index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: index == audioPlayer.currentIndex
              ? Color.fromARGB(129, 29, 185, 84).withOpacity(0.1)
              : Colors.white,
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          spacing: 20,
          children: [
            SizedBox(
              width: 20,
              child: Text(
                '${song.id}',
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: index == audioPlayer.currentIndex
                      ? Colors.black
                      : Colors.grey,
                ),
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: index == audioPlayer.currentIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: index == audioPlayer.currentIndex
                          ? Color(0xFF1DB954)
                          : Colors.black,
                    ),
                  ),
                  Text(
                    '${song.singer}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: index == audioPlayer.currentIndex
                          ? Colors.black
                          : Colors.grey,
                    ),
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
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(song.image, width: 200, height: 200, fit: BoxFit.cover),
          SizedBox(height: 8),
          Text(
            song.name,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1DB954),
            ),
          ),
          Text(song.singer),
          SizedBox(height: 8),
          SongSlider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RepeatButton(),
              PreviousButton(),
              ToggleButton(),
              NextButton(),
              RandomButton(),
            ],
          ),
          Divider(color: Colors.grey),
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
          return Container(
            width: 66,
            height: 66,
            child: Center(child: const CircularProgressIndicator()),
          );
        }

        if (playing == false) {
          return IconButton(
            icon: const Icon(Icons.play_circle_filled),
            iconSize: 50,
            color: Color(0xFF1DB954),
            onPressed: audioPlayer.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause_circle_filled),
            iconSize: 50,
            color: Colors.black,
            onPressed: audioPlayer.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay_circle_filled),
            iconSize: 50,
            color: Colors.black,
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ProgressBar(
            progress: position,
            buffered: buffered,
            total: duration,

            onSeek: (duration) {
              audioPlayer.pause();
              audioPlayer.seek(duration);
              audioPlayer.play();
            },

            progressBarColor: Color(0xFF1DB954),
            baseBarColor: Colors.grey.withOpacity(0.24),
            bufferedBarColor: Colors.grey.withOpacity(0.24),
            thumbColor: Color(0xFF1DB954),
            barHeight: 5.0,
            thumbRadius: 8.0,
            timeLabelLocation: TimeLabelLocation.below,
          ),
        );
      },
    );
  }

  Widget PreviousButton() {
    return IconButton(
      onPressed: () async {
        int? currentIndex = audioPlayer.currentIndex;
        if (currentIndex == null) return;

        if (isRepeated) {
          audioPlayer.setLoopMode(LoopMode.off);
          setState(() {
            isRepeated = false;
          });
        }

        if (currentIndex == 0) {
          audioPlayer.seek(Duration.zero, index: catchedSong.length - 1);
          setState(() {
            currentSong = catchedSong[catchedSong.length - 1];
          });
        } else {
          await audioPlayer.seekToPrevious();
          setState(() {
            currentSong = catchedSong[audioPlayer.currentIndex!];
          });
        }
      },
      icon: Icon(Icons.skip_previous),
    );
  }

  Widget NextButton() {
    return IconButton(
      onPressed: () async {
        int? currentIndex = audioPlayer.currentIndex;
        if (currentIndex == null) {
          return;
        }

        if (isRepeated) {
          audioPlayer.setLoopMode(LoopMode.off);
          setState(() {
            isRepeated = false;
          });
        }

        if (currentIndex == catchedSong.length - 1) {
          audioPlayer.seek(Duration.zero, index: 0);
          setState(() {
            currentSong = catchedSong[0];
          });
        } else {
          await audioPlayer.seekToNext();
          setState(() {
            currentSong = catchedSong[audioPlayer.currentIndex!];
          });
        }
      },
      icon: Icon(Icons.skip_next),
    );
  }

  Widget RandomButton() {
    return IconButton(
      onPressed: () {
        audioPlayer.seek(
          Duration.zero,
          index: random.nextInt(catchedSong.length),
        );
      },
      icon: Icon(Icons.crop),
    );
  }

  Widget RepeatButton() {
    return IconButton(
      onPressed: () {
        if (isRepeated) {
          audioPlayer.setLoopMode(LoopMode.off);
          setState(() {
            isRepeated = false;
          });
        } else {
          audioPlayer.setLoopMode(LoopMode.one);
          setState(() {
            isRepeated = true;
          });
        }
      },
      icon: Icon(
        Icons.repeat_one_rounded,
        color: isRepeated ? Color(0xFF1DB954) : Colors.black,
      ),
    );
  }
}
