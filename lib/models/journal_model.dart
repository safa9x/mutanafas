class Journal {
  final int? id;
  final String content;
  final String createdAt;

  Journal({
    this.id,
    required this.content,
    required this.createdAt,
  });

  factory Journal.fromMap(Map<String, dynamic> map) {
    return Journal(
      id: map['id'] as int?,
      content: map['content'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt,
    };
  }
}