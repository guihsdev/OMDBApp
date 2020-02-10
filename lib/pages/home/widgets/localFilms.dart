import 'dart:io';

import 'package:flutter/material.dart';
import 'package:omdbapp/consts/consts_app.dart';

/// [LocalFilms] Traz um Widget com Imagem, Título, Data e alguams outras características de filmes já pesquisados.
/// [fav] 0 = false | 1 = true |- Estado de se o filme é favorito ou não.
/// [title] Título do filme.
/// [rated] Código com a classificação indicativa do filme.
/// [poster] Caminho do poster salvo no disco local.
/// [release] Quando o filme foi lançado.
/// [heroTag] Tag de vínculo do Hero, responsável por animar a transição da imagem.
class LocalFilms extends StatelessWidget {
  final int index, fav;
  final String title;
  final String rated;
  final String poster;
  final String release;
  final String heroTag;

  const LocalFilms(
      {Key key,
      this.index,
      this.title,
      this.rated,
      this.release,
      this.poster,
      this.fav,
      this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          height: 150,
          width: 100,
          child: Hero(
            tag: heroTag,
            child: Image.file(
              File(poster),
              filterQuality: FilterQuality.medium,
              height: 150,
            ),
          ),
        ),
        Container(
          height: 150,
          width: MediaQuery.of(context).size.width / 1.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(fontSize: 20),
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                  )
                ],
              ),
              Wrap(
                children: <Widget>[
                  Text("Lançamento: $release", style: TextStyle(fontSize: 18))
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Classificação: ",
                    style: TextStyle(fontSize: 18),
                  ),
                  ConstsApp.getRatedIcon(rated, height: 20),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Icon(
            (fav == 0 ? Icons.favorite_border : Icons.favorite),
            color: (fav == 0 ? Colors.black87 : Colors.red),
          ),
        ),
      ],
    );
  }
}
