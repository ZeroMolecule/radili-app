import 'package:radili/domain/data/store.dart';
import 'package:radili/util/env.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Linker {
  Future<bool> launch(Uri uri) {
    return _launchUrl(uri);
  }

  Future<bool> launchSupportPage() {
    return _launchUrl(Env.uriSupportPage);
  }

  Future<bool> launchProjectPage() {
    return _launchUrl(Env.uriProjectPage);
  }

  Future<bool> launchBugReportPage() {
    return _launchUrl(Env.uriBugReportPage);
  }

  Future<bool> launchIdeasPage() {
    return _launchUrl(Env.uriIdeasPage);
  }

  Uri buildDiscountsLink(Store store) {
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

Future<bool> _launchUrl(dynamic url) async {
  final target = url?.toString() ?? '';
  if (!await canLaunchUrlString(target)) return false;

  return await launchUrlString(target);
}
