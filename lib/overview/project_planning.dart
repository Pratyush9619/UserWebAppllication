import 'package:assingment/KeysEvents/Grid_DataTable.dart';
import 'package:assingment/KeysEvents/Grid_DataTableStatutory.dart';
import 'package:assingment/KeysEvents/openpdf.dart';
import 'package:assingment/KeysEvents/site_surveys.dart';
import 'package:assingment/overview/detailed_Eng.dart';
import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../widget/custom_appbar.dart';

class PlanningPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  PlanningPage({super.key, required this.cityName, required this.depoName});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  List<Widget> menuWidget = [];
  List<String> pointname = [
    'A1',
    'A2',
    'A3',
    'A4',
    'A5',
    'A6',
    'A7',
    'A8',
    'A9',
    'A10',
    // 'A11'
  ];

  List<String> titlename = [
    'Letter Of Award Received From TML.',
    'Site Survey, Job Scope Finalization & Proposed Layout Submission',
    'Detailed Engineering For Approval Of Civil & Electrical Layout, GA Drawing From TML.',
    'Site Mobilization Activity Completed.',
    'Approval Of Statutory Clearances Of BUS Depot.',
    'Procurement Of Order Finalization Completed.',
    'Receipt Of All Materials At Site',
    'Civil Infra Development Completed At Bus Depot.',
    'Electrical Infra Development Completed At Bus Depot',
    'Bus Depot Work Completed & Handover To TML',
    // 'Statutory Matrix and  Status'
  ];
  List<String> imagedata = [
    'assets/keyevents/A1image.png',
    'assets/keyevents/A2image.jpg',
    'assets/keyevents/A3image.jpg',
    'assets/keyevents/A4image.png',
    'assets/keyevents/A5image.jpg',
    'assets/keyevents/A6image.png',
    'assets/keyevents/A7image.png',
    'assets/keyevents/A8image.jpg',
    'assets/keyevents/A9image.png',
    'assets/keyevents/A10image.png',
    // 'assets/keyevents/A10image.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    // menuWidget = [
    //   const OpenPdf(),
    //   // SiteSurveys(
    //   //     title:
    //   //         'Site Survey, Job Scope Finalization & Proposed Layout Submission'),
    //   MyHomePage(
    //     depoName: widget.depoName,
    //     keyEvents: 'A2',
    //   ),
    //   MyHomePage(
    //     depoName: widget.depoName,
    //     keyEvents: 'A3',
    //   ),
    //   // MyHomePage(
    //   //   depoName: widget.depoName,
    //   //   keyEvents: 'A4',
    //   // ),
    //   // MyHomePage(
    //   //   depoName: widget.depoName,
    //   //   keyEvents: 'A5',
    //   // ),
    //   // MyHomePage(
    //   //   depoName: widget.depoName,
    //   //   keyEvents: 'A6',
    //   // ),
    //   // MyHomePage(
    //   //   depoName: widget.depoName,
    //   //   keyEvents: 'A7',
    //   // ),
    //   // MyHomePage(
    //   //   depoName: widget.depoName,
    //   //   keyEvents: 'A8',
    //   // ),
    //   // MyHomePage(
    //   //   depoName: widget.depoName,
    //   //   keyEvents: 'A9',
    //   // ),
    //   // MyHomePage(
    //   //   depoName: widget.depoName,
    //   //   keyEvents: 'A10',
    //   // ),
    //   // SiteSurveys(
    //   //     title:
    //   //         'Detailed Engineering For Approval Of Civil & Electrical Layout, GA Drawing From TML.'),
    //   SiteSurveys(title: 'Site Mobilization Activity Completed.'),
    //   SiteSurveys(title: 'Approval Of Statutory Clearances Of BUS Depot.'),
    //   SiteSurveys(title: 'Procurement Of Order Finalization Completed.'),
    //   SiteSurveys(title: 'Receipt Of All Materials At Site'),
    //   SiteSurveys(title: 'Civil Infra Development Completed At Bus Depot.'),
    //   SiteSurveys(title: 'Electrical Infra Development Completed At Bus Depot'),
    //   SiteSurveys(title: 'Bus Depot Work Completed & Handover To TML'),
    // ];
    menuWidget = [
      OpenPdf(),
      // SiteSurveys(
      //     title:
      //         'Site Survey, Job Scope Finalization & Proposed Layout Submission'),
      MyHomePage(
        cityName: widget.cityName,
        depoName: widget.depoName,
        keyEvents: 'A1',
        keyEvents2: 'A2',
      ),
      MyHomePage(
        cityName: widget.cityName,
        depoName: widget.depoName,
        keyEvents: 'A2',
        keyEvents2: 'A3',
      ),
      // SiteSurveys(
      //     title:
      //         'Detailed Engineering For Approval Of Civil & Electrical Layout, GA Drawing From TML.'),
      MyHomePage(
        cityName: widget.cityName,
        depoName: widget.depoName,
        keyEvents: 'A3',
        keyEvents2: 'A4',
      ),

      MyHomePage2(
        cityName: widget.cityName,
        depoName: widget.depoName,
        keyEvents: 'A4',
        keyEvents2: 'A5',
      ),
      MyHomePage(
        cityName: widget.cityName,
        depoName: widget.depoName,
        keyEvents: 'A5',
        keyEvents2: 'A6',
      ),
      MyHomePage(
        cityName: widget.cityName,
        depoName: widget.depoName,
        keyEvents: 'A6',
        keyEvents2: 'A7',
      ),
      MyHomePage(
        cityName: widget.cityName,
        depoName: widget.depoName,
        keyEvents: 'A7',
        keyEvents2: 'A8',
      ),
      MyHomePage(
        cityName: widget.cityName,
        depoName: widget.depoName,
        keyEvents: 'A8',
        keyEvents2: 'A9',
      ),
      MyHomePage(
        cityName: widget.cityName,
        depoName: widget.depoName,
        keyEvents: 'A9',
        keyEvents2: 'A10',
      ),
    ];
    return Scaffold(
        appBar: PreferredSize(
            child: CustomAppBar(
              text: ' ${widget.cityName} / ${widget.depoName} / Keys Events',
              haveSynced: false,
            ),
            preferredSize: Size.fromHeight(50)),
        body: GridView.count(
          crossAxisCount: 5,
          children: List.generate(pointname.length, (index) {
            return cards(
                pointname[index], titlename[index], imagedata[index], index);
          }),
        ));
  }

  Widget cards(String point, String title, String image, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => menuWidget[index],
              ));
        }),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: blue),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 50,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: blue,
                        border: Border.all(color: blue)),
                    child: Text(
                      point,
                      style: TextStyle(fontSize: 18, color: white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Expanded(
                child: Container(
                  height: 60,
                  width: 80,
                  child: Image.asset(
                    image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
