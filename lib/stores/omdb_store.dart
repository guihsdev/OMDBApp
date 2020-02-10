import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:omdbapp/consts/consts_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:omdbapp/models/omdblocal.dart';
import 'package:omdbapp/providers/omdbapi.dart';
import 'package:mobx/mobx.dart';

/// [part] É o arquivo onde o MobX gera o gerenciamento de estados.
part 'omdb_store.g.dart';
/*
Para poder trabalhar com MobX
flutter packages pub run build_runner build (novo storage, mas pode executar num storage existente também).
flutter packages pub run build_runner clean build (limpa o storage existente).
flutter packages pub run build_runner watch (alterações no storage já existente).
 */

/// [observable] Variavel que o MobX fica "escutando".
/// [computed] Variavel onde é carregado os dados para o MobX tratar.
/// [action] Função acessivel pelo MobX onde pode ser disparado uma ação de qualquer lugar para qualquer lugar do App.

class OmdbStore = _OmdbStoreBase with _$OmdbStore;

abstract class _OmdbStoreBase with Store {
  @observable
  Films _film;
  @computed
  Films get film => _film;

  /// [fetchFilmApi] Interface da MobX para requisitar à API.
  @action
  fetchFilmApi({String ano, String filme, String plot}) {
    _film = null;
    loadOmdbApi(ano: ano, filme: filme, plot: plot).then((film) {
      _film = film;
    });
  }

  /// [loadOmdbApi] Faz a requisição e trata a resposta da API
  Future<Films> loadOmdbApi({String ano, String filme, String plot}) async {
    try {
      final response =
          await http.get(ConstsApi(ano: ano, filme: filme, plot: plot).apiUrl);
      var decodeJson = jsonDecode(response.body);
      decodeJson['fav'] = 0;
      if (decodeJson['Response'] == 'False') {
        Films failFilm = Films.fromJson(decodeJson);
        return failFilm;
      } else {
        //Capturo o link do poster e o ID do IMDB para salvar localmente
        decodeJson['Poster'] = await _downloadAndSavePhoto(
            decodeJson['Poster'], decodeJson['imdbID']);
        if (decodeJson["Year"] != null && decodeJson["Year"] != "N/A") {
          decodeJson["Year"] =
              decodeJson["Year"].toString().replaceAll(RegExp(r'[\D]+'), "");
        }
        Films film = Films.fromJson(decodeJson);
        DBProvider.db.insertFilm(film, film.ratings);
        return film;
      }
    } catch (error, stacktrace) {
      print("Erro ao carregar o filme: $error + ${stacktrace.toString()}");
      return null;
    }
  }

  @observable
  List<Films> _listFavFilms;
  @computed
  List<Films> get favFilms => _listFavFilms;

  /// [fetchFavsFilms] MobX requisita ao Banco de Dados os filmes favoritos.
  @action
  fetchFavsFilms() {
    _listFavFilms = null;
    loadOmdbLocalFavFilms().then((filmList) {
      _listFavFilms = filmList;
    });
  }

  Future<List<Films>> loadOmdbLocalFavFilms() async {
    try {
      List<Films> response = await DBProvider.db.getAllFavFilms();
      return response;
    } catch (error, stacktrace) {
      print("Erro ao carregar o filme: $error + ${stacktrace.toString()}");
      return null;
    }
  }

  @observable
  List<Films> _listLocalFilms;
  @computed
  List<Films> get localFilms => _listLocalFilms;

  /// [fetchLocalFilms] MobX requisita ao Banco de Dados filmes que já foram pesquisados.
  @action
  fetchLocalFilms() {
    _listLocalFilms = null;
    loadOmdbLocalFilms().then((filmList) {
      _listLocalFilms = filmList;
    });
  }

  Future<List<Films>> loadOmdbLocalFilms() async {
    try {
      List<Films> response = await DBProvider.db.getAllFilms();
      return response;
    } catch (error, stacktrace) {
      print("Erro ao carregar o filme: $error + ${stacktrace.toString()}");
      return null;
    }
  }

  @observable
  Films _imdbFilm;
  @computed
  Films get imdbFilm => _imdbFilm;

  /// [fetchFilmsByImdbId] MobX requisita ao Banco um filme pelo ID do IMDB
  @action
  fetchFilmsByImdbId({String imdbId}) {
    // _imdbFilm = null;
    loadOmdbLocalFilmsByImdbId(imdbId: imdbId).then((filmRes) {
      _imdbFilm = filmRes;
    });
  }

  Future<Films> loadOmdbLocalFilmsByImdbId({String imdbId}) async {
    try {
      return await DBProvider.db.getFilmByImdbId(imdbID: imdbId);
    } catch (error, stacktrace) {
      print(
          "Erro ao carregar o filme por imdb: $error |+| ${stacktrace.toString()}");
      return null;
    }
  }

  @observable
  int _resFav;
  @observable
  int _favValue;
  @computed
  int get respondeFavFilm => _resFav;
  @computed
  int get favValue => _favValue;

  /// [setFavFilm] MobX Altera o no banco de dados o valor de favorito
  @action
  setFavFilm({int fav, String imdbID}) {
    _resFav = null;
    setFavValue(fav: fav);
    loadOmdbLocalSetFavFilm(fav: fav, imdbID: imdbID).then((favResp) {
      _resFav = favResp;
    });
  }

  /// [setFavValue] Altera o observer para mudar o estado da View no click
  @action
  setFavValue({int fav}) {
    _favValue = fav;
  }

  Future<int> loadOmdbLocalSetFavFilm({int fav, String imdbID}) async {
    try {
      int response = await DBProvider.db.setFavFilm(fav, imdbID);
      return response;
    } catch (error, stacktrace) {
      print("Erro ao set fav: $error + ${stacktrace.toString()}");
      return null;
    }
  }

  @observable
  List<Films> _listFilmsByTitleYear;
  @computed
  List<Films> get filmsByTitleYear => _listFilmsByTitleYear;

  ///[fetchFilmsByTitleYear] MobX Carrega os filmes do banco de dados por título e ano.
  @action
  fetchFilmsByTitleYear({String title, year}) {
    _listFilmsByTitleYear = null;
    loadOmdbLocalFilmsByTitleYear(title: title, year: year)
        .then((filmsByTitleYear) {
      _listFilmsByTitleYear = filmsByTitleYear;
    });
  }

  Future<List<Films>> loadOmdbLocalFilmsByTitleYear(
      {String title, year}) async {
    try {
      List<Films> response =
          await DBProvider.db.getByTitleFilms(title: title, year: year);
      return response;
    } catch (error, stacktrace) {
      print("Erro ao carregar o filme: $error + ${stacktrace.toString()}");
      return null;
    }
  }

  /// [_downloadAndSavePhoto] Baixa a imagem da internet e armazeno no disco local.
  /// [imageUrl] URL da imagem provida da API.
  /// [imdbid] ID unico de cada filme na classificação do IMDB.
  _downloadAndSavePhoto(imageUrl, imdbid) async {
    if (imageUrl != null) {
      String url = imageUrl.toString();
      var response = await get(url);
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path + "/images";
      // Subtituí o arquivo se já existir um igual
      await Directory(firstPath).create(recursive: true);
      var filePathAndName = documentDirectory.path + '/images/pic$imdbid.jpg';
      File file2 = new File(filePathAndName);
      file2.writeAsBytesSync(response.bodyBytes);
      return filePathAndName.toString();
    }
  }
}
