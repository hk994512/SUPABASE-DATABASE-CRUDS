import '/model/database/note_database.dart';
import '/model/note.dart';
import '/security/secure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: Security.url, anonKey: Security.anon);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Database',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final notesDb = NoteDatabase();
  final notesController = TextEditingController();
  // Add Note
  void addNote() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            // Save Button
            FilledButton(
              onPressed: () async {
                final newNote = Note(content: notesController.text.trim());
                await notesDb.createNote(newNote);
                if (context.mounted) Navigator.pop(context);
                notesController.clear();
              },
              child: Text('Save'),
            ),
            // Cancel Button
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                notesController.clear();
              },
              child: Text('Cancel'),
            ),
          ],
          content: TextField(controller: notesController),
          title: Center(child: Text('Add Note')),
        );
      },
    );
  }

  void updateNote(Note note) {
    notesController.text = note.content;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Note'),
          content: TextField(controller: notesController),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                notesController.clear();
              },
              child: Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final updatedContent = notesController.text.trim();
                if (updatedContent.isNotEmpty) {
                  await notesDb.updateNote(note, updatedContent);
                }
                if (context.mounted) Navigator.pop(context);
                notesController.clear();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text('Supabase Database', style: TextStyle(color: Colors.white)),
      ),

      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        shape: CircleBorder(),
        onPressed: addNote,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Note>>(
        stream: notesDb.getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.content),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => updateNote(note),
                          icon: Icon(Icons.edit, color: Colors.blueGrey),
                        ),
                        IconButton(
                          onPressed: () => notesDb.deleteNote(note),
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
