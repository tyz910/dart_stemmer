// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:core';
import 'dart:io';

import '../lib/SnowballStemmer.dart';

final testData = LinkedHashMap<String, String>();
final testDataRegExp = RegExp(r'^([^\s]+)\s+([^\s]+)$');

int passes = 0;
int fails = 0;

main() async {
  await loadTestData();

  var stemmer = SnowballStemmer();

  for (var key in testData.keys) {
    if (stemmer.stem(key) == testData[key]) {
      passes++;
    } else {
      fails++;
    }
  }

  print("passes: " + passes.toString());
  print("fails: " + fails.toString());
}

Future<void> loadTestData() async {
  File data = new File("snowball_test.txt");
  await data.readAsLines().then(processLines);
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
