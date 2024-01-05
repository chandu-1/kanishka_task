import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanishka_task/home_page.dart';
import 'package:kanishka_task/services/location_services.dart';
import 'package:permission_handler/permission_handler.dart';

final isFromLocationDeniedState = StateProvider<bool>((ref) {
  return false;
});

class LocationDeniedScreen extends ConsumerStatefulWidget {
  const LocationDeniedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LocationDeniedScreenState();
}

class _LocationDeniedScreenState extends ConsumerState<LocationDeniedScreen>
    with WidgetsBindingObserver {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAndNavigate();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void onResume() {
    print("onResume");
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    final status = await Permission.location.status;

    var permission = await Geolocator.isLocationServiceEnabled();
    if (status.isGranted && permission) {
      ref.refresh(currentPositionProvider);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Homepage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Location Denied",
                style: style.titleLarge,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  openAppSettings();
                },
                child: Text("Open Settings"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
