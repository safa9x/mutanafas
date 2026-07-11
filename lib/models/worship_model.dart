class WorshipItem {
  final int? id;
  final String name;
  final String description;
  final String type;
  final String date;
  final bool isCompleted;
  final int iconCode;

  WorshipItem({
    this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.date,
    required this.isCompleted,
    required this.iconCode,
  });

// تحول البيانات القادمة من قاعدة البيانات → إلى object من نوع WorshipItem.

  factory WorshipItem.fromMap(Map<String, dynamic> json) {
    return WorshipItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      date: json['date'],
      isCompleted: json['isCompleted'] == 1,
      iconCode: json['iconCode'],
    );
  }
// تحول الـ object → إلى Map
// عشان نحفظه في قاعدة البيانات.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'date': date,
      'isCompleted': isCompleted ? 1 : 0,
      'iconCode': iconCode,
    };
  }


  
}