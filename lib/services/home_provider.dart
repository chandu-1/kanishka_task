import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kanishka_task/constants.dart';
import 'package:kanishka_task/model/weather_model.dart';
import 'package:kanishka_task/services/location_services.dart';
import 'package:kanishka_task/services/shared_pref_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final homeProvider = ChangeNotifierProvider((ref) {
  final notifier = HomeNotifier(ref);
  notifier.init();
  return notifier;
});

class HomeNotifier extends ChangeNotifier {
  final Ref ref;
  HomeNotifier(this.ref);

  String accessToken = "S/CJQZYLRaqK8UYEdbNBSw==ZTjgJ3Ennf4oiBIz";

  Position get position =>
      ref.read(currentPositionProvider).value ?? Constants.defaultPosition;

  void init() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      notifyListeners();
      return;
    }
    print("latitude ${position.latitude} longitude ${position.longitude}");
    if (position.latitude == 0.0 && position.longitude == 0.0) {
      await Future.delayed(
        const Duration(seconds: 2),
      );

      final val = ref.watch(currentPositionProvider).value!;
      print("new latlong : ${val.latitude} ${val.longitude}");
      getWeatherDetailsByLatLong(val.latitude, val.longitude);
    } else {
      getWeatherDetailsByLatLong(position.latitude, position.longitude);
    }
  }

  bool _isFahrenheit = false;
  bool get isFahrenheit => _isFahrenheit;
  set isFahrenheit(bool value) {
    _isFahrenheit = value;
    notifyListeners();
  }

  double convertToFahrenheit(double celsius) {
    return celsius * 9 / 5 + 32;
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  WeatherModel? _weatherModel;
  WeatherModel? get weatherModel => _weatherModel;
  set weatherModel(WeatherModel? value) {
    _weatherModel = value;
    notifyListeners();
  }

  SharedPreferences get sharedPref => ref.read(sharedPrefProvider).value!;

  bool hasError = false;

  String getWeatherDescription(double temp) {
    if (temp < 0) {
      return 'Freezing';
    } else if (temp < 10) {
      return 'Very Cold';
    } else if (temp < 20) {
      return 'Cold';
    } else if (temp < 30) {
      return 'Warm';
    } else {
      return 'Hot';
    }
  }

  String getWeatherIcon(double temp) {
    if (temp < 0) {
      return 'snow';
    } else if (temp < 10) {
      return 'cloud';
    } else if (temp < 20) {
      return 'partly_cloudy';
    } else if (temp < 30) {
      return 'sun';
    } else {
      return 'sun';
    }
  }

  Future<void> getWeatherDetailsByLatLong(double lat, double long) async {
    loading = true;
    final res = await http.get(
      Uri.parse(
          "https://api.api-ninjas.com/v1/weather?lat=$lat&lon=$long&X-Api-Key=$accessToken"),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final resBody = jsonDecode(res.body);
    print(resBody);
    if (res.statusCode == 200) {
      weatherModel = WeatherModel.fromMap(resBody);
      hasError = false;
      weatherModel = WeatherModel.fromMap(resBody);
      sharedPref.setString(Constants.location, weatherModel!.toJson());
      loading = false;
      return;
    } else {
      loading = false;
      if (resBody["error"] != null) {
        hasError = true;
        weatherModel = null;
        return Future.error(resBody["error"]);
      }
      print("Something went wrong");
    }
    loading = false;
  }

  Future<void> getWeatherByCityName(String cityName) async {
    loading = true;
    hasError = false;
    final res = await http.get(
      Uri.parse(
          "https://api.api-ninjas.com/v1/weather?city=$cityName&X-Api-Key=$accessToken"),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final resBody = jsonDecode(res.body);
    print(resBody);
    if (res.statusCode == 200) {
      hasError = false;
      weatherModel = WeatherModel.fromMap(resBody);
      sharedPref.setString(Constants.currentCity, cityName);
      sharedPref.setString(cityName, weatherModel!.toJson());

      loading = false;
      return;
    } else {
      loading = false;
      if (resBody["error"] != null) {
        hasError = true;
        weatherModel = null;
        return Future.error(resBody["error"]);
      }

      return Future.error("Something went wrong");
    }
  }
}
