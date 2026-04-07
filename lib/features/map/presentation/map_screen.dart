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
  static const CameraPosition _lutCampusCenter = CameraPosition(
    target: LatLng(61.0656, 28.0930),
    zoom: 15,
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
          initialCameraPosition: _lutCampusCenter,
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
    name: 'LUT-yliopiston pääparkki',
    address: 'Skinnarilankatu 34, 53850 Lappeenranta',
    power: '50 kW',
    pricePerKwh: '0,32',
    position: LatLng(61.0658, 28.0929),
  ),
  _Station(
    id: '02',
    name: 'Tiedepuiston latauspiste',
    address: 'Laserkatu 6, 53850 Lappeenranta',
    power: '150 kW',
    pricePerKwh: '0,38',
    position: LatLng(61.0672, 28.0892),
  ),
  _Station(
    id: '03',
    name: 'LAB Skinnarila',
    address: 'Yliopistonkatu 36, 53850 Lappeenranta',
    power: '22 kW',
    pricePerKwh: '0,28',
    position: LatLng(61.0648, 28.0951),
  ),
  _Station(
    id: '04',
    name: 'Sammontorin Citymarket',
    address: 'Sammontori 2, 53850 Lappeenranta',
    power: '75 kW',
    pricePerKwh: '0,34',
    position: LatLng(61.0628, 28.1042),
  ),
  _Station(
    id: '05',
    name: 'Skinnarilan urheilukenttä',
    address: 'Punkkerikatu 1, 53850 Lappeenranta',
    power: '50 kW',
    pricePerKwh: '0,30',
    position: LatLng(61.0683, 28.0975),
  ),
];
