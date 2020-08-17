import 'dart:io';

import 'package:safe_config/safe_config.dart';

class BuildConfiguration extends Configuration {
  BuildConfiguration(String fileName) : super.fromFile(File(fileName));

  String outputPath;
  String dbSchema;
  DatabaseConfiguration database;
}
