class StringHelper {
  static Iterable<String> getLink(String text) {
    final exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(text);
    return matches.map((e) => text.substring(e.start, e.end));
  }
}
