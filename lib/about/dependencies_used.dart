import 'package:flutter/foundation.dart';

class Dependency
{
  final String name;
  final String url;
  Dependency({@required this.name, @required this.url});
}

// Add new dependency here
// Formality- Each dependency contains Dependency name(String) with the URL(String) to it
List<Dependency> dependencies = [
  Dependency(name: 'Flutter', url: 'https://flutter.dev/'),
  Dependency(name: 'sembast', url: 'https://pub.dev/packages/sembast'),
  Dependency(name: 'path_provider', url: 'https://pub.dev/packages/path_provider'),
  Dependency(name: 'filesize', url: 'https://pub.dev/packages/filesize'),
  Dependency(name: 'package_info', url: 'https://pub.dev/packages/package_info'),
  Dependency(name: 'url_launcher', url: 'https://pub.dev/packages/url_launcher'),
  Dependency(name: 'flutter_launcher_icons', url: 'https://pub.dev/packages/flutter_launcher_icons'),
  Dependency(name: 'font_awesome_flutter', url: 'https://pub.dev/packages/font_awesome_flutter'),
  Dependency(name: 'marquee_widget', url: 'https://pub.dev/packages/marquee_widget'),
  Dependency(name: 'list_tile_more_customizable', url: 'https://pub.dev/packages/list_tile_more_customizable'),
  Dependency(name: 'provider', url: 'https://pub.dev/packages/provider'),
];