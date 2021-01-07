import 'package:flutter/material.dart';

import './BackgroundCollectingTask.dart';

class BackgroundCollectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BackgroundCollectingTask task =
        BackgroundCollectingTask.of(context, rebuildOnChange: true);

    final int argumentsShift =
        task.samples.first.timestamp.millisecondsSinceEpoch;

    final Duration showDuration =
    Duration(hours: 2); // @TODO . show duration should be configurable
    final Iterable<DataSample> lastSamples = task.getLastOf(showDuration);

    final Iterable<double> arguments = lastSamples.map((sample) {
      return (sample.timestamp.millisecondsSinceEpoch - argumentsShift)
          .toDouble();
    });

    return Scaffold(
        appBar: AppBar(
          title: Text('Collected data'),
          actions: <Widget>[
            // Progress circle
            (task.inProgress
                ? FittedBox(
                    child: Container(
                        margin: new EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white))))
                : Container(/* Dummy */)),
            // Start/stop buttons
            (task.inProgress
                ? IconButton(icon: Icon(Icons.pause), onPressed: task.pause)
                : IconButton(
                    icon: Icon(Icons.play_arrow), onPressed: task.resume)),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Divider(),
            ListTile(
              leading: const Icon(Icons.brightness_7),
              title: const Text('Raw Data'),
              subtitle: const Text('Raw Explore Data'),
            ),
            SingleChildScrollView(
              child: new Text("Hellooooooooooooooooooooooo"),

            ),
            /*LineChart(
              constraints: const BoxConstraints.expand(height: 350),
              arguments: arguments,
              argumentsLabels: argumentsLabels,
              values: [
                lastSamples.map((sample) => sample.temperature1),
                lastSamples.map((sample) => sample.temperature2),
              ],
              verticalLinesStyle: const PaintStyle(color: Colors.grey),
              additionalMinimalHorizontalLabelsInterval: 0,
              additionalMinimalVerticalLablesInterval: 0,
              seriesPointsStyles: [
                null,
                null,
                //const PaintStyle(style: PaintingStyle.stroke, strokeWidth: 1.7*3, color: Colors.indigo, strokeCap: StrokeCap.round),
              ],
              seriesLinesStyles: [
                const PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 1.7,
                    color: Colors.indigoAccent),
                const PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 1.7,
                    color: Colors.redAccent),
              ],
            ),*/
            Divider(),
            /*ListTile(
              leading: const Icon(Icons.filter_vintage),
              title: const Text('Water pH level'),
            ),
            LineChart(
              constraints: const BoxConstraints.expand(height: 200),
              arguments: arguments,
              argumentsLabels: argumentsLabels,
              values: [
                lastSamples.map((sample) => sample.waterpHlevel),
              ],
              verticalLinesStyle: const PaintStyle(color: Colors.grey),
              additionalMinimalHorizontalLabelsInterval: 0,
              additionalMinimalVerticalLablesInterval: 0,
              seriesPointsStyles: [
                null,
              ],
              seriesLinesStyles: [
                const PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 1.7,
                    color: Colors.greenAccent),
              ],
            ),*/
          ],
        ));
  }
}
