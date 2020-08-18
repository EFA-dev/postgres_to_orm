import 'dart:io';

import 'package:safe_config/safe_config.dart';

class BuildConfiguration extends Configuration {
  BuildConfiguration(String fileName) : super.fromFile(File(fileName));

  String outputPath = 'lib/model/';
  String dbSchema = 'public';
  DatabaseConfiguration database;
}
