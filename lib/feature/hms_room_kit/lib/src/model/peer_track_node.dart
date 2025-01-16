//Package Imports
import 'package:felloapp/feature/hms_room_kit/lib/src/model/rtc_stats.dart';
import 'package:flutter/foundation.dart';
//Project Imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerTrackNode extends ChangeNotifier {
  HMSPeer peer;
  String uid;
  HMSVideoTrack? track;
  HMSAudioTrack? audioTrack;
  int? networkQuality;
  RTCStats? stats;
  int audioLevel;
  bool pinTile;
  bool isOffscreen = true;

  PeerTrackNode({
    required this.peer,
    required this.uid,
    this.track,
    this.audioTrack,
    this.networkQuality = -1,
    this.stats,
    this.audioLevel = -1,
    this.pinTile = false,
  });

  @override
  String toString() {
    return 'PeerTrackNode{peerId: ${peer.peerId}, name: ${peer.name}, track: $track} }';
  }

  void notify() {
    notifyListeners();
  }

  void setOffScreenStatus(bool currentState) {
    isOffscreen = currentState;
    notify();
  }

  void setAudioLevel(int audioLevel) {
    this.audioLevel = audioLevel;
    if (!isOffscreen) {
      notify();
    }
  }

  void setNetworkQuality(int? networkQuality) {
    if (networkQuality != null) {
      this.networkQuality = networkQuality;
      if (!isOffscreen) {
        notify();
      }
    }
  }

  void setHMSRemoteAudioStats(HMSRemoteAudioStats hmsRemoteAudioStats) {
    stats?.hmsRemoteAudioStats = hmsRemoteAudioStats;
    if (!isOffscreen) {
      notify();
    }
  }

  void setHMSRemoteVideoStats(HMSRemoteVideoStats hmsRemoteVideoStats) {
    stats?.hmsRemoteVideoStats = hmsRemoteVideoStats;
    if (!isOffscreen) {
      notify();
    }
  }

  void setHMSLocalVideoStats(List<HMSLocalVideoStats> hmsLocalVideoStats) {
    stats?.hmsLocalVideoStats = hmsLocalVideoStats;
    if (!isOffscreen) {
      notify();
    }
  }

  void setHMSLocalAudioStats(HMSLocalAudioStats hmsLocalAudioStats) {
    stats?.hmsLocalAudioStats = hmsLocalAudioStats;
    if (!isOffscreen) {
      notify();
    }
  }
}
