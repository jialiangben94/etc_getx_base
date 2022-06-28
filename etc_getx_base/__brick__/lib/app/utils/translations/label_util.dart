import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:{{project_route}}/app/model/api/label.dart';
import 'package:path_provider/path_provider.dart';

class LabelUtil {
  static final LabelUtil _baseService = LabelUtil._();
  factory LabelUtil() => _baseService;
  LabelUtil._();

  static final List<Label> _labels = [];

  // write the label into file
  Future<File> writeLabel(String data) async {
    final file = await _labelFile;

    // Write the file.
    final completeFile = file.writeAsString(data);

    // update the label
    //  _labels = await labels;

    return completeFile;
  }

  // find label value based on key
  String findValue(String key) {
    return _labels.firstWhere((item) => item.key == key).enValue;
  }

  // get label version
  Future<String> get labelVersion async {
    try {
      final file = await _labelFile;

      // Read the file.
      String contents = await file.readAsString();

      final parsed = jsonDecode(contents);

      return parsed['latest_version'] ?? '0.0.0';
    } catch (e) {
      log(e);
      return '0.0.0';
    }
  }

  Future<List<Label>> getLabels(String languageCode) async {
    try {
      final file = await _labelFile;

      // Read the file.
      String contents = await file.readAsString();

      final parsed = jsonDecode(contents);

      final parsedLabel = parsed;

//      final labelJA = jsonDecode(rawLabel);

      return parsedLabel.map<Label>((json) => Label.fromJson(json)).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  // get document path
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // get the label file
  static Future<File> get _labelFile async {
    final path = await _localPath;
    return File('$path/label.txt');
  }
}
