class Repeat_Task{
  String id; 
  String taskId;
  String weekDay;
  String nextDueDate;
  int interval;
  Repeat_Task(this.id, this.taskId, this.weekDay, this.nextDueDate, this.interval);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'weekDay': weekDay,
      'nextDueDate': nextDueDate,
      'interval': interval,
    };}
  factory Repeat_Task.fromMap(Map<String, dynamic> map) {
    return Repeat_Task(
      map['id'],
      map['taskId'],
      map['weekDay'],
      map['nextDueDate'],
      map['interval'],
    );
  }
}