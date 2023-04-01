import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';

class ViewSummary extends StatefulWidget {
  String depoName;
  String cityName;
  ViewSummary({super.key, required this.depoName, required this.cityName});

  @override
  State<ViewSummary> createState() => _ViewSummaryState();
}

class _ViewSummaryState extends State<ViewSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(' ${widget.cityName} / ${widget.depoName} / View Summary'),
          backgroundColor: blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  width: 250,
                  height: 50,
                  child: TextFormField(
                    initialValue: 'From Date',
                  )),
              Container(
                  width: 250,
                  height: 50,
                  child: TextFormField(
                    initialValue: 'To Date',
                  )),
              Container(
                  width: 150,
                  height: 50,
                  child:
                      ElevatedButton(onPressed: () {}, child: Text('Search'))),
            ],
          ),
        ));
  }
}
