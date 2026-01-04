import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/models/token.dart';
import 'package:music_player/services/song-service.dart';

class SongsPage extends StatefulWidget {
  Token token;
  SongsPage({super.key, required this.token});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  late SongService songService;
  late Future<List<Song>?> songs;

  @override
  void initState() {
    super.initState();
    songService = SongService();
    songs = songService.getSongs(widget.token.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: MusicPlayer()));
  }

  Widget MusicPlayer() {
    return Column(
      children: [
        //SongDetail(),
        SongsList(),
      ],
    );
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
      onTap: () {},
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
                width: 100,
                height: 100,
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
}
