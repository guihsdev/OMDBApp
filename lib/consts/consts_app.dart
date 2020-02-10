import 'package:flutter/material.dart';

///[ConstsApp]  Concentração de caminhos e funções de uso exclusivo.
class ConstsApp {
  static const r_G = "assets/images/rated/RATED_G.png";
  static const r_PG = "assets/images/rated/RATED_PG.png";
  static const r_PG13 = "assets/images/rated/RATED_PG-13.png";
  static const r_R = "assets/images/rated/RATED_R.png";
  static const r_NC17 = "assets/images/rated/NC-17.png";
  static const imdb_logo = "assets/images/rates/imdb.png";
  static const rt_logo = "assets/images/rates/rt.png";
  static const mc_logo = "assets/images/rates/mc.png";
  static const Color imdb_bg = Color.fromARGB(255, 245, 197, 24);
  static const Color rt_bg = Color.fromARGB(255, 250, 50, 10);
  static const Color mc_bg = Colors.black87;

  /// [getRatedIcon] Widget com a classificação indicativa do filme.
  /// [rated] Nome da empresa avaliadora.
  /// [height] (se null atribuí 15) Tamanho para o icone ser ajustado na arvore de Widgets
  static Widget getRatedIcon(String rated, {double height = 15.0}) {
    switch (rated) {
      case 'G':
        return Image.asset(
          r_G,
          height: height,
        );
        break;
      case 'PG':
        return Image.asset(
          r_PG,
          height: height,
        );
        break;
      case 'PG-13':
        return Image.asset(
          r_PG13,
          height: height,
        );
        break;
      case 'R':
        return Image.asset(
          r_R,
          height: height,
        );
        break;
      case 'NC-17':
        return Image.asset(
          r_NC17,
          height: height,
        );
        break;
      default:
        return Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black, width: 1.5, style: BorderStyle.solid)),
          child: Text(
            "NR",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: height,
                fontFamily: "Roboto Slab"),
          ),
        );
        break;
    }
  }

  /// [getRateIcon] Widget com o logo da empresa avaliadora de filmes.
  /// [rated] Nome da empresa avaliadora.
  /// [height] (se null atribuí 15) Tamanho para o icone ser ajustado na arvore de Widgets
  static Widget getRateIcon(String rated, {double height = 15.0}) {
    switch (rated) {
      case 'Internet Movie Database':
        return Image.asset(
          imdb_logo,
          height: height + 10,
        );
        break;
      case 'Rotten Tomatoes':
        return Container(
          decoration: BoxDecoration(
              color: rt_bg, borderRadius: BorderRadius.circular(3)),
          child: Image.asset(
            rt_logo,
            height: height,
          ),
        );
        break;
      case 'Metacritic':
        return Image.asset(
          mc_logo,
          height: height + 25,
        );
        break;
      default:
        return null;
        break;
    }
  }

  /// [getRateColor] Retorna a cor marcante de cada logo de avaliação.
  /// [rated] Nome da empresa avaliadora.
  static Color getRateColor(String rated) {
    switch (rated) {
      case 'Internet Movie Database':
        return imdb_bg;
        break;
      case 'Rotten Tomatoes':
        return rt_bg;
        break;
      case 'Metacritic':
        return mc_bg;
        break;
      default:
        return null;
        break;
    }
  }

  /// [getGenreColor] Atribui uma cor a cada genero.
  /// [genre] Genêro delegado
  static Color getGenreColor(String genre) {
    switch (genre) {
      case "Action":
        return Colors.blue[600];
        break;
      case "Adventure":
        return Colors.green[600];
        break;
      case "Animation":
        return Colors.teal;
        break;
      case "Biography":
        return Colors.lime[900];
        break;
      case "Comedy":
        return Colors.amber[900];
        break;
      case "Crime":
        return Colors.deepPurple;
        break;
      case "Gangster":
        return Colors.deepPurple[900];
        break;
      case "Documentary":
        return Colors.brown[300];
        break;
      case "Drama":
        return Colors.red[900];
        break;
      case "Family":
        return Colors.lightBlue[600];
        break;
      case "Fantasy":
        return Colors.cyan[900];
        break;
      case "Film-Noir":
        return Colors.blueGrey[900];
        break;
      case "History":
        return Color.fromARGB(0, 255, 215, 0);
        break;
      case "Horror":
        return Colors.green[900];
        break;
      case "Music":
        return Colors.orange[800];
        break;
      case "Musical":
        return Colors.orange[900];
        break;
      case "Mystery":
        return Colors.cyan[700];
        break;
      case "Romance":
        return Colors.red;
        break;
      case "Sci-Fi":
        return Color.fromARGB(255, 163, 163, 163);
        break;
      case "Sport":
        return Colors.green;
        break;
      case "Thriller":
        return Colors.cyan[800];
        break;
      case "War":
        return Colors.grey[800];
        break;
      case "Western":
        return Colors.brown;
        break;
      case "Reality-TV":
        return Colors.deepOrange[400];
        break;
      case "Game-Show":
        return Colors.lightBlueAccent[700];
        break;
      case "News":
        return Colors.teal[900];
        break;
      case "Talk-Show":
        return Colors.pink[900];
        break;
      default:
        return Color.fromARGB(255, 0, 0, 0);
        break;
    }
  }

  /// [getGenre] Widget que constrói o genêro combinado com a cor pré-definida.
  /// [genre] Genêro delegado
  static Widget getGenre(String genre) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: getGenreColor(genre),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 2, // has the effect of softening the shadow
              spreadRadius: 0, // has the effect of extending the shadow
              offset: Offset(
                2,
                2,
              ),
            )
          ]),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 2),
        child: Text(
          genre,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )),
    );
  }
}
