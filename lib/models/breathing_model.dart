class BreathingSession {
  final int? id;
  final int duration;
  final String createdAt;

  BreathingSession({
    this.id,
    required this.duration,
    required this.createdAt,
  });
 
  factory BreathingSession.fromMap(Map<String, dynamic> map) {
    return BreathingSession(
      id: map['id'],
      duration: map['duration'],
      createdAt: map['createdAt'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'duration': duration,
      'createdAt': createdAt,
    };
  }

}