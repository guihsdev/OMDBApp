import 'package:flutter/material.dart';
import 'package:omdbapp/consts/consts_app.dart';
import 'package:omdbapp/providers/omdbapi.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

/// [Rating] Widget que exibe o valor e a origem da nota.
/// [ratings] Classe de Avaliação dos filmes
class Rating extends StatelessWidget {
  final Ratings ratings;
  final BuildContext context;

  const Rating({Key key, this.ratings, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CircularPercentIndicator(
        animateFromLastPercent: false,
        animation: true,
        animationDuration: 500,
        radius: 95,
        lineWidth: 10,
        percent: ratingValue(ratings.value),
        center: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Center(
                  child: ConstsApp.getRateIcon(ratings.source, height: 20)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 60),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.5),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: Text(
                    "${ratings.value}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
        footer: Padding(
          padding: EdgeInsets.only(top: (ratings.source.length < 14 ? 18 : 0)),
          child: Container(
            width: 110,
            child: Center(
              child: Text(
                "${ratings.source}",
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    wordSpacing: -1),
              ),
            ),
          ),
        ),
        circularStrokeCap: CircularStrokeCap.butt,
        progressColor: ConstsApp.getRateColor(ratings.source), // Colors.purple,
      ),
    );
  }

  /// [ratingValue] Processa o valor das votações pela audiência
  /// [value] Valor que é processado e feito o Split filtrando os tipos de dados.
  double ratingValue(String value) {
    if (value.contains("%")) {
      return (double.parse(value.split("%")[0]) / 100);
    } else if (value.contains("/")) {
      List<String> rts = value.split("/");
      print(double.parse(rts[0]) / double.parse(rts[1]));
      return (double.parse(rts[0]) / double.parse(rts[1]));
    } else {
      return 0.0;
    }
  }
}
