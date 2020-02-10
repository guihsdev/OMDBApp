class Films {
  String title;
  String year;
  String rated;
  String released;
  String runtime;
  String genre;
  String director;
  String writer;
  String actors;
  String plot;
  String language;
  String country;
  String awards;
  String poster;
  List<Ratings> ratings;
  String metascore;
  String imdbRating;
  String imdbVotes;
  String imdbID;
  String type;
  String dVD;
  String boxOffice;
  String production;
  String website;
  String response;
  int fav;

  Films(
      {this.title,
      this.year,
      this.rated,
      this.released,
      this.runtime,
      this.genre,
      this.director,
      this.writer,
      this.actors,
      this.plot,
      this.language,
      this.country,
      this.awards,
      this.poster,
      this.ratings,
      this.metascore,
      this.imdbRating,
      this.imdbVotes,
      this.imdbID,
      this.type,
      this.dVD,
      this.boxOffice,
      this.production,
      this.website,
      this.response,
      this.fav});

  Films.fromJson(Map<String, dynamic> json) {
    title = (json['Title'] == 'N/A' ? null : json['Title']);
    year = (json['Year'] == 'N/A' ? null : json['Year']);
    rated = (json['Rated'] == 'N/A' ? null : json['Rated']);
    released = (json['Released'] == 'N/A' ? null : json['Released']);
    runtime = (json['Runtime'] == 'N/A' ? null : json['Runtime']);
    genre = (json['Genre'] == 'N/A' ? null : json['Genre']);
    director = (json['Director'] == 'N/A' ? null : json['Director']);
    writer = (json['Writer'] == 'N/A' ? null : json['Writer']);
    actors = (json['Actors'] == 'N/A' ? null : json['Actors']);
    plot = (json['Plot'] == 'N/A' ? null : json['Plot']);
    language = (json['Language'] == 'N/A' ? null : json['Language']);
    country = (json['Country'] == 'N/A' ? null : json['Country']);
    awards = (json['Awards'] == 'N/A' ? null : json['Awards']);
    poster = (json['Poster'] == 'N/A' ? null : json['Poster']);
    if (json['Ratings'] != null) {
      ratings = List<Ratings>();
      json['Ratings'].forEach((v) {
        ratings.add(Ratings.fromJson(v, json['imdbID']));
      });
    }
    metascore = (json['Metascore'] == 'N/A' ? null : json['Metascore']);
    imdbRating = (json['imdbRating'] == 'N/A' ? null : json['imdbRating']);
    imdbVotes = (json['imdbVotes'] == 'N/A' ? null : json['imdbVotes']);
    imdbID = (json['imdbID'] == 'N/A' ? null : json['imdbID']);
    type = (json['Type'] == 'N/A' ? null : json['Type']);
    dVD = (json['DVD'] == 'N/A' ? null : json['DVD']);
    boxOffice = (json['BoxOffice'] == 'N/A' ? null : json['BoxOffice']);
    production = (json['Production'] == 'N/A' ? null : json['Production']);
    website = (json['Website'] == 'N/A' ? null : json['Website']);
    response = (json['Response'] == 'N/A' ? null : json['Response']);
    fav = json['fav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['Year'] = this.year;
    data['Rated'] = this.rated;
    data['Released'] = this.released;
    data['Runtime'] = this.runtime;
    data['Genre'] = this.genre;
    data['Director'] = this.director;
    data['Writer'] = this.writer;
    data['Actors'] = this.actors;
    data['Plot'] = this.plot;
    data['Language'] = this.language;
    data['Country'] = this.country;
    data['Awards'] = this.awards;
    data['Poster'] = this.poster;
    data['Metascore'] = this.metascore;
    data['imdbRating'] = this.imdbRating;
    data['imdbVotes'] = this.imdbVotes;
    data['imdbID'] = this.imdbID;
    data['Type'] = this.type;
    data['DVD'] = this.dVD;
    data['BoxOffice'] = this.boxOffice;
    data['Production'] = this.production;
    data['Website'] = this.website;
    data['Response'] = this.response;
    data['fav'] = this.fav;
    return data;
  }
}

class Ratings {
  String source;
  String value;
  String imdbID;

  Ratings({this.source, this.value, this.imdbID});

  Ratings.fromJson(Map<String, dynamic> json, String imdbId) {
    source = (json['Source'] == 'N/A' ? null : json['Source']);
    value = (json['Value'] == 'N/A' ? null : json['Value']);
    imdbID = imdbId;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Source'] = this.source;
    data['Value'] = this.value;
    data['imdbID'] = this.imdbID;
    return data;
  }
}
