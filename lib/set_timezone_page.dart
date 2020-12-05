import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'timezone_model.dart';

class SetTimezonePage extends StatelessWidget {
  final dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Timezone'),
      ),
      body: FutureBuilder(
        future: dio.get(
          'http://api.timezonedb.com/v2.1/list-time-zone',
          queryParameters: {
            'key': '0H7MVMVXW690',
            'format': 'json',
          },
        ),
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
          if (snapshot.hasData) {
            var timezoneModel = TimezoneModel.fromJson(snapshot.data.data);
            var listTimezones = timezoneModel.listTimezones;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: listTimezones.length,
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemBuilder: (context, index) {
                var itemTimezone = listTimezones[index];
                var symbol = itemTimezone.gmtOffset >= 0 ? '+' : '-';
                var hour = itemTimezone.gmtOffset ~/ 3600;
                var minute = (itemTimezone.gmtOffset % 3600) ~/ 60;
                var strHour = hour.abs().toString().padLeft(2, '0');
                var strMinute = minute.abs().toString().padLeft(2, '0');
                var strGmtOffset = 'GMT$symbol$strHour:$strMinute';
                return GestureDetector(
                  onTap: () => Navigator.pop(
                    context,
                    {
                      'timezone': itemTimezone.zoneName,
                      'gmt_offset': strGmtOffset,
                    },
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemTimezone.countryName,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text(
                        itemTimezone.zoneName,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        strGmtOffset,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
