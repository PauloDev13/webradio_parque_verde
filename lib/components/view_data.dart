import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webradio_parque_verde/components/cover_image.dart';

import '/components/button_play_stop.dart';
import '/components/button_social_media.dart';
import '/constants.dart';
import '/main.dart';
import '/utils//social_media_service.dart';
import 'text_info.dart';

class ViewData extends StatelessWidget {
  const ViewData({super.key, required this.status});

  final bool status;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return StreamBuilder<MediaItem?>(
            stream: radioService.mediaItem,
            builder: (context, snapshot) {
              final item = snapshot.data;

              final artist = item?.artist ?? 'Parque Verde';
              final title = item?.title ?? 'Web Rádio';
              final cover = item?.artUri?.toString() ?? kUrlCloudinaryLogo;

              return Column(
                children: <Widget>[
                  SizedBox(height: constraints.maxHeight * .05),
                  TextInfo(metadata: 'Web Rádio', textStyle: kTitleStyle),
                  TextInfo(metadata: 'Parque Verde', textStyle: kTitleStyle),

                  // exibe a capa do álbum em execução
                  Cover(coverUrl: cover),

                  // exibe títulos do artista e música em execução
                  TextInfo(metadata: artist, textStyle: kArtistTextStyle),
                  SizedBox(height: 5),
                  TextInfo(metadata: title, textStyle: kSongTextStyle),

                  // botões play/stop
                  PlayPauseButton(
                    backgroundColor: kColor3,
                    borderColor: kColor2.withValues(alpha: 0.6),
                    iconColor: kColor2,
                    onPressed: radioService.togglePlayPause,
                  ),

                  // botões Instagram e Whatsapp
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(
                        bottom: constraints.maxHeight * .08,
                      ),
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
          );
        }, // builder
      ),
    );
  }
}
