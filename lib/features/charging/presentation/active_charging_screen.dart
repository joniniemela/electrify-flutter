import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';

/// Ajastin käynnissä (Active charging timer) — Figma node `174:3424`.
class ActiveChargingScreen extends ConsumerStatefulWidget {
  const ActiveChargingScreen({super.key});

  @override
  ConsumerState<ActiveChargingScreen> createState() =>
      _ActiveChargingScreenState();
}

class _ActiveChargingScreenState extends ConsumerState<ActiveChargingScreen> {
  // TODO(logic): derive from selected dial value via provider once data
  // layer exists. Hardcoded for the visual scaffold.
  static const Duration _initialDuration = Duration(minutes: 30);

  Duration _remaining = _initialDuration;
  bool _isRunning = true;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _start() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remaining.inSeconds <= 0) {
          _ticker?.cancel();
          _isRunning = false;
          return;
        }
        _remaining -= const Duration(seconds: 1);
      });
    });
  }

  void _toggle() {
    setState(() {
      _isRunning = !_isRunning;
    });
    if (_isRunning) {
      _start();
    } else {
      _ticker?.cancel();
    }
  }

  String _formatRemaining(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XrAppBar(
        title: 'Lataus käynnissä',
        leadingIcon: Icons.arrow_back,
        onLeadingTap: () => context.pop(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            _formatRemaining(_remaining),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _toggle,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer,
              ),
              child: Icon(
                _isRunning ? Icons.pause : Icons.play_arrow,
                size: 72,
                color: AppColors.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const _MetricRow(label: 'Energia', value: '12,4 kWh'),
          const _MetricRow(label: 'Hinta', value: '3,86 €'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              onPressed: () => context.go(AppRoutes.summaryFor('demo')),
              child: const Text('Lopeta lataus'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
