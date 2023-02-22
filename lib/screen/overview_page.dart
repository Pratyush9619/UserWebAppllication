import 'package:assingment/Planning_Pages/overview.dart';
import 'package:assingment/Planning_Pages/jmr.dart';
import 'package:assingment/overview/project_planning.dart';
import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';

import '../widget/custom_appbar.dart';

class OverviewPage extends StatefulWidget {
  String? cityName;
  String depoName;
  OverviewPage({super.key, required this.depoName, this.cityName});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  List<Widget> pages = [];
  // List<IconData> icondata = [
  //   Icons.search_off_outlined,
  //   Icons.play_lesson_rounded,
  //   Icons.chat_bubble_outline_outlined,
  //   Icons.book_online_rounded,
  //   Icons.notes,
  //   Icons.track_changes_outlined,
  //   Icons.domain_verification,
  //   Icons.list_alt_outlined,
  //   Icons.electric_bike_rounded,
  //   Icons.text_snippet_outlined,
  //   Icons.monitor_outlined,
  // ];
  List imagedata = [
    'assets/overview_image/overview.png',
    'assets/overview_image/project_planning.png',
    'assets/overview_image/resource.png',
    'assets/overview_image/monitor.png',
    'assets/overview_image/daily_progress.png',
    'assets/overview_image/detailed_engineering.png',
    'assets/overview_image/jmr.png',
    'assets/overview_image/safety.png',
    'assets/overview_image/checklist_civil.png',
    'assets/overview_image/testing_commissioning.png',
    'assets/overview_image/closure_report.png',
  ];

  List<String> desription = [
    'Overview of Project Progress Status of Shivaji Nagar EV Bus Charging Infra',
    'Project Planning & Scheduling Bus Depot Wise [Gant Chart] ',
    'Resource Allocation Planning',
    'Monthly Project Monitoring & Review',
    'Submission of Daily Progress Report for Individual Project',
    'Tracking of Individual Project Progress (SI No 2 & 6 S1 No.link)',
    'Online JMR verification for projects',
    'Safety check list & observation',
    'FQP Checklist for Civil & Electrical work',
    'Testing & Commissioning Reports of Equipment',
    'Easy monitoring of O & M schedule for all the equipment of depots.'
  ];

  @override
  Widget build(BuildContext context) {
    pages = [
      const Overview(),
      PlanningPage(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      PlanningPage(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      PlanningPage(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      PlanningPage(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      PlanningPage(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      Jmr(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      PlanningPage(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      PlanningPage(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      PlanningPage(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      PlanningPage(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
    ];
    return Scaffold(
      appBar: PreferredSize(
          child: CustomAppBar(
            text: 'Overview Page / ${widget.cityName} / ${widget.depoName}',
            haveSynced: false,
          ),
          preferredSize: Size.fromHeight(50)),
      body: GridView.count(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        children: List.generate(desription.length, (index) {
          return cards(desription[index], imagedata[index], index);
        }),
      ),
    );
  }

  Widget cards(String desc, String image, int index) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => pages[index],
              ));
        }),
        child: Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: blue),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 80,
                child: Image.asset(image, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  desc,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
