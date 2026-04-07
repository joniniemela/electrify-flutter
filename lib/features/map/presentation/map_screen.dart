import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';

/// Karttanäkymä (Map view) — Figma node `34:1794`.
/// Includes the bottom-sheet popup variant `87:365` triggered from a marker.
///
/// TODO(logic): replace [_sampleStations] with real data from a Riverpod
/// provider once the data/ layer is introduced.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static const CameraPosition _helsinkiCenter = CameraPosition(
    target: LatLng(60.1699, 24.9384),
    zoom: 12,
  );

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XrAppBar(
        title: 'Kartta',
        leadingIcon: Icons.menu,
        onLeadingTap: () => Scaffold.of(context).openDrawer(),
        trailingIcon: Icons.search,
        onTrailingTap: () => context.go(AppRoutes.mapSearch),
      ),
      body: Builder(
        builder: (context) => GoogleMap(
          initialCameraPosition: _helsinkiCenter,
          markers: _buildMarkers(context),
          onMapCreated: (controller) {
            if (!_controller.isCompleted) {
              _controller.complete(controller);
            }
          },
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: true,
        ),
      ),
    );
  }

  Set<Marker> _buildMarkers(BuildContext context) {
    return _sampleStations
        .map(
          (station) => Marker(
            markerId: MarkerId(station.id),
            position: station.position,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            onTap: () => _showStationSheet(context, station),
          ),
        )
        .toSet();
  }

  void _showStationSheet(BuildContext context, _Station station) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              station.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(station.address),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.flash_on,
                    size: 16, color: AppColors.onSurfaceVariant),
                const SizedBox(width: 4),
                Text('${station.power} · ${station.pricePerKwh} €/kWh'),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                context.go(AppRoutes.mapLocationFor(station.id));
              },
              child: const Text('Näytä lisätiedot'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// Lightweight in-file model. Intentionally NOT moved to a `data/` or
/// `domain/` directory — CLAUDE.md requires those slots to remain clean
/// until the real data layer arrives.
class _Station {
  const _Station({
    required this.id,
    required this.name,
    required this.address,
    required this.power,
    required this.pricePerKwh,
    required this.position,
  });

  final String id;
  final String name;
  final String address;
  final String power;
  final String pricePerKwh;
  final LatLng position;
}

const List<_Station> _sampleStations = [
  _Station(
    id: '01',
    name: 'Asema Kamppi',
    address: 'Mannerheimintie 12, 00100 Helsinki',
    power: '50 kW',
    pricePerKwh: '0,32',
    position: LatLng(60.1689, 24.9316),
  ),
  _Station(
    id: '02',
    name: 'Asema Kallio',
    address: 'Hämeentie 15, 00530 Helsinki',
    power: '150 kW',
    pricePerKwh: '0,38',
    position: LatLng(60.1840, 24.9510),
  ),
  _Station(
    id: '03',
    name: 'Asema Pasila',
    address: 'Ratapihantie 13, 00520 Helsinki',
    power: '50 kW',
    pricePerKwh: '0,30',
    position: LatLng(60.1986, 24.9337),
  ),
  _Station(
    id: '04',
    name: 'Asema Ruoholahti',
    address: 'Itämerenkatu 1, 00180 Helsinki',
    power: '22 kW',
    pricePerKwh: '0,28',
    position: LatLng(60.1640, 24.9151),
  ),
  _Station(
    id: '05',
    name: 'Asema Hakaniemi',
    address: 'Hakaniemen tori 1, 00530 Helsinki',
    power: '75 kW',
    pricePerKwh: '0,34',
    position: LatLng(60.1781, 24.9505),
  ),
];
