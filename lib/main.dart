import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sample_time_zone_flutter/set_timezone_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  final methodChannel = MethodChannel('sample_time_zone_flutter_channel');

  var eventTimeInMillis = 0;
  var strEventTime = 'No Event';
  var timezone = '';
  var strGmtOffset = '';
  tz.Location timezoneLocation;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var timezoneNative = await methodChannel.invokeMethod('get_native_time_zone');
      timezone = timezoneNative['timezone'] as String;
      timezoneLocation = tz.getLocation(timezone);
      var gmtOffset = timezoneNative['gmt_offset'] as int;
      var symbol = gmtOffset >= 0 ? '+' : '-';
      var hourGmtOffset = gmtOffset ~/ 3600;
      var minuteGmtOffset = (gmtOffset % 3600) ~/ 60;
      var strHourGmtOffset = hourGmtOffset.abs().toString().padLeft(2, '0');
      var strMinuteGmtOffset = minuteGmtOffset.abs().toString().padLeft(2, '0');
      strGmtOffset = 'GMT$symbol$strHourGmtOffset:$strMinuteGmtOffset';
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Timezone'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              strEventTime,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Center(
            child: Text(
              '$timezone ($strGmtOffset)',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text('Set Timezone'),
                onPressed: () async {
                  var resultSetTimezone = await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetTimezonePage(),
                    ),
                  );
                  if (resultSetTimezone != null) {
                    timezone = resultSetTimezone['timezone'] as String;
                    timezoneLocation = tz.getLocation(timezone);
                    strGmtOffset = resultSetTimezone['gmt_offset'] as String;
                    if (eventTimeInMillis != 0) {
                      var eventTime = tz.TZDateTime.fromMillisecondsSinceEpoch(timezoneLocation, eventTimeInMillis);
                      strEventTime = DateFormat('dd MMM yyyy HH:mm').format(eventTime);
                    }
                    setState(() {});
                  }
                },
              ),
              SizedBox(width: 16),
              RaisedButton(
                child: Text('Set Event'),
                onPressed: () async {
                  var resultSetEvent = await showTimePicker(
                    context: context,
                    initialTime: eventTimeInMillis == 0
                        ? TimeOfDay.fromDateTime(tz.TZDateTime.now(timezoneLocation))
                        : TimeOfDay.fromDateTime(
                            tz.TZDateTime.fromMillisecondsSinceEpoch(timezoneLocation, eventTimeInMillis),
                          ),
                  );
                  if (resultSetEvent != null) {
                    var now = tz.TZDateTime.now(timezoneLocation);
                    var eventTime = tz.TZDateTime(
                      timezoneLocation,
                      now.year,
                      now.month,
                      now.day,
                      resultSetEvent.hour,
                      resultSetEvent.minute,
                    );
                    eventTimeInMillis = eventTime.millisecondsSinceEpoch;
                    setState(() {
                      strEventTime = DateFormat('dd MMM yyyy HH:mm').format(eventTime);
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
