import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:omdbapp/consts/consts_app.dart';
import 'package:omdbapp/pages/film_detail/widgets/rating.dart';
import 'package:omdbapp/stores/omdb_store.dart';
import 'package:provider/provider.dart';
import 'package:omdbapp/providers/omdbapi.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class FilmDetail extends StatelessWidget {
  final int index;
  final Films film;
  final String heroTag;

  const FilmDetail({Key key, this.index, this.film, this.heroTag})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    OmdbStore _omdbStore;
    Films _film;
    if (index == null) {
      _omdbStore = Provider.of<OmdbStore>(context);
      _film = _omdbStore.film;
    } else {
      if (film != null) {
        _omdbStore = Provider.of<OmdbStore>(context);
        _film = _omdbStore.imdbFilm;
      }
    }
    AppBar _failAppBar = AppBar(
      elevation: 0,
      title: Opacity(
        opacity: 1,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          _omdbStore.fetchFavsFilms();
          _omdbStore.fetchLocalFilms();
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(Icons.favorite_border),
        )
      ],
    );

// Capturo eventos do BackButton nativo do Sistema
    return WillPopScope(
      onWillPop: () {
        // Solicito que recarregue o Storage onde amazeno os filmes favoritos e filmes já pesquisados.
        _omdbStore.fetchFavsFilms();
        _omdbStore.fetchLocalFilms();
        Navigator.pop(context);
        return Future(() => false);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Observer(
            name: 'FilmDetailAppBar',
            builder: (context) {
              if (index != null) {
                _film = _omdbStore.imdbFilm;
              } else {
                _film = _omdbStore.film;
              }
              if (_film == null) {
                return _failAppBar;
              } else if (_film.response == 'False') {
                return _failAppBar;
              } else {
                return AppBar(
                  elevation: 0,
                  title: Opacity(
                    opacity: 1,
                    child: Text(
                      _film.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      _omdbStore.fetchFavsFilms();
                      _omdbStore.fetchLocalFilms();
                      Navigator.pop(context);
                    },
                  ),
                  actions: <Widget>[
                    Observer(builder: (context) {
                      return IconButton(
                        icon: (_omdbStore.favValue == 0
                            ? Icon(
                                Icons.favorite_border,
                              )
                            : Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )),
                        onPressed: () {
                          if (_omdbStore.favValue == 0) {
                            _omdbStore.setFavFilm(fav: 1, imdbID: _film.imdbID);
                          } else {
                            _omdbStore.setFavFilm(fav: 0, imdbID: _film.imdbID);
                          }
                        },
                      );
                    })
                  ],
                );
              }
            },
          ),
        ),
        body: Observer(
            name: 'FilmDetailBody',
            builder: (_) {
              if (index != null) {
                _film = _omdbStore.imdbFilm;
              } else {
                _film = _omdbStore.film;
              }
              if (_film == null) {
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              } else if (_film.response == "False") {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.red[200],
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 300),
                    child: Center(
                      child: Text(
                        "Ops!\nAlgo deu errado.\nTente novamente!",
                        maxLines: 5,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 38,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                _film = _film;
                return Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.black12,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 66),
                        child: Center(
                          child: Hero(
                            tag: heroTag,
                            child: Image.file(
                              File(_film.poster),
                              fit: BoxFit.cover,
                              scale: 0.1,
                              filterQuality: FilterQuality.high,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                    ),
                    SlidingSheet(
                      elevation: 5,
                      cornerRadius: 16,
                      snapSpec: SnapSpec(
                          snap: true,
                          snappings: [0.15, 0.2, 0.7, 0.9],
                          positioning:
                              SnapPositioning.relativeToAvailableSpace),
                      builder: (context, state) {
                        return Container(
                          height: MediaQuery.of(context).size.height - 130,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.indigo[50],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, left: 10),
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: InkWell(
                                    child: Text(
                                      "${_film.plot}",
                                      maxLines: 3,
                                      overflow: TextOverflow.fade,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Noto Sans',
                                      ),
                                    ),
                                    onTap: () {
                                      _showDialog(
                                          context,
                                          Container(
                                            child: Text("Mais informações"),
                                          ),
                                          SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                (_film.plot != null
                                                    ? Text(
                                                        "Enredo: ${_film.plot}",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      )
                                                    : Container()),
                                                (_film.actors != null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        child: Text(
                                                          "Atores(Atrizes): ${_film.actors}",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      )
                                                    : Container()),
                                                (_film.director != null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        child: Text(
                                                          "Diretor(a): ${_film.director}",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      )
                                                    : Container()),
                                                (_film.writer != null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        child: Text(
                                                          "Escritor(a): ${_film.writer}",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      )
                                                    : Container()),
                                                (_film.awards != null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        child: Text(
                                                          "Nomeações: ${_film.awards}",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      )
                                                    : Container()),
                                                FlatButton(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          "Ver IMDB do filme",
                                                          style: TextStyle(
                                                              color: Colors
                                                                      .lightBlue[
                                                                  600]),
                                                        ),
                                                        Icon(
                                                          Icons.open_in_new,
                                                          color: Colors
                                                              .lightBlue[600],
                                                        )
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      _launchURL(
                                                          'https://www.imdb.com/title/${_film.imdbID}/');
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                              ],
                                            ),
                                          ));
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Classificação indicativa:",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: ConstsApp.getRatedIcon(_film.rated,
                                          height: 18),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Lançado em: ${_film.released}",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                              ),
                              (_film.ratings.length == 0
                                  ? Container()
                                  : Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Observer(
                                            name: 'Ratings',
                                            builder: (context) {
                                              if (index != null) {
                                                _film = _omdbStore.imdbFilm;
                                              } else {
                                                _film = _omdbStore.film;
                                              }
                                              return ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      _film.ratings.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return AnimationLimiter(
                                                      child:
                                                          AnimationConfiguration
                                                              .staggeredList(
                                                        position: index,
                                                        duration: Duration(
                                                            milliseconds: 400),
                                                        child: ScaleAnimation(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 2,
                                                                    right: 2),
                                                            child: Rating(
                                                              context: context,
                                                              ratings:
                                                                  _film.ratings[
                                                                      index],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            }),
                                      ),
                                    )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Duração: ${_film.runtime}",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 25,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Observer(
                                      name: 'Genre',
                                      builder: (context) {
                                        if (index != null) {
                                          _film = _omdbStore.imdbFilm;
                                        } else {
                                          _film = _omdbStore.film;
                                        }
                                        List<String> _listGenre =
                                            _film.genre.toString().split(",");
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _listGenre.length,
                                            itemBuilder: (context, index) {
                                              return AnimationLimiter(
                                                child: AnimationConfiguration
                                                    .staggeredList(
                                                  position: index,
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  child: ScaleAnimation(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: (index == 0
                                                              ? 2
                                                              : 10),
                                                          right: 2),
                                                      child: ConstsApp.getGenre(
                                                          _listGenre[index]
                                                              .trim()),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      }),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  /// [_showDialog] Dialogo com infomações adicionais sobre o Filme.
  /// [context] Contexto do ambiente.
  /// [title] Widget posicionado no título do Dialog, permitindo construir da melhor maneira para cada ação.
  /// [content] Widget posicionado no centro (foco) do Dialog, permitindo construir da melhor maneira para cada ação.
  void _showDialog(context, Widget title, Widget content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              title,
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
          content: content,
        );
      },
    );
  }

  /// [_launchURL] Dispara a URL e invoca os Intents nativos
  /// [url] A URL destino
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossivel abrir $url';
    }
  }
}
