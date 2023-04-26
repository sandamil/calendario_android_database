
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtenemos la ruta de la base de datos en el dispositivo
  final dbPath = await getDatabasesPath();
  final String javaDbPath = "/data/data/ajat.calendario.turnos/databases/DBC4A-journal.db";

  // Verificamos si la base de datos de Flutter ya ha sido creada
  final dbExists = await databaseExists(join(dbPath, "flutter_db.db"));

  if (dbExists) {
    // Si la base de datos de Flutter no ha sido creada, la creamos y migramos la información de la base de datos de Java
    await openDatabase(join(dbPath, "flutter_db.db"), onCreate: (db, version) async {
      await db.execute("CREATE TABLE tabla1 (id INTEGER PRIMARY KEY, campo1 TEXT, campo2 TEXT)");
      await db.execute("CREATE TABLE tabla2 (id INTEGER PRIMARY KEY, campo3 TEXT, campo4 TEXT)");
      // Añade aquí las tablas de tu base de datos de Flutter

      // Migrar la información de la base de datos de Java a la de Flutter
      final javaDb = await openDatabase(javaDbPath);
      final javaData = await javaDb.rawQuery("SELECT * FROM notes");
      javaData.forEach((row) async {
        print(row);

        await db.insert("tabla1", row);
      });
      final javaData2 = await javaDb.rawQuery("SELECT * FROM tabla2");
      javaData2.forEach((row) async {
        await db.insert("tabla2", row);
      });
      // Añade aquí la migración de las tablas de tu base de datos de Java a la de Flutter

      print(db.database.toString());
    }, version: 1);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi aplicación',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mi aplicación'),
        ),
        body: Center(
          child: Text('Hola mundo'),
        ),
      ),
    );
  }
}