import '../lib/SnowballStemmer.dart';

main() {
  var stemmer = SnowballStemmer();
  String result = stemmer.stem("writing");
  print(result);
}
