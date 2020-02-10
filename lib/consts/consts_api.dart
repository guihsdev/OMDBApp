//  "http://www.omdbapi.com/?t=avengers&y=2019&plot=full&apikey=$_apiKey";
class ConstsApi {
  String filme, ano, plot, _apiKey = "9ccffe0c";
  ConstsApi({this.filme, this.ano, this.plot = "full"});
  String get apiUrl {
    return "http://www.omdbapi.com/?t=$filme&y=$ano&plot=$plot&apikey=$_apiKey";
  }
}
