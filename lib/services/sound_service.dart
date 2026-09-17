import 'package:audioplayers/audioplayers.dart';

/// Manages pre-buffered audio playback for UI interaction sounds.
///
/// Uses [AudioPool] to minimize latency on rapid repeated triggers
/// (e.g., fast tapping). Each sound has its own pool with up to
/// 4 concurrent players to avoid audio cutting on quick successive taps.
///
/// Must call [dispose] when the owning widget is unmounted.
class SoundService {
  static const double _volume = 0.55;

  /// Lazily initialized pool for the increment sound.
  late final Future<AudioPool> _incrementPool;

  /// Lazily initialized pool for the decrement sound.
  late final Future<AudioPool> _decrementPool;

  SoundService() {
    _incrementPool = AudioPool.create(
      source: AssetSource('sounds/increment.wav'),
      minPlayers: 1,
      maxPlayers: 4,
    );
    _decrementPool = AudioPool.create(
      source: AssetSource('sounds/decrement.wav'),
      minPlayers: 1,
      maxPlayers: 4,
    );
  }

  /// Plays the increment (higher-pitch) sound effect.
  ///
  /// Fails silently on audio errors to avoid disrupting the UI.
  Future<void> playIncrement() async {
    try {
      final pool = await _incrementPool;
      await pool.start(volume: _volume);
    } catch (_) {}
  }

  /// Plays the decrement (lower-pitch) sound effect.
  ///
  /// Fails silently on audio errors to avoid disrupting the UI.
  Future<void> playDecrement() async {
    try {
      final pool = await _decrementPool;
      await pool.start(volume: _volume);
    } catch (_) {}
  }

  /// Releases all audio resources held by this service.
  ///
  /// Must be called inside the owner's [dispose] lifecycle method.
  Future<void> dispose() async {
    try {
      await (await _incrementPool).dispose();
      await (await _decrementPool).dispose();
    } catch (_) {}
  }
}
