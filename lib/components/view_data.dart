import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:webradio_parque_verde/components/animated_scale_pulse.dart';
import 'package:webradio_parque_verde/components/cover_image.dart';

// imports locais
import '../components/button_social_media.dart';
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
    required String coverUrl,
    required this.artist,
    required this.song,
    required this.status,
  }) : _coverUrl = coverUrl;

  final RadioService radioService;
  final String _coverUrl;
  final String artist;
  final String song;
  final bool status;

  @override
  Widget build(BuildContext context) {
    // Variável local
    final player = radioService.player;

    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * .8,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: constraints.maxHeight * .01),
                    TextInfo(metadata: 'Parque Verde', textStyle: kTitleStyle),
                    SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * .4,
                      child: Stack(
                        fit: StackFit.passthrough,
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Positioned(
                            top: constraints.maxHeight * -.005,
                            child: Image.asset(
                              kAstePhonesImg,
                              height: constraints.maxHeight * .355,
                              width: 400,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Positioned(
                            top: constraints.maxHeight * -.005,
                            child: AnimatedScalePulse(
                              playing: radioService.player.playing,
                              duration: Duration(milliseconds: 100),
                              maxScale: 0.99,
                              minScale: 0.98,
                              child: Image.asset(
                                kPhonesImg,
                                height: constraints.maxHeight * .35,
                                width: 400,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: status,
                            replacement: Center(
                              child: Lottie.asset(
                                kWalkCycleJson,
                                height: 130,
                                fit: BoxFit.contain,
                              ), // Lottie
                            ),
                            child: Positioned(
                              top: constraints.maxHeight * .1,
                              child: WaveFormJson(playing: player.playing),
                            ),
                          ),
                          Visibility(
                            visible: status,
                            replacement: Positioned(
                              top: constraints.maxHeight * .36,
                              child: TextInfo(
                                metadata: 'Conectando...',
                                textStyle: kArtistTextStyle,
                              ),
                            ),
                            child: Positioned(
                              top: constraints.maxHeight * .09,
                              child: Cover(coverUrl: _coverUrl),
                              // child: AnimatedCover(coverUrl: _coverUrl),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      heightFactor: constraints.minHeight * .00085,
                      child: Visibility(
                        visible: status,
                        child: Column(
                          children: <Widget>[
                            // títulos do artista e música em execução
                            TextInfo(
                              metadata: artist,
                              textStyle: kArtistTextStyle,
                            ),
                            SizedBox(height: 5),
                            TextInfo(metadata: song, textStyle: kSongTextStyle),

                            SizedBox(height: 20),
                            // Carrega o widget customizado PlayPauseButton
                            // que controla o play/stop do player
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
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: constraints.maxHeight * .08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ButtonSocialMedia(
                        onPressed: () {
                          SocialMediaService.openWhatsapp(
                            phone: '5584987015547',
                          );
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
          );
        },
      ),
    );
  }
}
