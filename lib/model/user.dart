class User {
  String uid;
  List<TodoItem> todoList;
  List<String> folders;

  User({
    required this.uid,
    required this.todoList,
    required this.folders,
  });

  //get json[Map], return [User]
  factory User.fromJson(Map<String, dynamic> json) => User(
    uid: json["uid"],
    todoList: json["todoList"].map((todo) => TodoItem.fromJson(todo)),
    folders: json["folders"].map((folder) => folder),
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "todoList": todoList.map((item) => item.tojson()),
    "folders": folders,
  };
}

class TodoItem  {
  String name;
  String date;
  String place;
  String note;
  String folder;

  TodoItem ({
    required this.name,
    required this.date,
    required this.place,
    required this.note,
    required this.folder,
  });
  
  factory TodoItem.fromJson(Map<String, dynamic> json) {
  return TodoItem(
    name: json['name'],
    date: json['date'],
    place: json['place'] ,
    note: json['note'] ,
    folder: json['folder'] ,
  );
}

  Map<String, dynamic> tojson()=>{
    "name": name,
    "date": date,
    "place": place,
    "note": note,
    "folder": folder,
  };
}