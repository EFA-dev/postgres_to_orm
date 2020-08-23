import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/channel.dart';

void main() async {
  final app = Application<AqueductChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = 8888;

  await app.startOnCurrentIsolate();

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}
