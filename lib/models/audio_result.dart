import 'dart:io';

class AudioResult {
  final File file;
  final String tag;

  const AudioResult({required this.file, required this.tag});

  AudioResult copyWith({
    File? file,
    String? tag,
  }) {
    return AudioResult(
      file: file ?? this.file,
      tag: tag ?? this.tag,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is AudioResult) {
      return file.path == other.file.path && tag == other.tag;
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll([file, tag]);
}
