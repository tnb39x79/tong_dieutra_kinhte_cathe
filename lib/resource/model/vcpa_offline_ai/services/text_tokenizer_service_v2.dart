import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import '../utils/asset_utils.dart';

/// PhoBERT Tokenizer for Vietnamese text
/// Based on VinAI Research's PhoBERT model
class PhoBERTTokenizer {
  static final Logger _logger = Logger('PhoBERTTokenizer');

  // Vocabulary and merges
  late Map<String, int> _vocab = {}; // token to id
  late Map<int, String> idToToken = {}; // id to token
  late List<Pair<String, String>> _bpeMerges = []; // BPE merges
  late Map<String, int> _specialTokens = {}; // Special tokens like [PAD], [CLS], etc.

  // Configuration
  final String _padToken = "[PAD]";
  final String _unkToken = "[UNK]";
  final String _sepToken = "[SEP]";
  final String _clsToken = "[CLS]";
  final String _maskToken = "[MASK]";
  int maxLength = 96; // Match the Python code's max_length

  // PhoBERT specific configuration
  final bool _spacesInInput = true;
  final bool _doLowerCase = true;
  late Set<String> _neverSplit;

  /// Constructor that initializes neverSplit set
  PhoBERTTokenizer() {
    _neverSplit = {_padToken, _unkToken, _sepToken, _clsToken, _maskToken};
  }

  /// Initialize the tokenizer by loading vocabulary and BPE codes from assets
  Future<void> initialize() async {
    try {
      await _loadVocabulary();
      await _loadBpeCodes();
      await _loadConfig();
    } catch (e) {
      _logger.severe("Error initializing tokenizer: ${e.toString()}");
      throw Exception("Failed to initialize PhoBERT tokenizer: ${e.toString()}");
    }
  }

  /// Load vocabulary from vocab.txt
  Future<void> _loadVocabulary() async {
    final vocabString = await AssetUtils.loadVocabulary();
    final Map<String, int> vocabMap = {};
    final Map<int, String> idMap = {};
    final Map<String, int> specialMap = {};

    // Set vocabulary offset to +4 to match Python model token IDs
    // This adjusts regular token IDs (not special tokens) to match the Python implementation
    const int vocabularyOffset = 4;

    final List<String> lines = vocabString.split('\n');
    // Check if first line contains a space followed by numbers (likely a frequency count)
    bool hasFrequencyCounts = lines.isNotEmpty &&
        lines[0].trim().contains(" ") &&
        int.tryParse(lines[0].trim().split(" ").last) != null;

    int idx = 0;
    for (String line in lines) {
      final String trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      // Parse the token from the line
      final String token;
      if (hasFrequencyCounts) {
        // Split by first space to get just the token part
        token = trimmedLine.split(" ", )[0].trim();
      } else {
        token = trimmedLine;
      }

      if (token.isEmpty) continue;

      // Determine if this is a special token (we don't apply offset to special tokens)
      final bool isSpecialToken = _neverSplit.contains(token);

      // Apply the ID - with offset for regular tokens, no offset for special tokens
      final int tokenId = isSpecialToken ? idx : idx + vocabularyOffset;

      vocabMap[token] = tokenId;
      idMap[tokenId] = token;

      // Check if this is a special token
      if (isSpecialToken) {
        specialMap[token] = tokenId;
      }

      idx++;
    }

    _vocab = vocabMap;
    idToToken = idMap;
    _specialTokens = specialMap;

    // Log vocabulary size for verification
    _logger.info("Loaded vocabulary with ${vocabMap.length} tokens");
    _logger.info("Special tokens: CLS=${vocabMap[_clsToken]}, SEP=${vocabMap[_sepToken]}, PAD=${vocabMap[_padToken]}, UNK=${vocabMap[_unkToken]}");

    _verifyVocabulary();
  }

  /// Load BPE codes from bpe.codes file
  Future<void> _loadBpeCodes() async {
    final bpeCodesString = await AssetUtils.loadBpe();
    final List<Pair<String, String>> merges = [];
    final List<String> lines = bpeCodesString.split('\n');

    // Skip the first line if it's a version header
    final int startIdx = lines.isNotEmpty && lines[0].contains("version") ? 1 : 0;

    for (int i = startIdx; i < lines.length; i++) {
      final String line = lines[i].trim();
      if (line.isEmpty) continue;

      final List<String> parts = line.split(RegExp(r'\s+'));
      if (parts.length == 2) {
        merges.add(Pair(parts[0], parts[1]));
      }
    }

    _bpeMerges = merges;
  }

  /// Load configuration from config.json
  Future<void> _loadConfig() async {
    try {

      final Map<String, dynamic> config = await AssetUtils.loadModelConfig();
      // Extract relevant configuration
      maxLength = config['model_max_length'] ?? 96;
    } catch (e) {
      // Default configuration is already set
    }
  }

  /// Verify vocabulary has required special tokens, and add them if missing
  void _verifyVocabulary() {
    final Map<String, int> mutableVocab = Map.from(_vocab);
    final Map<int, String> mutableIdToToken = Map.from(idToToken);

    // Standard token IDs matching Python implementations
    final Map<String, int> standardSpecialTokenIds = {
      _padToken: 0, // PAD token should be 0 to match Python
      _unkToken: 1, // UNK token as 1
      _clsToken: 2, // CLS token as 2
      _sepToken: 3, // SEP token as 3
      _maskToken: 4 // MASK token as 4
    };

    // Check for token ID conflicts
    final List<Pair<String, int>> conflictTokens = [];

    // Check for mandatory special tokens
    int addedTokens = 0;
    for (final MapEntry<String, int> entry in standardSpecialTokenIds.entries) {
      final String token = entry.key;
      final int standardId = entry.value;
      final int? existingId = mutableVocab[token];

      if (existingId == null) {
        // Token doesn't exist, add it with standard ID

        // Check if the standard ID is already used by another token
        final String? existingToken = mutableIdToToken[standardId];
        if (existingToken != null) {
          // ID conflict - we'll need to remap the existing token
          conflictTokens.add(Pair(existingToken, standardId));
          _logger.warning("ID conflict: $existingToken was using ID $standardId needed for $token");

          // Remove the conflicting token-ID mapping
          mutableVocab.remove(existingToken);
        }

        // Add the special token with standard ID
        mutableVocab[token] = standardId;
        mutableIdToToken[standardId] = token;
        _logger.warning("Adding missing special token: $token with standard ID $standardId");
        addedTokens++;
      } else if (existingId != standardId) {
        // Token exists but with wrong ID - remap it
        _logger.warning("Remapping special token: $token from ID $existingId to standard ID $standardId");

        // Check if standard ID is already used
        final String? existingToken = mutableIdToToken[standardId];
        if (existingToken != null) {
          // ID conflict - we'll need to remap the existing token
          conflictTokens.add(Pair(existingToken, standardId));
          _logger.warning("ID conflict: $existingToken was using ID $standardId needed for $token");

          // Remove the conflicting token-ID mapping
          mutableVocab.remove(existingToken);
        }

        // Update the ID mapping
        mutableVocab.remove(token);
        mutableVocab[token] = standardId;
        mutableIdToToken.remove(existingId);
        mutableIdToToken[standardId] = token;
        addedTokens++;
      }
    }

    // Reassign conflicting tokens to new IDs
    if (conflictTokens.isNotEmpty) {
      // Find a safe starting ID for displaced tokens
      int nextId = standardSpecialTokenIds.values.reduce((a, b) => a > b ? a : b) + 1;
      // Make sure it doesn't conflict with existing tokens
      while (mutableIdToToken.containsKey(nextId)) {
        nextId++;
      }

      // Remap conflicting tokens
      for (final Pair<String, int> conflict in conflictTokens) {
        final String token = conflict.first;
        final int oldId = conflict.second;
        _logger.warning("Remapping conflicting token '$token' from ID $oldId to $nextId");
        mutableVocab[token] = nextId;
        mutableIdToToken[nextId] = token;
        nextId++;
      }
    }

    if (addedTokens > 0 || conflictTokens.isNotEmpty) {
      // Update the vocabulary maps
      _vocab = mutableVocab;
      idToToken = mutableIdToToken;

      // Update special tokens map
      final Map<String, int> specialMap = {};
      for (final MapEntry<String, int> entry in standardSpecialTokenIds.entries) {
        specialMap[entry.key] = mutableVocab[entry.key] ?? entry.value;
      }
      _specialTokens = specialMap;
    }
  }

  /// Tokenize Vietnamese text using PhoBERT's approach
  List<String> tokenize(String text) {
    // PhoBERT follows RoBERTa tokenization with Vietnamese-specific handling
    if (text.trim().isEmpty) {
      _logger.info("Empty text for tokenization");
      return [];
    }

    // 1. Lowercase text if needed
    String processedText = _doLowerCase ? text.toLowerCase() : text;

    // 2. Handle spaces for PhoBERT (spaces are significant in Vietnamese)
    if (!_spacesInInput) {
      // Replace spaces with a special character
      processedText = processedText.replaceAll(" ", "▁");
    }

    // 3. Split into words first, then handle punctuation separately
    final List<String> words = [];
    final RegExp wordMatcher = RegExp(r'\S+|\s+');
    final Iterable<RegExpMatch> matches = wordMatcher.allMatches(processedText);

    for (final RegExpMatch match in matches) {
      final String word = match.group(0)!;
      if (word.trim().isEmpty) continue;

      // Handle punctuation separately for better compatibility with Python
      if (RegExp(r'[\s\p{P}]+').hasMatch(word)) {
        // Add each punctuation character as a separate token
        for (int i = 0; i < word.length; i++) {
          words.add(word[i]);
        }
      } else {
        // Add regular word as a whole
        words.add(word);
      }
    }

    // 4. Process each word with BPE
    final List<String> finalTokens = [];
    int bpeFailures = 0;

    for (final String word in words) {
      // Skip empty words
      if (word.trim().isEmpty) continue;

      // Keep special tokens as is
      if (_neverSplit.contains(word)) {
        finalTokens.add(word);
        continue;
      }

      try {
        // First check if the whole word is in vocabulary
        if (_vocab.containsKey(word)) {
          finalTokens.add(word);
          continue;
        }

        // Apply BPE encoding to whole words
        final List<String> bpeEncoded = _bpeEncodeWord(word);
        if (bpeEncoded.isEmpty) {
          // Add as unknown token if it's not in vocabulary
          finalTokens.add(word);
          bpeFailures++;
        } else {
          finalTokens.addAll(bpeEncoded);
        }
      } catch (e) {
        _logger.severe("Error in BPE encoding for word '$word': ${e.toString()}");
        finalTokens.add(word);
        bpeFailures++;
      }
    }

    if (bpeFailures > 0) {
      _logger.warning("BPE failed for $bpeFailures out of ${words.length} words");
    }

    return finalTokens;
  }

  /// BPE encoding for a whole word
  List<String> _bpeEncodeWord(String word) {
    if (word.isEmpty) return [];

    // Single character words - check if in vocabulary
    if (word.length == 1) {
      return _vocab.containsKey(word) ? [word] : [word];
    }

    // Perform BPE encoding on the word level
    return _performBpeEncodingOnWord(word);
  }

  /// Performs the actual BPE encoding on a word, similar to Python HuggingFace implementation
  List<String> _performBpeEncodingOnWord(String word) {
    // Initial character-level split
    final List<String> chars = word.split('').toList();

    // Early return if word is just a single character
    if (chars.length == 1) {
      return chars;
    }

    // Get initial pairs
    Set<Pair<String, String>> pairs = _getPairs(chars);

    // Iteratively merge pairs according to BPE merges priority
    while (pairs.isNotEmpty) {
      final Pair<String, String>? bigram = _findBestBigram(pairs);
      if (bigram == null) break;

      final String first = bigram.first;
      final String second = bigram.second;
      final List<String> newChars = [];
      int i = 0;

      while (i < chars.length) {
        // Find next occurrence of first token in pair
        final int j = _indexOf(chars, first, i);

        if (j == -1) {
          // No more occurrences, add remaining tokens
          newChars.addAll(chars.sublist(i));
          break;
        }

        // Add tokens before the match
        if (j > i) {
          newChars.addAll(chars.sublist(i, j));
        }

        // Check if this is a pair match
        if (j < chars.length - 1 && chars[j] == first && chars[j + 1] == second) {
          // Merge the pair
          newChars.add(first + second);
          i = j + 2;
        } else {
          // Not a pair, add single token
          newChars.add(chars[j]);
          i = j + 1;
        }
      }

      chars.clear();
      chars.addAll(newChars);

      // If we're down to a single token, we're done
      if (chars.length == 1) {
        break;
      }

      // Update pairs for next iteration
      pairs = _getPairs(chars);
    }

    // Check if final tokens exist in vocabulary
    final List<String> finalTokens = [];

    for (final String token in chars) {
      if (_vocab.containsKey(token)) {
        // Token is in vocabulary, add as-is
        finalTokens.add(token);
      } else {
        // Not in vocabulary - handle subwords
        final List<String> subTokens = _findSubwords(token);
        finalTokens.addAll(subTokens);
      }
    }

    return finalTokens;
  }

  /// Find valid subwords for an out-of-vocabulary token
  List<String> _findSubwords(String token) {
    // If token is a single character not in vocabulary, it will be replaced with UNK later
    if (token.length == 1) {
      return [token];
    }

    final List<String> result = [];
    int start = 0;

    // Find valid subwords using longest-prefix matching
    while (start < token.length) {
      int end = token.length;
      bool found = false;

      // Try to find the longest prefix that's in the vocabulary
      while (end > start) {
        final String subToken = token.substring(start, end);
        if (_vocab.containsKey(subToken)) {
          result.add(subToken);
          start = end;
          found = true;
          break;
        }
        end--;
      }

      // If no valid prefix found, add single character and continue
      if (!found) {
        result.add(token.substring(start, start + 1));
        start++;
      }
    }

    return result;
  }

  /// Get all pairs of adjacent tokens in word
  Set<Pair<String, String>> _getPairs(List<String> word) {
    final Set<Pair<String, String>> pairs = {};
    for (int i = 0; i < word.length - 1; i++) {
      pairs.add(Pair(word[i], word[i + 1]));
    }
    return pairs;
  }

  /// Find the best bigram to merge according to BPE priority
  Pair<String, String>? _findBestBigram(Set<Pair<String, String>> pairs) {
    Pair<String, String>? bestPair;
    int minIdx = 9999999;

    for (final Pair<String, String> pair in pairs) {
      final int idx = _bpeMerges.indexOf(pair);
      if (idx != -1 && idx < minIdx) {
        minIdx = idx;
        bestPair = pair;
      }
    }

    return bestPair;
  }

  /// Convert tokens to token IDs
  List<int> convertTokensToIds(List<String> tokens) {
    // Check if vocab is properly initialized
    if (_vocab.isEmpty) {
      _logger.severe("Vocabulary is empty! Cannot convert tokens to IDs.");
      return List.filled(tokens.length, 1); // Return non-zero dummy IDs
    }

    // Get UNK token ID with a fallback
    final int unkId = _vocab[_unkToken] ?? 1;

    // Convert tokens to IDs
    return tokens.map((token) => _vocab[token] ?? unkId).toList();
  }

  /// Full encoding process: tokenize text and convert to IDs
  List<int> encode(String text, {bool addSpecialTokens = true}) {
    // Check if vocab is properly initialized first
    if (_vocab.isEmpty) {
      _logger.severe("Vocabulary is empty! Cannot encode text. Did you call initialize()?");
      // Return some dummy tokens just to allow the process to continue
      final int dummyTokens = addSpecialTokens ? 2 : 0;
      return List.filled(text.length + dummyTokens, 1); // Use 1 instead of 0 to distinguish from padding
    }

    final List<String> tokens = [];

    // Add CLS token if needed
    if (addSpecialTokens && _clsToken.isNotEmpty) {
      tokens.add(_clsToken);
    }

    // Check if text is empty
    if (text.trim().isNotEmpty) {
      // Add tokenized text
      final List<String> textTokens = tokenize(text);
      if (textTokens.isNotEmpty) {
        tokens.addAll(textTokens);
      } else {
        // Fallback to character tokenization if regular tokenization fails
        final List<String> charTokens = text.split('');
        tokens.addAll(charTokens);
      }
    }

    // Add SEP token if needed
    if (addSpecialTokens && _sepToken.isNotEmpty) {
      tokens.add(_sepToken);
    }

    // Get the UNK token ID, with a fallback
    final int unkId = _vocab[_unkToken] ?? 1; // Use 1 as fallback if UNK token not found (0 is usually padding)

    // Convert to IDs
    final List<int> ids = tokens.map((token) => _vocab[token] ?? unkId).toList();

    // Truncate if needed
    return ids.length > maxLength ? ids.sublist(0, maxLength) : ids;
  }

  /// Create model input specifically formatted like Hugging Face tokenizers
  /// This follows the specific requested pattern: [PAD] + content + [CLS] + padding
  /// With the constraint that CLS must be at position 3.
  Pair<List<int>, List<int>> createPythonStyleModelInput(String text) {
    _logger.info("Creating custom model input format for: $text");

    // Safety check - ensure maximum length is positive
    if (maxLength <= 0) {
      _logger.severe("Invalid maxLength: $maxLength, using 96 as fallback");
      maxLength = 96; // Fallback to default
    }

    // Verify special token IDs
    final int padId = _vocab[_padToken] ?? 0;
    final int unkId = _vocab[_unkToken] ?? 1;
    final int clsId = _vocab[_clsToken] ?? 2;

    // 1. Tokenize the text using our word-level tokenizer
    final List<String> wordTokens = tokenize(text);

    // 2. Convert tokens to IDs
    final List<int> contentIds = convertTokensToIds(wordTokens);

    // 3. Create model input with special tokens in the requested order
    final List<int> inputIds = [];

    // Start with PAD token at position 0
    inputIds.add(padId);

    // Fixed number of content tokens between PAD and CLS
    const int contentPositions = 2; // Positions 1 and 2 are for content

    if (contentIds.isEmpty) {
      // No content - fill with UNK tokens
      for (int i = 0; i < contentPositions; i++) {
        inputIds.add(unkId);
      }
    } else if (contentIds.length <= contentPositions) {
      // We have enough space for all content tokens
      inputIds.addAll(contentIds);

      // Fill any remaining positions with UNK
      for (int i = 0; i < contentPositions - contentIds.length; i++) {
        inputIds.add(unkId);
      }
    } else {
      // More content tokens than positions - use a smart selection strategy:
      // Priority order: first token, last token, middle tokens
      if (contentPositions == 1) {
        // If only one position, just use the first token
        inputIds.add(contentIds.first);
      } else if (contentPositions == 2) {
        // If two positions, use first and last tokens
        inputIds.add(contentIds.first);
        inputIds.add(contentIds.last);
      } else {
        // For more positions, use first, last, and important middle tokens
        inputIds.add(contentIds.first);

        // Add middle tokens if enough space
        const int middleTokensToAdd = contentPositions - 2;
        if (middleTokensToAdd > 0) {
          // Calculate which middle tokens to include
          final double step = contentIds.length / (middleTokensToAdd + 1);
          for (int i = 1; i <= middleTokensToAdd; i++) {
            final int index = (i * step).toInt().clamp(1, contentIds.length - 2);
            inputIds.add(contentIds[index]);
          }
        }

        // Add last token
        inputIds.add(contentIds.last);
      }
    }

    // Add CLS token at position 3
    inputIds.add(clsId);

    // If there's still space and we have more content tokens,
    // add them after the CLS token up to maxLength
    if (inputIds.length < maxLength && contentIds.length > contentPositions) {
      // Skip the tokens we've already included (the first and last/selected ones)
      final Set<int> usedIndices = {0}; // First token is always included

      // Now add remaining tokens in original order
      for (int i = 0; i < contentIds.length; i++) {
        if (!usedIndices.contains(i)) {
          inputIds.add(contentIds[i]);
          // Stop if we've reached maxLength
          if (inputIds.length >= maxLength) break;
        }
      }
    }

    // Fill the remaining space with UNK tokens until we reach maxLength
    while (inputIds.length < maxLength) {
      inputIds.add(unkId);
    }

    // Ensure we don't exceed maxLength
    if (inputIds.length > maxLength) {
      final int excessLength = inputIds.length - maxLength;
      for (int i = 0; i < excessLength; i++) {
        inputIds.removeLast();
      }
    }

    // SAFETY CHECK: Ensure inputIds is not empty
    if (inputIds.isEmpty) {
      _logger.severe("ERROR: inputIds is empty! Adding fallback values.");
      inputIds.add(padId);
      inputIds.add(unkId);
      inputIds.add(unkId);
      inputIds.add(clsId);
      // Fill remaining with UNK
      while (inputIds.length < maxLength) {
        inputIds.add(unkId);
      }
    }

    // Create attention mask:
    // - If value in inputIds is 1, then attentionMask should be 0
    // - Otherwise (if value in inputIds is NOT 1), then attentionMask should be 1
    final List<int> attentionMask = List.generate(
      inputIds.length,
          (index) => inputIds[index] == 1 ? 0 : 1,
    );

    // Verify lengths match
    if (inputIds.length != maxLength || attentionMask.length != maxLength) {
      _logger.severe(
        "Length mismatch: inputIds=${inputIds.length}, attentionMask=${attentionMask.length}, expected=$maxLength",
      );

      // Fix length mismatch if needed
      if (inputIds.length != maxLength) {
        final List<int> fixedList = List.generate(
          maxLength,
              (index) => index < inputIds.length ? inputIds[index] : unkId,
        );
        inputIds.clear();
        inputIds.addAll(fixedList);
      }

      if (attentionMask.length != maxLength) {
        final List<int> fixedMask = List.generate(
          maxLength,
              (index) => index < attentionMask.length ? attentionMask[index] : 0,
        );
        attentionMask.clear();
        attentionMask.addAll(fixedMask);
      }
    }

    // Log the first few IDs for verification
    _logger.info("First few IDs: ${inputIds.take(inputIds.length < 10 ? inputIds.length : 10).toList()}");
    _logger.info("First few attention mask values: ${attentionMask.take(attentionMask.length < 10 ? attentionMask.length : 10).toList()}");

    return Pair(inputIds, attentionMask);
  }

  /// Find the index of an element in a list starting from a given index
  int _indexOf(List<String> list, String element, int startIndex) {
    for (int i = startIndex; i < list.length; i++) {
      if (list[i] == element) {
        return i;
      }
    }
    return -1;
  }
}

/// A simple Pair class to hold two values
class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Pair && first == other.first && second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  String toString() => '($first, $second)';
}

/// Extension method for Lists
extension ListExtension<T> on List<T> {
  /// Take n elements from the list
  Iterable<T> take(int n) {
    return sublist(0, n < length ? n : length);
  }
}