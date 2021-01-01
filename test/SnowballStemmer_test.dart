// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:core';
import 'dart:io';

import '../lib/SnowballStemmer.dart';

final testData = LinkedHashMap<String, String>();
final testDataRegExp = RegExp(r'^([^\s]+)\s+([^\s]+)$');

int passes = 0;
int fails = 0;

main() {
  var lines = loadTestData();
  processLines(lines);

  var stemmer = SnowballStemmer();

  for (var key in testData.keys) {
    var result = stemmer.stem(key);
    if (result == testData[key]) {
      passes++;
    } else {
      print("Original: ${key}, Expected: ${testData[key]}, Got: ${result}");
      fails++;
    }
  }

  print("passes: " + passes.toString());
  print("fails: " + fails.toString());
}

List<String> loadTestData() {
  File data = new File("snowball_test.txt");
  return data.readAsLinesSync();
}

void processLines(List<String> lines) {
  for (var line in lines) {
    if (line[0] == '#') continue;
    Iterable<Match> words = testDataRegExp.allMatches(line);
    for (var match in words) {
      testData[match.group(1)] = match.group(2);
    }
  }
}
