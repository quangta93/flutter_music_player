import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';

import 'theme.dart';


class BottomControls extends StatelessWidget {
  const BottomControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: accentColor,
      child: Material(
        color: accentColor,
        shadowColor: Color(0x44000000),
        child: Padding(
          padding: EdgeInsets.only(top: 40.0, bottom: 50.0),
          child: Column(
            children: <Widget>[
              // title & artist
              RichText(
                text: TextSpan(
                  text: '',
                  children: [
                    TextSpan(
                      text: 'Song Title\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        height: 1.5,
                      ),
                    ),

                    TextSpan(
                      text: 'Artist Name\n',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12.0,
                        letterSpacing: 3.0,
                        height: 1.5,
                      ),
                    ),
                  ],
                )
              ),

              // controls
              Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),

                    PreviousButton(),

                    Expanded(
                      child: Container(),
                    ),

                    PlayPauseButton(),

                    Expanded(
                      child: Container(),
                    ),

                    NextButton(),

                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        IconData _icon = Icons.music_note;
        Color _buttonColor = lightAccentColor;
        Function _onPressed;

        if (player.state == AudioPlayerState.playing) {
          _icon = Icons.pause;
          _onPressed = player.pause;
          _buttonColor = Colors.white;
        } else if (
          player.state == AudioPlayerState.paused ||
          player.state == AudioPlayerState.completed
        ) {
          _icon = Icons.play_arrow;
          _onPressed = player.play;
          _buttonColor = Colors.white;
        }

        return RawMaterialButton(
          shape: CircleBorder(),
          fillColor: _buttonColor,
          splashColor: lightAccentColor,
          highlightColor: lightAccentColor.withOpacity(0.5),
          elevation: 10.0,
          highlightElevation: 5.0,
          onPressed: _onPressed,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(_icon, color: darkAccentColor, size: 35.0),
          ),
        );
      },
    );
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return IconButton(
          icon: Icon(Icons.skip_previous, size: 35.0),
          color: Colors.white,
          splashColor: lightAccentColor,
          highlightColor: Colors.transparent,
          onPressed: playlist.previous,
        );
      },
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
        playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
          return IconButton(
            icon: Icon(Icons.skip_next, size: 35.0),
            color: Colors.white,
            splashColor: lightAccentColor,
            highlightColor: Colors.transparent,
            onPressed: playlist.next,
          );

        }
    );
  }
}