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

  String _r1;
  String _r2;

  String _word;

  String stem(String origWord) {
    _word = origWord.toLowerCase();

    // TODO(jeffbailey): Check stopwords
    if (_word.length <= 2) return _word;

    if (_specialWords.containsKey(_word)) return _specialWords[_word];

    // Map the different apostrophe characters to a single consistent one
    _word = _word
        .replaceAll('\u2019', '\x27')
        .replaceAll('\u2018', '\x27')
        .replaceAll('\u201B', '\x27');

    if (_word.startsWith('\x27')) _word = _word.substring(1);

    if (_word.startsWith('y')) _word = 'Y' + _word.substring(1);

    //         for i in range(1, len(word)):
    //           if word[i - 1] in self.__vowels and word[i] == "y":
    //             word = "".join((word[:i], "Y", word[i + 1 :]))

    if (false) {
    } else {
      _r1r2Standard();
    }

    _step0();
    _step1a();
    _step1b();

    _word = _word.replaceAll('Y', 'y');

    return _word;
  }

  // Return the standard interpretations of the string regions R1 and R2.
  //
  // R1 is the region after the first non-vowel following a vowel,
  // or is the null region at the end of the word if there is no
  // such non-vowel.
  //
  // R2 is the region after the first non-vowel following a vowel
  // in R1, or is the null region at the end of the word if there
  // is no such non-vowel.
  //
  // A detailed description of how to define R1 and R2
  // can be found at http://snowball.tartarus.org/texts/r1r2.html
  void _r1r2Standard() {
    _r1 = "";
    _r2 = "";

    // Starts on second letter.
    for (var i = 1; i < _word.length; i++) {
      if (!_vowels.contains(_word[i]) && _vowels.contains(_word[i - 1])) {
        _r1 = _word.substring(i + 1);
        break;
      }
    }

    for (var i = 1; i < _r1.length; i++) {
      if (!_vowels.contains(_r1[i]) && _vowels.contains(_r1[i - 1])) {
        _r2 = _r1.substring(i + 1);
        break;
      }
    }
  }

  void _step0() {
    for (var suffix in _step0Suffixes) {
      if (_word.endsWith(suffix)) {
        _word = _stripEnd(_word, suffix.length);
        _r1 = _stripEnd(_r1, suffix.length);
        _r2 = _stripEnd(_r2, suffix.length);
      }
    }
  }

  void _step1a() {
    for (var suffix in _step1aSuffixes) {
      if (_word.endsWith(suffix)) {
        switch (suffix) {
          case "sses":
            _word = _stripEnd(_word, 2);
            _r1 = _stripEnd(_r1, 2);
            _r2 = _stripEnd(_r2, 2);
            break;
          case "ied":
          case "ies":
            if (_word.substring(0, _word.length - suffix.length).length > 1) {
              _word = _stripEnd(_word, 2);
              _r1 = _stripEnd(_r1, 2);
              _r2 = _stripEnd(_r2, 2);
            } else {
              _word = _stripEnd(_word, 1);
              _r1 = _stripEnd(_r1, 1);
              _r2 = _stripEnd(_r2, 1);
            }
            break;
          case "s":
            var step1a_vowel_found = false;
            for (var i = 0; i < _word.length - 2; i++) {
              if (_vowels.contains(_word[i])) {
                step1a_vowel_found = true;
              }
            }
            if (step1a_vowel_found) {
              _word = _stripEnd(_word, 1);
              _r1 = _stripEnd(_r1, 1);
              _r2 = _stripEnd(_r2, 1);
            }
            break;
        }
        break;
      }
    }
  }

  void _step1b() {
    for (var suffix in _step1bSuffixes) {
      if (_word.endsWith(suffix)) {
        // Interestingly, "eedly" isn't in the test data.
        // According to the Internets, there are only 9 words
        // in English that end in "eedly"
        if (suffix == "eed" || suffix == "eedly") {
          if (_r1.endsWith(suffix)) {
            _word = _suffixReplace(_word, suffix, "ee");

            if (_r1.length >= suffix.length) {
              _r1 = _suffixReplace(_r1, suffix, "ee");
            } else {
              _r1 = "";
            }

            if (_r2.length >= suffix.length) {
              _r2 = _suffixReplace(_r2, suffix, "ee");
            } else {
              _r2 = "";
            }
          }
          break;
        }
      } else {
        // TODO(jeffbailey): Implement this
        var step1b_vowel_found = false;
      }
    }
  }

  String _suffixReplace(String word, String oldSuffix, String newSuffix) =>
      word.substring(0, word.length - oldSuffix.length) + newSuffix;

  String _stripEnd(String word, int length) =>
      word.length > length ? word.substring(0, word.length - length) : "";
}
