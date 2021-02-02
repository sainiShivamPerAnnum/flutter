import 'dart:async';
import 'dart:isolate';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class PaymentVerificationSchedular{
  static Log log = new Log('PaymentVerificationSchedular');

  PaymentVerificationSchedular();

 BaseUtil baseProvider = locator<BaseUtil>();
  DBModel dbProvider = locator<DBModel>();
  ICICIModel iProvider = locator<ICICIModel>();
  Isolate isolate;

  void start() async {
    ReceivePort receivePort= ReceivePort(); //port for this main isolate to receive messages.
    isolate = await Isolate.spawn(dryRun, receivePort.sendPort);
    receivePort.listen((data) {
      log.debug('RECEIVE: ' + data + ', ');
      log.debug(baseProvider.myUser.uid);
      isolate.pause(isolate.pauseCapability);
      Timer(const Duration(seconds: 10), () {
        log.debug('Post 10 sec timer: ' + baseProvider.myUser.uid);
        log.debug('Restarting:');
        isolate.resume(isolate.pauseCapability);
      });
    });
  }

  static void runTimer(SendPort sendPort) {
    int counter = 0;
    Timer.periodic(new Duration(seconds: 1), (Timer t) {
      counter++;
      String msg = 'notification ' + counter.toString();
      log.debug('SEND: ' + msg + ' - ');
      sendPort.send(msg);
    });
  }

  static void dryRun(SendPort sendPort) {
    int counter = 0;
    Timer.periodic(const Duration(seconds: 4), (Timer t) {
      log.debug('Running get key:');
      sendPort.send('hello from isolation');
      //log.debug(baseProvider.myUser.uid);
      // dbProvider.getActiveSignzyApiKey().then((key) {
      //   log.debug('Signzy key:: $key, and count: $counter');
      //   counter++;
      //   sendPort.send(key);
      // });
      // String msg = 'notification ' + counter.toString();
      // log.debug('SEND: ' + msg + ' - ');
    });
  }

  void stop() {
    if (isolate != null) {
      log.debug('killing isolate');
      isolate.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }
}
