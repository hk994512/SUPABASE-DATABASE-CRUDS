class Note {
  int? id;
  String content;
  Note({this.id, required this.content});

  /* Map to Note */
  factory Note.fromMap(Map<String, dynamic> map) {
    final content = map['content'] as String;
    final id = map['id'] as int;
    return Note(content: content, id: id);
  }
  /* note to map
   */
  Map<String, dynamic> toMap() {
    return {'content': content};
  }
}
