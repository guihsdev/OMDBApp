import 'dart:convert';
import 'dart:io';
import 'package:omdbapp/providers/omdbapi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'omdbv1.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Films('
          'id INTEGER PRIMARY KEY,'
          'Title TEXT,'
          'Year TEXT,'
          'Rated TEXT,'
          'Released TEXT,'
          'Runtime TEXT,'
          'Genre TEXT,'
          'Director TEXT,'
          'Writer TEXT,'
          'Actors TEXT,'
          'Plot TEXT,'
          'Language TEXT,'
          'Country TEXT,'
          'Awards TEXT,'
          'Poster TEXT,'
          'Metascore TEXT,'
          'imdbRating TEXT,'
          'imdbVotes TEXT,'
          'imdbID TEXT,'
          'Type TEXT,'
          'DVD TEXT,'
          'BoxOffice TEXT,'
          'Production TEXT,'
          'Website TEXT,'
          'Response TEXT,'
          'fav INTEGER'
          ')');
      await db.execute('CREATE TABLE Ratings('
          'id INTEGER PRIMARY KEY,'
          'imdbID TEXT,'
          'Source TEXT,'
          'Value TEXT'
          ')');
    });
  }

  insertFilm(Films newFilm, List<Ratings> newRate) async {
    final db = await database;
    final res = await db.insert('Films', newFilm.toJson());
    newRate.forEach((element) async {
      await insertRatings(element);
    });

    return res;
  }

  Future<int> deleteAllFilms() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Films');
    deleteAllRatings();

    return res;
  }

  Future<List<Films>> getAllFilms() async {
    final db = await database;
    final res = await db.rawQuery(
        "SELECT DISTINCT imdbID, Title, Year, Rated, Released, Runtime," +
            " Genre, Director, Writer, Actors, Plot, Language, Country," +
            " Awards, Poster, Metascore, imdbRating, imdbVotes, Type, DVD," +
            " BoxOffice, Production, Website, Response, fav from Films");
    List<Films> list =
        res.isNotEmpty ? res.map((c) => Films.fromJson(c)).toList() : [];
    return list;
  }

  Future<int> setFavFilm(int fav, String imdbID) async {
    final db = await database;
    final res = await db
        .rawUpdate("UPDATE Films SET fav = $fav WHERE imdbID = '$imdbID'");
    return res;
  }

  Future<List<Films>> getByTitleFilms({String title, String year}) async {
    final db = await database;
    final res = await db.rawQuery(
        "SELECT DISTINCT imdbID, Title, Year, Rated, Released, Runtime," +
            " Genre, Director, Writer, Actors, Plot, Language, Country," +
            " Awards, Poster, Metascore, imdbRating, imdbVotes, Type, DVD," +
            " BoxOffice, Production, Website, Response, fav from Films A " +
            " WHERE A.title LIKE '$title%' AND A.year = '$year'");

    List<Films> list =
        res.isNotEmpty ? res.map((c) => Films.fromJson(c)).toList() : [];
    return list;
  }

  Future<Films> getFilmByImdbId({String imdbID}) async {
    final db = await database;
    final res =
        await db.rawQuery("SELECT * FROM Films A WHERE A.imdbID = '$imdbID'");
    final resRating = await db
        .rawQuery("SELECT Source, Value FROM Ratings WHERE imdbID = '$imdbID'");

    Map fMap;
    Films film;
    if (res.isNotEmpty) {
      res.forEach((element) {
        fMap = element;
      });
      Map<String, dynamic> newData = Map<String, dynamic>.from(fMap);
      String val = "[";
      resRating.forEach((elements) {
        val = val +
            "{ \"Source\": \"${elements['Source']}\",\"Value\": \"${elements['Value']}\" },";
      });
      if (val.endsWith(",")) {
        val = val.substring(0, val.length - 1);
      }
      val = val + "]";
      print(val);
      newData['Ratings'] = jsonDecode(val);
      film = Films.fromJson(newData);
    }
    return film;
  }

  Future<List<Films>> getAllFavFilms() async {
    final db = await database;
    final res = await db.rawQuery(
        "SELECT DISTINCT imdbID, Title, Year, Rated, Released, Runtime," +
            " Genre, Director, Writer, Actors, Plot, Language, Country," +
            " Awards, Poster, Metascore, imdbRating, imdbVotes, Type, DVD," +
            " BoxOffice, Production, Website, Response, fav from Films " +
            " WHERE fav = 1");

    List<Films> list =
        res.isNotEmpty ? res.map((c) => Films.fromJson(c)).toList() : [];

    return list;
  }

  insertRatings(Ratings newRate) async {
    final db = await database;
    final res = await db.insert('Ratings', newRate.toJson());

    return res;
  }

  Future<int> deleteAllRatings() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Ratings');
    return res;
  }
}
