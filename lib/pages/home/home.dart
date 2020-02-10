import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:omdbapp/models/omdblocal.dart';
import 'package:omdbapp/pages/film_detail/film_detail.dart';
import 'package:omdbapp/pages/home/widgets/favFilms.dart';
import 'package:omdbapp/pages/home/widgets/localFilms.dart';
import 'package:omdbapp/providers/omdbapi.dart';
import 'package:omdbapp/stores/omdb_store.dart';
import 'package:provider/provider.dart';

/*
 Esta tela não necessáriamente deve ser StateFul, ela funciona perfeitamente em
 Stateless, o provider me garante a alteração de estado
 */

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FocusNode _textSearchFocus;
  int _selectedYear = DateTime.now().year;
  TextEditingController _textSearchController;
  OmdbStore _omdbStore;
  Films _filme;
  Widget favFilmWidget, localFilmWidget;
  var data;
  String title;

  @override
  void initState() {
    super.initState();
    _textSearchFocus = FocusNode();
  }

  @override
  void didChangeDependencies() {
    /*
     Espero todos os componentes estarem montados para solicitar os dados do
     provider
    */
    super.didChangeDependencies();
    _textSearchController = TextEditingController();
    // Captura do Provider
    _omdbStore = Provider.of<OmdbStore>(context);
    if (_omdbStore.favFilms == null) {
      // Verifico se já existe algum filme favorito, se não busco no Storage
      _omdbStore.fetchFavsFilms();
    }
    if (_omdbStore.localFilms == null) {
      // Verifico se já existe algum filme já pesquisado, se não busco no Storage
      _omdbStore.fetchLocalFilms();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textSearchFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) => Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 23),
                child: TextFormField(
                  controller: _textSearchController,
                  focusNode: _textSearchFocus,
                  textInputAction: TextInputAction.search,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_textSearchFocus);
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    FocusScope.of(context).unfocus();
                    makeSearch(context);
                  },
                  decoration: InputDecoration(
                    labelText: "Procurar um filme...",
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _textSearchController.clear();
                            return null;
                          }),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -15,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        makeSearch(context);
                      }),
                ),
              ),
              Positioned(
                  top: 33.5,
                  right: 0,
                  child: Text(
                    "${_selectedYear.toString()}",
                    style: TextStyle(fontSize: 15),
                  )),
              Positioned(
                  top: 0,
                  right: -6,
                  child: IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        handleYearPicker(context);
                      })),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height - 80,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: Center(
                        child: Text(
                      "Filmes favoritos",
                      style: TextStyle(fontSize: 25),
                    )),
                  ),
                  Container(
                    height: 180,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      child: Observer(
                        name: 'ListFavFilms',
                        builder: (context) {
                          if (_omdbStore.favFilms == null) {
                            favFilmWidget =
                                Center(child: CircularProgressIndicator());
                          } else {
                            if (_omdbStore.favFilms.length == 0) {
                              favFilmWidget = AnimationLimiter(
                                child: AnimationConfiguration.staggeredList(
                                  position: 0,
                                  duration: Duration(milliseconds: 300),
                                  child: ScaleAnimation(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Adicione seus melhores filmes aos favoritos agora mesmo!",
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              Center(
                                                child: Icon(
                                                  Icons.favorite,
                                                  size: 50,
                                                  color: Colors.red,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              favFilmWidget = Container(
                                color: Colors.white,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: _omdbStore.favFilms.length,
                                    itemBuilder: (context, index) {
                                      _filme = _omdbStore.favFilms[index];
                                      return AnimationLimiter(
                                        child: AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration: Duration(milliseconds: 300),
                                          child: ScaleAnimation(
                                            child: InkWell(
                                              enableFeedback: true,
                                              splashColor: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              onTap: () {
                                                print(_filme.title);
                                                _omdbStore.fetchFilmsByImdbId(
                                                    imdbId: _omdbStore
                                                        .favFilms[index].imdbID
                                                        .toString());
                                                _omdbStore.setFavValue(
                                                    fav: _omdbStore
                                                        .favFilms[index].fav);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FilmDetail(
                                                              heroTag:
                                                                  "fav${_omdbStore.favFilms[index].imdbID}",
                                                              film: _omdbStore
                                                                      .favFilms[
                                                                  index],
                                                              index: index,
                                                            ),
                                                        fullscreenDialog:
                                                            true));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Material(
                                                  elevation: 2,
                                                  child: FavFilms(
                                                    heroTag:
                                                        "fav${_filme.imdbID}",
                                                    index: index,
                                                    title: '${_filme.title}',
                                                    poster: '${_filme.poster}',
                                                    rated: '${_filme.rated}',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }
                          }
                          return favFilmWidget;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Center(
                            child: Text(
                          "Filmes pesquisados",
                          style: TextStyle(fontSize: 25),
                        )),
                      ),
                    ),
                    Observer(
                      name: 'ListLocalFilms',
                      builder: (context) {
                        if (_omdbStore.localFilms == null) {
                          localFilmWidget =
                              Center(child: CircularProgressIndicator());
                        } else {
                          if (_omdbStore.localFilms.length == 0) {
                            localFilmWidget = AnimationLimiter(
                              child: AnimationConfiguration.staggeredList(
                                position: 0,
                                duration: Duration(milliseconds: 300),
                                child: ScaleAnimation(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "Pesquise algum filme para ele aparecer aqui!",
                                              style: TextStyle(fontSize: 25),
                                            ),
                                            Center(
                                              child: Icon(
                                                Icons.search,
                                                size: 50,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            localFilmWidget = Flexible(
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: _omdbStore.localFilms.length,
                                  itemBuilder: (context, index) {
                                    _filme = _omdbStore.localFilms[index];
                                    return AnimationLimiter(
                                      child:
                                          AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration: Duration(milliseconds: 300),
                                        child: ScaleAnimation(
                                          child: InkWell(
                                            enableFeedback: true,
                                            splashColor: Colors.blue,
                                            onTap: () {
                                              print(_filme.title);
                                              _omdbStore.fetchFilmsByImdbId(
                                                  imdbId: _omdbStore
                                                      .localFilms[index].imdbID
                                                      .toString());
                                              _omdbStore.setFavValue(
                                                  fav: _omdbStore
                                                      .localFilms[index].fav);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FilmDetail(
                                                            heroTag:
                                                                "local${_omdbStore.localFilms[index].imdbID}",
                                                            film: _omdbStore
                                                                    .localFilms[
                                                                index],
                                                            index: index,
                                                          ),
                                                      fullscreenDialog: true));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Material(
                                                elevation: 2,
                                                child: LocalFilms(
                                                  index: index,
                                                  heroTag:
                                                      "local${_omdbStore.localFilms[index].imdbID}",
                                                  release: _filme.released,
                                                  poster: _filme.poster,
                                                  rated: _filme.rated,
                                                  title: _filme.title,
                                                  fav: _filme.fav,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          }
                        }
                        return localFilmWidget;
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// [makeSearch] Concentro a lógica da pesquisa e os tratamentos de campo
  /// [context] Contexto do ambiente
  void makeSearch(context) async {
    if (_textSearchController.text == '') {
      final snackBar = SnackBar(
        content: Text('Nenhum titulo informado!'),
        action: SnackBarAction(
          label: 'Informar',
          onPressed: () {
            FocusScope.of(context).requestFocus(_textSearchFocus);
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      title = _textSearchController.text;
      List<Films> _listFilms = await DBProvider.db.getByTitleFilms(
          title: _textSearchController.text, year: _selectedYear.toString());
      if (_listFilms.length == 0) {
        _omdbStore.fetchFilmApi(
            ano: _selectedYear.toString(), filme: _textSearchController.text);
        _omdbStore.film;
        _omdbStore.setFavValue(fav: 0);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilmDetail(
                      heroTag: "any",
                      film: null,
                      index: null,
                    ),
                fullscreenDialog: true));
      } else {
        _omdbStore.fetchFilmsByTitleYear(
            title: _textSearchController.text, year: _selectedYear.toString());
        _omdbStore.filmsByTitleYear;
        List<Films> _listFilms = await DBProvider.db.getByTitleFilms(
            title: _textSearchController.text, year: _selectedYear.toString());
        _showDialog(_listFilms, title, _selectedYear);
      }
    }
  }

  /// [handleYearPicker]  Gerenciamento do seletor de ano
  /// [context] Contexto do ambiente
  void handleYearPicker(context) {
    showBottomSheet(
        context: context,
        builder: (BuildContext context) => Center(
              child: Container(
                child: YearPicker(
                  selectedDate: DateTime(
                      (_selectedYear != null ? _selectedYear : DateTime.now())),
                  firstDate: DateTime(1800),
                  lastDate: DateTime(2900),
                  onChanged: (val) {
                    setState(() {
                      _selectedYear = val.year;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ));
  }

  /// [_showDialog]  Concentro a lógica do Dialog aqui, onde apresento os filmes relacionados a pesquisa.
  /// [_listFilms] Lista de filmes já existentes no Banco de Dados, para o Dialog exibir.
  /// [titulo] Título do filme pesquisado
  /// [ano] Ano do filme pesquisado
  void _showDialog(List<Films> _listFilms, String titulo, int ano) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Filmes"),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            content: Observer(
              builder: (context) {
                if (_listFilms.length == 0) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  print(("_listFilms.length + 1: ${(_listFilms.length + 1)}"));
                  return ListView.builder(
                      itemCount: (_listFilms.length + 1),
                      itemBuilder: (context, index) {
                        print("index $index");
                        if (index < _listFilms.length) {
                          Films _filmBuid = _listFilms[index];
                          return InkWell(
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: 50,
                                        child: Hero(
                                          tag: "Dialog${_filmBuid.imdbID}",
                                          child: Image.file(
                                            File(_filmBuid.poster),
                                            fit: BoxFit.fill,
                                            filterQuality: FilterQuality.low,
                                            height: 50,
                                          ),
                                        ),
                                      ),
                                      Wrap(
                                          direction: Axis.vertical,
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5),
                                              width: 155,
                                              child: Text(
                                                _filmBuid.title,
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                softWrap: true,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            Text(
                                                "Lançado: ${_filmBuid.released}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 14))
                                          ]),
                                      Center(
                                          child: (_filmBuid.fav == 0
                                              ? Icon(Icons.favorite_border)
                                              : Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                )))
                                    ]),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                _omdbStore.fetchFilmsByImdbId(
                                    imdbId: _filmBuid.imdbID.toString());
                                _omdbStore.setFavValue(fav: _filmBuid.fav);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FilmDetail(
                                              heroTag:
                                                  "Dialog${_filmBuid.imdbID}",
                                              film: _filmBuid,
                                              index: index,
                                            ),
                                        fullscreenDialog: true));
                              });
                        } else {
                          {
                            return FlatButton(
                                child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                      "Buscar outro filme",
                                      style: TextStyle(color: Colors.lightBlue),
                                    )),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _omdbStore.fetchFilmApi(
                                      ano: ano.toString(), filme: titulo);
                                  _omdbStore.film;
                                  _omdbStore.setFavValue(
                                      fav: _omdbStore.film.fav);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FilmDetail(
                                                heroTag: "any",
                                                film: null,
                                                index: null,
                                              ),
                                          fullscreenDialog: true));
                                });
                          }
                        }
                      });
                }
              },
            ),
          );
        });
  }
}
