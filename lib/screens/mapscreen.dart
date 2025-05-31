import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  final LatLng _center = const LatLng(45.7489, 21.2087); // Timisoara

  // Define the bounds for Timiș county (adjust as needed)
  final LatLngBounds _timisBounds = LatLngBounds(
    southwest: LatLng(45.4, 20.5), // bottom-left
    northeast: LatLng(46.1, 21.6), // top-right
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    double lat = position.target.latitude;
    double lng = position.target.longitude;

    // If out of bounds, move incrementally back toward the bounds
    if (!_timisBounds.contains(position.target)) {
      if (lat < _timisBounds.southwest.latitude) {
        lat = min(lat + 0.04, _timisBounds.southwest.latitude.ceilToDouble() + 3.0);
      } else if (lat > _timisBounds.northeast.latitude) {
        lat = max(lat - 0.04, _timisBounds.northeast.latitude.floorToDouble() - 3.0);
      }

      if (lng < _timisBounds.southwest.longitude) {
        lng = min(lng + 0.06, _timisBounds.southwest.longitude.ceilToDouble() + 2.0);
      } else if (lng > _timisBounds.northeast.longitude) {
        lng = max(lng - 0.06, _timisBounds.northeast.longitude.floorToDouble() - 2.0);
      }

      mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(lat, lng)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 12.0,
        ),
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        minMaxZoomPreference: const MinMaxZoomPreference(12.0, 19.0),
        onCameraMove: _onCameraMove,
      ),
    );
  }
}