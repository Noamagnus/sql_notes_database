/// this string is the name of the table
const String tableNotes = 'notes';

/// These are fields for database
/// By default id is always written with underscore _id (that a standard)
/// we're using this so it is easier for me later not to make a mistake while writing strings
/// These are going to be our column names
class NoteFields {
  static const List<String> values = [
    id,
    isImportant,
    number,
    title,
    description,
    time,
  ];
  static const String id = '_id';
  static const String isImportant = 'isImportand';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'cratedTime';
}

/// This is a model for a note
class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  /// Method toJson returns a map that
  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.isImportant: isImportant ? 1 : 0,
        NoteFields.number: number,
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.time: createdTime.toIso8601String(),
      };

  /// This method is creating the copy of out current Note object and and we pass only the
  /// value of the object that we want to modify. (in our case it will be id )
  ///
  Note copyWith({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        isImportant: json[NoteFields.isImportant]==1? true:false,
        number: json[NoteFields.number] as int,
        title: json[NoteFields.title] as String,
        description: json[NoteFields.description] as String,
        createdTime: DateTime.parse(json[NoteFields.time] as String) ,
      );
}
