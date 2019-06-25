class WeatherData {
  final DateTime date;
  final String name;
  final double temp;
  final double speed;
  final double deg;
  final String main;
  final String icon;

  WeatherData({this.date, this.name, this.temp, this.speed,this.deg, this.main, this.icon});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: new DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: false),
      name: json['name'],
      temp: json['main']['temp'].toDouble(),
      speed: json['wind']['speed'].toDouble(),
      deg: json['wind']['deg'].toDouble(),
      main: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
    );
  }
}