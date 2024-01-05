import 'dart:convert';

class WeatherModel {
  final double cloudPct;
  final double temp;
  final double feelsLike;
  final double humidity;
  final double minTemp;
  final double maxTemp;
  final double windSpeed;
  final double sunrice;
  final double sunset;
  WeatherModel({
    required this.cloudPct,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.minTemp,
    required this.maxTemp,
    required this.windSpeed,
    required this.sunrice,
    required this.sunset,
  });

  WeatherModel copyWith({
    double? cloudPct,
    double? temp,
    double? feelsLike,
    double? humidity,
    double? minTemp,
    double? maxTemp,
    double? windSpeed,
    double? sunrice,
    double? sunset,
  }) {
    return WeatherModel(
      cloudPct: cloudPct ?? this.cloudPct,
      temp: temp ?? this.temp,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      minTemp: minTemp ?? this.minTemp,
      maxTemp: maxTemp ?? this.maxTemp,
      windSpeed: windSpeed ?? this.windSpeed,
      sunrice: sunrice ?? this.sunrice,
      sunset: sunset ?? this.sunset,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'cloudPct': cloudPct});
    result.addAll({'temp': temp});
    result.addAll({'feelsLike': feelsLike});
    result.addAll({'humidity': humidity});
    result.addAll({'minTemp': minTemp});
    result.addAll({'maxTemp': maxTemp});
    result.addAll({'windSpeed': windSpeed});
    result.addAll({'sunrice': sunrice});
    result.addAll({'sunset': sunset});
  
    return result;
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      cloudPct: map['cloudPct']?.toDouble() ?? 0.0,
      temp: map['temp']?.toDouble() ?? 0.0,
      feelsLike: map['feelsLike']?.toDouble() ?? 0.0,
      humidity: map['humidity']?.toDouble() ?? 0.0,
      minTemp: map['minTemp']?.toDouble() ?? 0.0,
      maxTemp: map['maxTemp']?.toDouble() ?? 0.0,
      windSpeed: map['windSpeed']?.toDouble() ?? 0.0,
      sunrice: map['sunrice']?.toDouble() ?? 0.0,
      sunset: map['sunset']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherModel.fromJson(String source) => WeatherModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WeatherModel(cloudPct: $cloudPct, temp: $temp, feelsLike: $feelsLike, humidity: $humidity, minTemp: $minTemp, maxTemp: $maxTemp, windSpeed: $windSpeed, sunrice: $sunrice, sunset: $sunset)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is WeatherModel &&
      other.cloudPct == cloudPct &&
      other.temp == temp &&
      other.feelsLike == feelsLike &&
      other.humidity == humidity &&
      other.minTemp == minTemp &&
      other.maxTemp == maxTemp &&
      other.windSpeed == windSpeed &&
      other.sunrice == sunrice &&
      other.sunset == sunset;
  }

  @override
  int get hashCode {
    return cloudPct.hashCode ^
      temp.hashCode ^
      feelsLike.hashCode ^
      humidity.hashCode ^
      minTemp.hashCode ^
      maxTemp.hashCode ^
      windSpeed.hashCode ^
      sunrice.hashCode ^
      sunset.hashCode;
  }
}
