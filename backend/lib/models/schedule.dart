class ScheduleItem {
  final String day;         
  final int slot;           
  final String subject;   
  final String teacherId; 

  ScheduleItem({
    required this.day,
    required this.slot,
    required this.subject,
    required this.teacherId,
  });

  Map<String, dynamic> toMap() => {
        'day': day,
        'slot': slot,
        'subject': subject,
        'teacherId': teacherId,
      };

  static ScheduleItem fromMap(Map<String, dynamic> map) => ScheduleItem(
        day: map['day'],
        slot: map['slot'],
        subject: map['subject'],
        teacherId: map['teacherId'],
      );
}

class ClassSchedule {
  final String classId; 
  final String week;   
  final List<ScheduleItem> schedule;

  ClassSchedule({
    required this.classId,
    required this.week,
    required this.schedule,
  });

  Map<String, dynamic> toMap() => {
        'classId': classId,
        'week': week,
        'schedule': schedule.map((e) => e.toMap()).toList(),
      };

  static ClassSchedule fromMap(Map<String, dynamic> map) => ClassSchedule(
        classId: map['classId'],
        week: map['week'],
        schedule: (map['schedule'] as List)
            .map((e) => ScheduleItem.fromMap(e))
            .toList(),
      );
}
