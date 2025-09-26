import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// imports locais
import '../components/button_social_media.dart';
import '../components/cover_image.dart';
import '../components/wave_form_json.dart';
import '../constants.dart';
import '../utils//social_media_service.dart';
import '../utils/radio_service.dart';
import 'button_play_stop.dart';
import 'text_info.dart';

class ViewData extends StatelessWidget {
  const ViewData({
    super.key,
    required this.radioService,
    required String? coverUrl,
    required this.artist,
    required this.song,
  }) : _coverUrl = coverUrl;

  final RadioService radioService;
  final String? _coverUrl;
  final String artist;
  final String song;

  @override
  Widget build(BuildContext context) {
    // Variável local
    final player = radioService.player;

    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
      child: Column(
        children: <Widget>[
          TextInfo(metadata: 'Parque Verde', textStyle: kTitleStyle),
          Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                child: Image.asset(
                  kHeadphonesImg,
                  height: 250,
                  width: 410,
                  fit: BoxFit.fitWidth,
                ),
              ),

              Positioned(top: 70, child: WaveFormJson(playing: player.playing)),

              Positioned(
                top: 90,
                child: Cover(coverUrl: _coverUrl, artist: artist),
              ),
            ],
          ),

          Align(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // títulos do artista e música em execução
                TextInfo(metadata: artist, textStyle: kArtistTextStyle),
                SizedBox(height: 5),
                TextInfo(metadata: song, textStyle: kSongTextStyle),

                SizedBox(height: 20),
                // Carrega o widget customizado PlayPauseButton que controla o
                // play/stop do player
                PlayPauseButton(
                  playingStream: player.playingStream,
                  backgroundColor: kColor3,
                  borderColor: kColor2.withValues(alpha: 0.6),
                  iconColor: kColor2,
                  initialPlaying: player.playing,
                  onPressed: radioService.togglePlayPause,
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ButtonSocialMedia(
                    onPressed: () {
                      SocialMediaService.openWhatsapp(phone: '5584987015547');
                    },
                    icon: FontAwesomeIcons.whatsapp,
                    iconSize: 24,
                    iconColor: kColor2,
                    label: 'Whatsapp',
                    labelColor: kColor2,
                    borderColor: kColor2.withValues(alpha: 0.6),
                  ),
                  ButtonSocialMedia(
                    onPressed: () {
                      SocialMediaService.openInstagram('prmorais_13');
                    },
                    icon: FontAwesomeIcons.instagram,
                    iconSize: 24,
                    iconColor: kColor2,
                    label: 'Instagram',
                    labelColor: kColor2,
                    borderColor: kColor2.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
