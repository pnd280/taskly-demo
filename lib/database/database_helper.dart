import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:taskly/models/project.dart';
import 'package:taskly/models/reminder.dart';
import 'package:taskly/models/tag.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/models/tagged_tag.dart';
import 'package:taskly/models/repeat_task.dart';
class DatabaseHelper {
  static final _databaseName = "Taskly.db";
  static final _databaseVersion = 1;
  
  //task table
  static final tableTask="task";
  static final columnTaskId = 'id';
  static final columnTaskTitle = 'title';
  static final columnTaskRichDescription = 'rich_description';
  static final columnTaskCreatedAt = 'createdAt';
  static final columnTaskBeginAt = 'beginAt';
  static final columnTaskEndAt = 'endAt';
  static final columnTaskIsVisible = 'isVisible';
  static final columnTaskIsCompleted = 'isCompleted';
  static final columnTaskRepeat = 'repeat';
  static final columnTaskPriority = 'priority';
  static final columnTaskProjectId = 'projectId';

  //project table
  static final tableProject="project";
  static final columnProjectId = 'id';
  static final columnProjectTitle = 'title';
  static final columnProjectDescription = 'description';
  static final columnProjectCreatedAt = 'createdAt';
  static final columnProjectIsVisible = 'isVisible';

  //tag table
  static final tableTag="tag";
  static final columnTagId = 'id';
  static final columnTagTitle = 'title';
  static final columnTagColor = 'color';
  static final columnTagIsVisible = 'isVisible';

  //reminder table
  static final tableReminder="reminder";
  static final columnReminderId = 'id';
  static final columnReminderTaskId = 'taskId';

  //tagged tag table
  static final tableTaggedTag="tagged_tag";
  
  static final columnTaggedTagTaskId = 'taskId';
  static final columnTaggedTagTagId = 'tagId';

  //repeat task table
  static final tableRepeatTask="repeat_task";
  static final columnRepeatTaskId = 'id';
  static final columnweekDay = 'weekDay';
  static final columnNextDueDate = 'nextDueDate';
  static final columnInterval = 'interval';
 
  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }
  Future<void> _onCreate(Database db, int version) async {

    //create Task table
    await db.execute('''
      CREATE TABLE $tableTask (
        $columnTaskId TEXT PRIMARY KEY,
        $columnTaskTitle TEXT ,
        $columnTaskRichDescription TEXT ,
        $columnTaskCreatedAt DATETIME ,
        $columnTaskBeginAt DATETIME ,
        $columnTaskEndAt DATETIME ,
        $columnTaskRepeat BOOLEAN ,
        $columnTaskPriority INTEGER ,
        $columnTaskIsCompleted BOOLEAN ,
        $columnTaskProjectId TEXT ,
        $columnTaskIsVisible BOOLEAN 
        FOREIGN KEY ($columnTaskProjectId) REFERENCES $tableProject($columnProjectId)
      )
    ''');
    //table project
    await db.execute('''
      CREATE TABLE $tableProject (
        $columnProjectId TEXT PRIMARY KEY,
        $columnProjectTitle TEXT ,
        $columnProjectDescription TEXT ,
        $columnProjectCreatedAt DATETIME ,
        $columnProjectIsVisible BOOLEAN DEFAULT TRUE
      )
    ''');
    //table tag
    await db.execute('''
      CREATE TABLE $tableTag (
        $columnTagId TEXT PRIMARY KEY,
        $columnTagTitle TEXT ,
        $columnTagColor TEXT COMMENT 'Hexadecimal format' ,
        $columnTagIsVisible BOOLEAN DEFAULT TRUE
      )
    ''');
    //table reminder
    await db.execute('''
      CREATE TABLE $tableReminder (
        $columnReminderId TEXT PRIMARY KEY,
        $columnReminderTaskId TEXT ,
        FOREIGN KEY ($columnReminderTaskId) REFERENCES $tableTask($columnTaskId)
      )
    ''');
    //table tagged tag
    await db.execute('''
      CREATE TABLE $tableTaggedTag (
        $columnTaggedTagTaskId TEXT ,
        $columnTaggedTagTagId TEXT ,
        FOREIGN KEY ($columnTaggedTagTaskId) REFERENCES $tableTask($columnTaskId),
        FOREIGN KEY ($columnTaggedTagTagId) REFERENCES $tableTag($columnTagId)
      )
    ''');
    //table repeat task
    await db.execute('''
      CREATE TABLE $tableRepeatTask (
        $columnRepeatTaskId TEXT PRIMARY KEY,
        $columnweekDay INTEGER ,
        $columnNextDueDate DATETIME ,
        $columnInterval INTEGER ,
        FOREIGN KEY ($columnRepeatTaskId) REFERENCES $tableTask($columnTaskId)
      )
    ''');
  }
  Future<int> insertTask(Task task) async {
    Database db = await instance.database;
    return await db.insert(tableTask, task.toMap());
  }
  Future<int> insertProject(Project project) async {
    Database db = await instance.database;
    return await db.insert(tableProject, project.toMap());
  }
  Future<int> insertTag(Tag tag) async {
    Database db = await instance.database;
    return await db.insert(tableTag, tag.toMap());
  }
  Future<int> insertReminder(Reminder reminder) async {
    Database db = await instance.database;
    return await db.insert(tableReminder, reminder.toMap());
  }
  Future<int> insertTaggedTag(Tagged taggedTag) async {
    Database db = await instance.database;
    return await db.insert(tableTaggedTag, taggedTag.toMap());
  }
  Future<int> insertRepeatTask(Repeat_Task repeatTask) async {
    Database db = await instance.database;
    return await db.insert(tableRepeatTask, repeatTask.toMap());
  }
  //get all tasks
  Future<List<Task>> getTasks() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableTask);
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        richDescription: maps[i]['rich_description'],
        createdAt: maps[i]['createdAt'],
        beginAt: maps[i]['beginAt'],
        endAt: maps[i]['endAt'],
        repeat: maps[i]['repeat'],
        priority: maps[i]['priority'],
        isCompleted: maps[i]['isCompleted'],
        projectId: maps[i]['projectId'],
        isVisible: maps[i]['isVisible'],
      );
    });
  }


}