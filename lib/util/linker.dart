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
}
