import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/Goal.dart';

class GoalDatabase
{
  static GoalDatabase _goalDatabase; //two databasses and keys to be input
  static Database _database;        

	String _goalTable = 'goal_table';
	String _id = 'id';
	String _name = 'name';
	String _description = 'description';
	String _amount = 'amount';
	String _date = 'date';

  GoalDatabase._createInstance();

  factory GoalDatabase() 
  {
    if (_goalDatabase == null) {_goalDatabase = GoalDatabase._createInstance();} //if it's not created, create instance of goal database
    return _goalDatabase;
  }

  Future<Database> get database async  //return normal database that will be copied into goaldatabase
  {
    if (_database == null) {_database = await initializeDatabase();} 
    return _database;
  }

  Future<Database> initializeDatabase() async //intialize database
  {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'goals.db';

    var goalsDatabase = await openDatabase(path, version: 1, onCreate: _createDatabase); //open the database & return it, if not created, create it. 
    return goalsDatabase;
  }

  void _createDatabase(Database database, int newVersion) async //creates 5 ids and adds three dummy tasks
  {
    await database.execute('''
      CREATE TABLE $_goalTable (
        $_id INTEGER PRIMARY KEY AUTOINCREMENT, 
        $_name TEXT, 
        $_amount INTEGER,  
        $_date TEXT,
        $_description TEXT)''');

    await database.rawInsert('INSERT INTO $_goalTable ($_name, $_description, $_amount, $_date) VALUES("Pass this interview", "Flutter 1 is a mess", 100, "today")');
    await database.rawInsert('INSERT INTO $_goalTable ($_name, $_description, $_amount, $_date) VALUES("goal2", "test", 2, "Tuesday")');
    await database.rawInsert('INSERT INTO $_goalTable ($_name, $_description, $_amount, $_date) VALUES("goal3", "test", 3, "Friday")');
    await database.rawInsert('INSERT INTO $_goalTable ($_name, $_description, $_amount, $_date) VALUES("goal4", "test", 4, "Saturday")');
    await database.rawInsert('INSERT INTO $_goalTable ($_name, $_description, $_amount, $_date) VALUES("goal5", "test", 5, "Sunday")');
  }
  
  Future<List<Map<String, dynamic>>> getGoalsMap() async 
  {
    Database db = await this.database;
    var result = await db.query(_goalTable);
    /* result.forEach((row) => print(row)); //prints da database */
    return result;
  }

  Future<int> insertGoal(Goal goal) async //return value is id of inserted row
  {
		Database db = await this.database;
		var result = await db.insert(_goalTable, goal.toMap());
		return result;
	}

  Future<int> updateGoal(Goal goal) async 
  {
		Database db = await this.database;
		var result = await db.update(_goalTable, goal.toMap(), where: '$_id = ?', whereArgs: [goal.id]);
		return result;
	}

	Future<int> deleteGoal(int id) async 
  {
		Database db = await this.database;
		int result = await db.rawDelete('DELETE FROM $_goalTable WHERE $_id = $id');
		return result;
	}

	Future<int> getSize() async 
  {
		Database db = await this.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $_goalTable');
		int result = Sqflite.firstIntValue(x);
		return result;
	}

  Future<List<Goal>> getGoalsList() async 
  {
		var goalMapList = await getGoalsMap();
		List<Goal> goalList = List<Goal>();

		for (int i = 0; i < goalMapList.length; i++) 
    {
			goalList.add(Goal.fromMapObject(goalMapList[i]));
		}

		return goalList;
	}
}