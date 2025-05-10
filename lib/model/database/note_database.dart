import 'package:practise_pro/model/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteDatabase {
  /* Database to Notes */
  final database = Supabase.instance.client.from('notes');

  /*create*/
  Future createNote(Note newNote) async {
    await database.insert(newNote.toMap());
  }

  /*read  */
  Stream<List<Note>> getStream() {
    return Supabase.instance.client
        .from('notes')
        .stream(primaryKey: ['id'])
        .map((data) => data.map((noteMap) => Note.fromMap(noteMap)).toList());
  }
  /* update */

  Future updateNote(Note oldNote, String newNote) async {
    return database.update({'content': newNote}).eq('id', oldNote.id!);
  }

  /*delete  */
  Future deleteNote(Note note) async {
    await database.delete().eq('id', note.id!);
  }
}
