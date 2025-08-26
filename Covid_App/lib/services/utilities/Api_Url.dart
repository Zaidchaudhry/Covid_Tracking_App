class UrlApi {
  //base Url
  static const String baseUrl = "https://disease.sh/v3/covid-19/";
  // design to fetch data acc to world and country
  static const String WorldStateApi = baseUrl + 'all';
  static const String CountriesApi = baseUrl + 'countries';
}