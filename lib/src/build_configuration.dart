import 'dart:io';

import 'package:safe_config/safe_config.dart';
import 'package:yaml/yaml.dart';

class BuildConfiguration extends Configuration {
  BuildConfiguration(String fileName) : super.fromFile(File(fileName));

  String outputPath = 'lib/model/';
  String dbSchema = 'public';
  DatabaseConfiguration database;

  Future<String> get packageName async {
    var yamlFile = File('./pubspec.yaml');
    var doc = loadYaml(await yamlFile.readAsString());

    return doc['name'];
  }
}
