///class to store a task
class Task{
  String _taskTitle;
  int _index;
  String _id;
  int _dueDate;
  String _searchValue;
  bool _isComplete;
  String _description;


  String get taskTitle => _taskTitle;

  int get index => _index;

  String get id => _id;

  int get dueDate => _dueDate;

  String get searchValue => _searchValue;

  bool get isComplete => _isComplete;

  String get description => _description;

  Task(this._taskTitle, this._index, this._id, this._isComplete);


}