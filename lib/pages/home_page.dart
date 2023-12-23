import 'dart:async';

import 'package:eon_speedometer/widgets/speedometer.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GeolocatorPlatform _locator = GeolocatorPlatform.instance;

  late StreamController<double?> _velocityUpdatedStreamController;

  late double? _velocity;
  late double? _highestVelocity;

  late double? _latitude;
  late double? _longitude;

  late String? _address;

  double mpsToKmph(double mps) => mps * 18 / 5;

  @override
  void initState() {
    super.initState();

    _velocityUpdatedStreamController = StreamController<double?>();
    _locator
        .getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    )
        .listen(
      (Position position) {
        _onAccelerate(position.speed);
        _latitude = position.latitude;
        _longitude = position.longitude;
        getAddressFromCoordinates();
      },
    );

    _velocity = 0;
    _highestVelocity = 0;
    _latitude = 0;
    _longitude = 0;
    _address = '';
  }

  @override
  void dispose() {
    _velocityUpdatedStreamController.close();

    super.dispose();
  }

  void _onAccelerate(double speed) {
    _locator.getCurrentPosition().then(
      (Position updatedPosition) {
        _velocity = (speed + updatedPosition.speed) / 2;
        if (_velocity! > _highestVelocity!) _highestVelocity = _velocity;
        _velocityUpdatedStreamController.add(_velocity);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double gaugeBegin = 0;
    const double gaugeEnd = 200;

    return StreamBuilder(
      stream: _velocityUpdatedStreamController.stream,
      builder: (context, snapshot) {
        return Speedometer(
          gaugeBegin: gaugeBegin,
          gaugeEnd: gaugeEnd,
          velocityInMPS: _velocity,
          velocityInKmPH: mpsToKmph(_velocity!),
          maxVelocity: mpsToKmph(_highestVelocity!),
          address: _address,
        );
      },
    );
  }

  Future<void> getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(_latitude!, _longitude!);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          _address = "${placemark.street}, ${placemark.locality}, "
              '\n'
              " ${placemark.country}";
        });
      } else {
        setState(() {
          _address = 'No address found';
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
