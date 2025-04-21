class Recording {
  final String id;
  String name;
  final String duration;
  final DateTime createdAt;
  // final String recordingText;
  final String recording;

  Recording({
    required this.id,
    required this.name,
    required this.duration,
    required this.createdAt,
    // required this.recordingText,
    required this.recording,
  });

  static Recording jsonToRecording(Map recording) {
    return Recording(
      id: recording['_id'],
      name: recording['name'],
      duration: recording['duration'],
      createdAt: DateTime.parse(recording['createdAt']).toLocal(),
      // recordingText: recording['recordingText'],
      recording: recording['recording'],
    );
  }
}
