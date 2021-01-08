import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert' show utf8;
import 'dart:typed_data';

class DataSample {
  String textData;
  DateTime timestamp;

  DataSample({
    this.textData,
    this.timestamp,
  });
}

class BackgroundCollectingTask extends Model {
  static BackgroundCollectingTask of(
    BuildContext context, {
    bool rebuildOnChange = false,
  }) =>
      ScopedModel.of<BackgroundCollectingTask>(
        context,
        rebuildOnChange: rebuildOnChange,
      );

  final BluetoothConnection _connection;
  List<int> _buffer = List<int>();

  // @TODO , Such sample collection in real code should be delegated

  // @TODO ? should be shrinked at some point, endless colleting data would cause memory shortage.
  List<DataSample> samples = List<DataSample>();

  bool inProgress;

  BackgroundCollectingTask._fromConnection(this._connection) {
    _connection.input.listen((data) {

      //final decoded = utf8.decode(data);
      final byteBuffer = data.buffer;
      var length = data.lengthInBytes;
      var offset = data.offsetInBytes;
      //print(byteBuffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      print("Byte buffer length is $length with offset of $offset");

      //TODO adding parsed data to the sample class
      _buffer += data;
      int bufferSize = _buffer.length;
      print("Buffer size is $bufferSize");

      final DataSample sample = DataSample(textData: "Dummy Data", timestamp: DateTime.now());

      samples.add(sample);
      notifyListeners(); // Note: It shouldn't be invoked very often - in this example data comes at every second, but if there would be more data, it should update (including repaint of graphs) in some fixed interval instead of after every sample.
      print("going out..");
        // Otherwise break
      }
    //}
    ).onDone(() {
      inProgress = false;
      notifyListeners();
    });
  }

  static Future<BackgroundCollectingTask> connect(
      BluetoothDevice server) async {

    try{
      final BluetoothConnection connection = await BluetoothConnection.toAddress(server.address);
      debugPrint("Successful connection to Explore");
      return BackgroundCollectingTask._fromConnection(connection);
    }
    catch(error) {
      debugPrint("error occurred while trying to connect");
    }
  }

  void dispose() {
    _connection.dispose();
  }

  Future<void> start() async {
    inProgress = true;
    _buffer.clear();
    samples.clear();
    notifyListeners();
    debugPrint("Listeners notified and after successful connection");
    /*_connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;*/
  }

  Future<void> cancel() async {
    inProgress = false;
    notifyListeners();
    /*_connection.output.add(ascii.encode('stop'));
    await _connection.finish();*/
  }

  Future<void> pause() async {
    inProgress = false;
    notifyListeners();
    /*_connection.output.add(ascii.encode('stop'));
    await _connection.output.allSent;*/
  }

  Future<void> resume() async {
    inProgress = true;
    notifyListeners();
    /*_connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;*/
  }

  Iterable<DataSample> getLastOf(Duration duration) {
    DateTime startingTime = DateTime.now().subtract(duration);
    int i = samples.length;
    do {
      i -= 1;
      if (i <= 0) {
        break;
      }
    } while (samples[i].timestamp.isAfter(startingTime));
    return samples.getRange(i, samples.length);
  }
}
