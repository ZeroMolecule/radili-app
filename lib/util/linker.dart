import 'package:radili/domain/data/store.dart';
import 'package:radili/util/env.dart';
import 'package:url_launcher/url_launcher.dart';

class Linker {
  Future<void> launchSupportPage() async {
    if (await canLaunchUrl(Env.uriSupportPage)) {
      await launchUrl(Env.uriSupportPage);
    }
  }

  Future<void> launchProjectPage() async {
    if (await canLaunchUrl(Env.uriProjectPage)) {
      await launchUrl(Env.uriProjectPage);
    }
  }

  Uri getDiscountsUri(Store store) {
    return Env.uriDiscountsPage.replace(
      queryParameters: {
        'mode': 'light',
        'limit': '21',
        'ref': 'radili_dev',
        'provider': store.slug,
        'card': 'condensed',
      },
    );
  }
}
