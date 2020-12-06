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
          'https://api.timezonedb.com/v2.1/list-time-zone',
          queryParameters: {
            'key': '0H7MVMVXW690',
            'format': 'json',
          },
        ),
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
          if (snapshot.hasData) {
            return WidgetContentTimezone(snapshot.data);
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

class WidgetContentTimezone extends StatefulWidget {
  final Response data;

  WidgetContentTimezone(this.data);

  @override
  _WidgetContentTimezoneState createState() => _WidgetContentTimezoneState();
}

class _WidgetContentTimezoneState extends State<WidgetContentTimezone> {
  TimezoneModel timezoneModel;
  var listTimezones = <ItemTimezone>[];
  var listResult = <ItemTimezone>[];

  @override
  void initState() {
    timezoneModel = TimezoneModel.fromJson(widget.data.data);
    listTimezones = timezoneModel.listTimezones;
    listResult.addAll(listTimezones);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 16,
            right: 16,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              listResult.clear();
              if (value.isEmpty) {
                listResult.addAll(listTimezones);
              } else {
                var result = listTimezones.where((element) {
                  return element.countryName.toLowerCase().contains(value.toLowerCase());
                });
                listResult.addAll(result);
              }
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: listResult.length,
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (context, index) {
              var itemTimezone = listResult[index];
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
          ),
        ),
      ],
    );
  }
}
