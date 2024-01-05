import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanishka_task/constants.dart';
import 'package:kanishka_task/location_denied_page.dart';
import 'package:kanishka_task/model/weather_model.dart';
import 'package:kanishka_task/services/home_provider.dart';
import 'package:kanishka_task/services/location_services.dart';
import 'package:kanishka_task/services/shared_pref_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  void initState() {
    _requestLocationPermission();
    super.initState();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => LocationDeniedScreen(),
          ),
          (route) => false);
    } else {
      print("location not allowed");

      var serviceEnabled = await checkLocationStatus();
      if (!serviceEnabled) {
        print("location denied page");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => LocationDeniedScreen(),
          ),
          (route) => false,
        );
      }
    }
  }

  Future<bool> checkLocationStatus() async {
    var permission = await Geolocator.isLocationServiceEnabled();
    return permission;
  }

  bool showLocationDeniedPage = false;

  final cityNameController = TextEditingController();

  final ConnectivityService connectivityService = ConnectivityService();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final sharePref = ref.watch(sharedPrefProvider).value;
    final position = ref.watch(currentPositionProvider).value;
    final provider = ref.watch(homeProvider);

    // final yourLocation = ref.watch(yourLocationStateProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Weather App"),
        ),
        body: provider.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder<ConnectivityResult>(
                stream: connectivityService.connectivityStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != ConnectivityResult.none) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: cityNameController,
                              decoration: const InputDecoration(
                                  hintText: "Get Weather by City Name",
                                  border: OutlineInputBorder()),
                              onFieldSubmitted: (value) {
                                provider.getWeatherByCityName(value);
                              },
                              textInputAction: TextInputAction.search,
                            ),
                          ),

                          SizedBox(height: 20),
                          if (provider.hasError)
                            AspectRatio(
                              aspectRatio: 1,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error,
                                      size: 48,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Something went wrong ",
                                      style: style.titleLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (provider.weatherModel != null &&
                              !provider.hasError) ...[
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      "assets/${provider.getWeatherIcon(provider.weatherModel!.temp)}.png",
                                      height: 70,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Divider(),
                                    Text(
                                      provider.isFahrenheit
                                          ? '${provider.convertToFahrenheit(provider.weatherModel!.temp)}°F'
                                          : '${provider.weatherModel!.temp}°C',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    Text(
                                      ' ${provider.getWeatherDescription(provider.weatherModel!.temp)}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Celsius'),
                                        Switch(
                                          value: provider.isFahrenheit,
                                          onChanged: (value) {
                                            provider.isFahrenheit = value;
                                          },
                                        ),
                                        Text('Fahrenheit'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]
                          // ListTile(
                          //   leading: Icon(Icons.cloud),
                          //   title: Text("Temperature"),
                          //   subtitle:
                          //       Text(provider.weatherModel!.temp.toString()),
                          // ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          if (sharePref != null)
                            if ((sharePref.getString(Constants.currentCity) ??
                                    "")
                                .isEmpty)
                              AspectRatio(
                                aspectRatio: 1,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error,
                                        size: 48,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "Something went wrong ",
                                        style: style.titleLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/${provider.getWeatherIcon(provider.weatherModel!.temp)}.png",
                                        height: 70,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      const Divider(),
                                      Text(
                                        sharePref.getString(
                                                Constants.currentCity) ??
                                            "",
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        provider.isFahrenheit
                                            ? '${provider.convertToFahrenheit(WeatherModel.fromJson(sharePref.getString((sharePref.getString(Constants.currentCity) ?? sharePref.getString(Constants.location) ?? "")) ?? "").temp)}°F'
                                            : '${WeatherModel.fromJson(sharePref.getString((sharePref.getString(Constants.currentCity) ?? sharePref.getString(Constants.location) ?? "")) ?? "").temp}°C',
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      Text(
                                        ' ${provider.getWeatherDescription(WeatherModel.fromJson(sharePref.getString((sharePref.getString(Constants.currentCity) ?? sharePref.getString(Constants.location)) ?? "") ?? "").temp)}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Celsius'),
                                          Switch(
                                            value: provider.isFahrenheit,
                                            onChanged: (value) {
                                              provider.isFahrenheit = value;
                                            },
                                          ),
                                          Text('Fahrenheit'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          // ListTile(
                          //   leading: const Icon(Icons.location_city),
                          //   title: Text(sharePref
                          //           .getString(Constants.currentCity) ??
                          //       ""),
                          //   subtitle: Text(WeatherModel.fromJson(
                          //           sharePref.getString(sharePref.getString(
                          //                       Constants.currentCity) ??
                          //                   "") ??
                          //               "")
                          //       .temp
                          //       .toString()),
                          // ),
                        ],
                      ),
                    );
                  }
                }));
  }
}

class ConnectivityService {
  Stream<ConnectivityResult> get connectivityStream =>
      Connectivity().onConnectivityChanged;
}
