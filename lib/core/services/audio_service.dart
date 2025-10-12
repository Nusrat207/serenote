// lib/core/services/audio_service.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  
  bool _isRecording = false;
  String? _currentRecordingPath;

  bool get isRecording => _isRecording;
  String? get currentRecordingPath => _currentRecordingPath;

  // Request microphone permission
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // Check if has permission
  Future<bool> hasPermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  // Start recording
  Future<String?> startRecording() async {
    try {
      if (!await hasPermission()) {
        final granted = await requestPermission();
        if (!granted) {
          throw Exception('Microphone permission denied');
        }
      }

      if (await _recorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final path = '${directory.path}/audio_$timestamp.m4a';
        
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path,
        );
        
        _isRecording = true;
        _currentRecordingPath = path;
        return path;
      }
      return null;
    } catch (e) {
      print('Error starting recording: $e');
      return null;
    }
  }

  // Stop recording
  Future<String?> stopRecording() async {
    try {
      final path = await _recorder.stop();
      _isRecording = false;
      return path;
    } catch (e) {
      print('Error stopping recording: $e');
      return null;
    }
  }

  // Cancel recording
  Future<void> cancelRecording() async {
    try {
      await _recorder.stop();
      _isRecording = false;
      
      // Delete the recorded file
      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
      _currentRecordingPath = null;
    } catch (e) {
      print('Error canceling recording: $e');
    }
  }

  // Play audio
  Future<void> playAudio(String path) async {
    try {
      await _player.play(DeviceFileSource(path));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  // Stop playing
  Future<void> stopPlaying() async {
    try {
      await _player.stop();
    } catch (e) {
      print('Error stopping playback: $e');
    }
  }

  // Pause playing
  Future<void> pausePlaying() async {
    try {
      await _player.pause();
    } catch (e) {
      print('Error pausing playback: $e');
    }
  }

  // Resume playing
  Future<void> resumePlaying() async {
    try {
      await _player.resume();
    } catch (e) {
      print('Error resuming playback: $e');
    }
  }

  // Get audio duration
  Future<Duration?> getAudioDuration(String path) async {
    try {
      await _player.setSourceDeviceFile(path);
      return await _player.getDuration();
    } catch (e) {
      print('Error getting duration: $e');
      return null;
    }
  }

  // Delete audio file
  Future<void> deleteAudio(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting audio: $e');
    }
  }

  // Dispose
  Future<void> dispose() async {
    await _recorder.dispose();
    await _player.dispose();
  }
}