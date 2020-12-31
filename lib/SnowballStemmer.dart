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

  String stem(String word) {
    word = word.toLowerCase();

    // TODO(jeffbailey): Check stopwords

    if (_specialWords.containsKey(word)) return _specialWords[word];

    // Map the different apostrophe characters to a single consistent one
    word = word
        .replaceAll('\u2019', '\x27')
        .replaceAll('\u2018', '\x27')
        .replaceAll('\u201B', '\x27');

    if (word[0] == '\x27') word = word.substring(1);

    return word;
  }
}
