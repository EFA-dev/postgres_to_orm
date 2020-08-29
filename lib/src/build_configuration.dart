import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:safe_config/safe_config.dart';

class BuildConfiguration extends Configuration {
  BuildConfiguration(String fileName) : super.fromFile(File(fileName)) {
    var pubspecFile = File('./pubspec.yaml');
    _pubspec = Pubspec.parse(pubspecFile.readAsStringSync());
  }

  Pubspec _pubspec;
  Pubspec get pubspec => _pubspec;
  String entityPath = 'lib/model/';
  String dbSchema = 'public';
  bool createEntity = true;
  bool createController = true;
  String controllerPath = 'lib/controller/';
  bool createTest = true;
  DatabaseConfiguration database;
}
