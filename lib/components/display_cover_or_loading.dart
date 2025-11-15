import 'package:flutter/material.dart';

import '/components/cover_image.dart';
import '/components/loading_json.dart';

class DisplayCoverOrLoading extends StatelessWidget {
  const DisplayCoverOrLoading({
    super.key,
    required String coverUrl,
    required bool status,
  }) : _coverUrl = coverUrl,
       _status = status;

  final String _coverUrl;
  final bool _status;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Visibility(
        visible: _status,
        replacement: LoadingJson(status: _status),
        child: Cover(coverUrl: _coverUrl),
      ),
    );
  }
}
