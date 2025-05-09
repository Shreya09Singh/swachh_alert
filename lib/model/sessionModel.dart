class SessionModel {
  final String sessionId;
  final String sessionName;
  final int actualDuration;
  final String filePath;
  final String imageUrl;

  SessionModel({
    required this.sessionId,
    required this.sessionName,
    required this.actualDuration,
    required this.filePath,
    this.imageUrl = "https://i.ytimg.com/vi/jv_uolrknjA/maxresdefault.jpg",
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['sessionId'],
      sessionName: json['sessionName'],
      actualDuration: json['actualDuration'],
      filePath: json['filePath'],
      imageUrl: json.containsKey('imageUrl') && json['imageUrl'] != null
          ? json['imageUrl']
          : "https://i.ytimg.com/vi/jv_uolrknjA/maxresdefault.jpg", // Default image URL
    );
  }
}
