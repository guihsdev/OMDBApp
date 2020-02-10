import 'dart:io';
import 'package:flutter/material.dart';
import 'package:omdbapp/consts/consts_app.dart';

/// [FavFilms] Widget responsavel por trazer cada título favorito.
/// [index] Valor do index do clique.
/// [title] Título do filme.
/// [rated] Código com a classificação indicativa do filme.
/// [poster] Caminho do poster salvo no disco local.
/// [heroTag] Tag de vínculo do Hero, responsável por animar a transição da imagem.
class FavFilms extends StatelessWidget {
  final int index;
  final String title;
  final String rated;
  final String poster;
  final String heroTag;

  const FavFilms(
      {Key key, this.index, this.title, this.rated, this.poster, this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              )),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Hero(
              tag: heroTag,
              child: Image.file(
                File(poster),
                filterQuality: FilterQuality.medium,
                height: 150,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 6,
          child: Container(
            width: 110,
            height: 40,
            padding: EdgeInsets.only(left: 5, bottom: 5),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Text(
              "$title",
              overflow: TextOverflow.fade,
              softWrap: true,
              maxLines: 2,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
        Positioned(
          top: 06,
          left: 10,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                )),
            child: ConstsApp.getRatedIcon(rated),
          ),
        )
      ],
    );
  }
}
