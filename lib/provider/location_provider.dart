// location_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geolocator/geolocator.dart';
import 'package:swachh_alert/services/location_services.dart';

// Provider for LocationService
final locationServiceProvider = Provider((ref) => LocationService());

// FutureProvider for getting address
final addressProvider = FutureProvider<String>((ref) async {
  final service = ref.watch(locationServiceProvider);
  final position = await service.getCurrentPosition();
  final address = await service.getAddressFromPosition(position);
  return address;
});
