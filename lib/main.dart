import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';

import 'audio_radial_seek_bar.dart';
import 'bottom_controls.dart';
import 'songs.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return AudioPlaylist(
      playlist: demoPlaylist.songs.map((DemoSong song) => song.audioUrl).toList(growable: false),
      playbackState: PlaybackState.paused,
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color(0xFFDDDDDD),
            onPressed: () {},
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              color: Color(0xFFDDDDDD),
              onPressed: () {},
            ),
          ],
        ),

        body: Column(
          children: <Widget>[
            // Seek bar
            Expanded(
              child: AudioPlaylistComponent(
                playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
                  final DemoSong song = demoPlaylist.songs[playlist.activeIndex];

                  return AudioRadialSeekBar(
                    imageUrl: song.albumArtUrl,
                  );
                },
              ),
            ),

            // Visualizer
            Container(
              width: double.infinity,
              height: 125.0,
            ),

            AudioPlaylistComponent(
              playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
                final DemoSong song = demoPlaylist.songs[playlist.activeIndex];

                return BottomControls(
                  songTitle: song.songTitle,
                  artistName: song.artist,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}