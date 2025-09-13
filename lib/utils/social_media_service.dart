import 'package:url_launcher/url_launcher.dart';

class SocialMediaService {
  static Future<void> openWhatsapp({
    required String phone,
    String? texto,
  }) async {
    final encodedText = Uri.encodeComponent(
      texto ?? 'Envie sua mensagem sobre nossa Webrádio. Grato.',
    );
    final whatsappUrl = Uri.parse(
      "whatsapp://send?phone=$phone&text=$encodedText",
    );
    final fallbackUrl = Uri.parse('https://wa.me/$phone?text=$encodedText');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(fallbackUrl)) {
      await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi abrir o whatsapp';
    }
  }

  static Future<void> openInstagram(String username) async {
    final urlApp = Uri.parse('http://instagram.com/_u/$username');
    final urlWeb = Uri.parse("https://instagram.com/$username");

    if (await canLaunchUrl(urlApp)) {
      await launchUrl(urlApp, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(urlWeb, mode: LaunchMode.externalApplication);
    }
  }
}
