// ════════════════════════════════════════════════════════════════════════════
// BOND PROVIDERS - Riverpod providers for the Bond (Bağ) feature
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bond.dart';
import '../services/bond_service.dart';
import '../services/touch_service.dart';
import '../services/bond_realtime_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
// SERVICE PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════

final bondServiceProvider = FutureProvider<BondService>((ref) async {
  return await BondService.init();
});

final touchServiceProvider = FutureProvider<TouchService>((ref) async {
  return await TouchService.init();
});

final bondRealtimeServiceProvider = FutureProvider<BondRealtimeService>((ref) async {
  final service = await BondRealtimeService.init();
  ref.onDispose(() => service.dispose());
  return service;
});

// ═══════════════════════════════════════════════════════════════════════════
// DATA PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════

/// Active bonds for current user
final activeBondsProvider = FutureProvider<List<Bond>>((ref) async {
  final service = await ref.watch(bondServiceProvider.future);
  return service.getActiveBonds();
});

/// Count of active bonds
final bondCountProvider = FutureProvider<int>((ref) async {
  final bonds = await ref.watch(activeBondsProvider.future);
  return bonds.length;
});

/// Count of unseen touches
final unseenTouchCountProvider = FutureProvider<int>((ref) async {
  final service = await ref.watch(touchServiceProvider.future);
  return service.getUnseenTouchCount();
});

/// Stream of incoming touches (from realtime)
final incomingTouchProvider = StreamProvider<Touch>((ref) async* {
  final service = await ref.watch(bondRealtimeServiceProvider.future);
  await for (final touch in service.onTouchReceived) {
    yield touch;
  }
});

/// Partner mood for a specific bond (family provider)
final partnerMoodProvider = FutureProvider.family<String?, String>((ref, bondId) async {
  // This would query the partner's latest mood from Supabase
  // For MVP, returns null — expanded in Phase 2 with weather_status table
  return null;
});
