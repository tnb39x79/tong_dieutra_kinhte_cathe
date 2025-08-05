import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppStorage {
  Future<File> generalFile({fileName = 'test.json', content = ''}) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    final Directory directory =
        Directory('${appDocDirectory.path}/Ketquadieutra')
          ..createSync(recursive: true);
    final File file = File('${directory.path}/$fileName');
    await file.writeAsString(content);
    return file;
  }
}
