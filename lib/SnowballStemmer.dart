// SPDX-License-Identifier: Apache-2.0

/// Snowball Stemmer
///
/// The is a port of the Snowball implementation contained in NLTK
///
/// The algorithm for English is documented here:
///    Porter, M. \"An algorithm for suffix stripping.\"
///    Program 14.3 (1980): 130-137.
///
/// The algorithms have been developed by Martin Porter.
/// These stemmers are called Snowball, because Porter created
/// a programming language with this name for creating
/// new stemming algorithms. There is more information available
/// at http://snowball.tartarus.org/
///
/// A detailed description of the English stemming algorithm can be found under
/// http://snowball.tartarus.org/algorithms/english/stemmer.html

class SnowballStemmer {
  final _vowels = "aeiouy";
  final _doubleConsonants = [
    "bb",
    "dd",
    "ff",
    "gg",
    "mm",
    "nn",
    "pp",
    "rr",
    "tt"
  ];
  final _liEnding = "cdeghkmnrt";
  final _step0Suffixes = ["'s'", "'s", "'"];
  final _step1aSuffixes = ["sses", "ied", "ies", "us", "ss", "s"];
  final _step1bSuffixes = ["eedly", "ingly", "edly", "eed", "ing", "ed"];
  final _step2Suffixes = [
    "ization",
    "ational",
    "fulness",
    "ousness",
    "iveness",
    "tional",
    "biliti",
    "lessli",
    "entli",
    "ation",
    "alism",
    "aliti",
    "ousli",
    "iviti",
    "fulli",
    "enci",
    "anci",
    "abli",
    "izer",
    "ator",
    "alli",
    "bli",
    "ogi",
    "li",
  ];
  final _step3Suffixes = [
    "ational",
    "tional",
    "alize",
    "icate",
    "iciti",
    "ative",
    "ical",
    "ness",
    "ful",
  ];
  final _step4Suffixes = [
    "ement",
    "ance",
    "ence",
    "able",
    "ible",
    "ment",
    "ant",
    "ent",
    "ism",
    "ate",
    "iti",
    "ous",
    "ive",
    "ize",
    "ion",
    "al",
    "er",
    "ic",
  ];

  final _step5Suffixes = ["e", "l"];

  final Map<String, String> _specialWords = {
    "skis": "ski",
    "skies": "sky",
    "dying": "die",
    "lying": "lie",
    "tying": "tie",
    "idly": "idl",
    "gently": "gentl",
    "ugly": "ugli",
    "early": "earli",
    "only": "onli",
    "singly": "singl",
    "sky": "sky",
    "news": "news",
    "howe": "howe",
    "atlas": "atlas",
    "cosmos": "cosmos",
    "bias": "bias",
    "andes": "andes",
    "inning": "inning",
    "innings": "inning",
    "outing": "outing",
    "outings": "outing",
    "canning": "canning",
    "cannings": "canning",
    "herring": "herring",
    "herrings": "herring",
    "earring": "earring",
    "earrings": "earring",
    "proceed": "proceed",
    "proceeds": "proceed",
    "proceeded": "proceed",
    "proceeding": "proceed",
    "exceed": "exceed",
    "exceeds": "exceed",
    "exceeded": "exceed",
    "exceeding": "exceed",
    "succeed": "succeed",
    "succeeds": "succeed",
    "succeeded": "succeed",
    "succeeding": "succeed",
  };

  var _r1 = "";
  var _r2 = "";

  String word;

  String stem(String origWord) {
    word = origWord.toLowerCase();

    // TODO(jeffbailey): Check stopwords
    if (word.length <= 2) return word;

    if (_specialWords.containsKey(word)) return _specialWords[word];

    // Map the different apostrophe characters to a single consistent one
    word = word
        .replaceAll('\u2019', '\x27')
        .replaceAll('\u2018', '\x27')
        .replaceAll('\u201B', '\x27');

    if (word.startsWith('\x27')) word = word.substring(1);

    if (word.startsWith('y')) word = 'Y' + word.substring(1);

    //         for i in range(1, len(word)):
    //           if word[i - 1] in self.__vowels and word[i] == "y":
    //             word = "".join((word[:i], "Y", word[i + 1 :]))

    _step0();
    _step1a();
    _step1b();

    word = word.replaceAll('Y', 'y');

    return word;
  }

  void _step0() {
    for (var suffix in _step0Suffixes) {
      if (word.endsWith(suffix)) {
        word = word.substring(0, word.length - suffix.length);
      }
    }
  }

  void _step1a() {
    var step1a_vowel_found = false;
    for (var suffix in _step1aSuffixes) {
      if (word.endsWith(suffix)) {
        switch (suffix) {
          case "sses":
            word = word.substring(0, word.length - 2);
            break;
          case "ied":
          case "ies":
            word = word.substring(0, word.length - 2);
        }
      }
    }
  }

  void _step1b() {
    var step1b_vowel_found = false;
  }
}
