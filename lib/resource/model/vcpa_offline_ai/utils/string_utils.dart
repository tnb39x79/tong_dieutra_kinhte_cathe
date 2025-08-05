class StringUtils {
  /// Adds spaces around tokens for PhoBERT tokenization
  static String addSpacesAroundTokens(String text) {
    // Add spaces around punctuation
    text = text.replaceAll('.', ' . ');
    text = text.replaceAll(',', ' , ');
    text = text.replaceAll('!', ' ! ');
    text = text.replaceAll('?', ' ? ');
    text = text.replaceAll(';', ' ; ');
    text = text.replaceAll(':', ' : ');
    
    // Add spaces around brackets and parentheses
    text = text.replaceAll('(', ' ( ');
    text = text.replaceAll(')', ' ) ');
    text = text.replaceAll('[', ' [ ');
    text = text.replaceAll(']', ' ] ');
    text = text.replaceAll('{', ' { ');
    text = text.replaceAll('}', ' } ');
    
    // Add spaces around quotes
    text = text.replaceAll('"', ' " ');
    text = text.replaceAll("'", " ' ");
    text = text.replaceAll('`', ' ` ');
    
    // Add spaces around mathematical operators
    text = text.replaceAll('+', ' + ');
    text = text.replaceAll('-', ' - ');
    text = text.replaceAll('*', ' * ');
    text = text.replaceAll('/', ' / ');
    text = text.replaceAll('=', ' = ');
    text = text.replaceAll('<', ' < ');
    text = text.replaceAll('>', ' > ');
    
    // Add spaces around special characters
    text = text.replaceAll('@', ' @ ');
    text = text.replaceAll('#', ' # ');
    text = text.replaceAll(r'$', ' \$ ');
    text = text.replaceAll('%', ' % ');
    text = text.replaceAll('&', ' & ');
    text = text.replaceAll('|', ' | ');
    text = text.replaceAll('~', ' ~ ');
    text = text.replaceAll('^', ' ^ ');
    
    // Normalize whitespace
    while (text.contains('  ')) {
      text = text.replaceAll('  ', ' ');
    }
    
    return text.trim();
  }
  
  /// Cleans text for preprocessing
  static String cleanText(String text) {
    // Remove extra whitespace
    while (text.contains('  ')) {
      text = text.replaceAll('  ', ' ');
    }
    
    return text.trim();
  }
  
  /// Truncates text to a maximum number of words
  static String truncateToWords(String text, int maxWords) {
    final words = text.split(' ');
    if (words.length <= maxWords) {
      return text;
    }
    
    return words.sublist(0, maxWords).join(' ');
  }
} 