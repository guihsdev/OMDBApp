class ConstsApi {
  String filme, ano, plot, _apiKey = "SUA API KEY";
  ConstsApi({this.filme, this.ano, this.plot = "full"});
  String get apiUrl {
    return "http://www.omdbapi.com/?t=$filme&y=$ano&plot=$plot&apikey=$_apiKey";
  }
}
