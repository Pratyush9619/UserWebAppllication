import 'package:assingment/Authentication/login.dart';
import 'package:assingment/Authentication/login_register.dart';
import 'package:assingment/Jmr/jmr_home.dart';
import 'package:assingment/screen/home_page.dart';
import 'package:assingment/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class Jmr extends StatefulWidget {
  const Jmr({super.key});

  @override
  State<Jmr> createState() => _JmrState();
}

class _JmrState extends State<Jmr> {
  List<String> title = ['R1', 'R2', 'R3', 'R4', 'R5'];
  List imglist = [
    'assets/jmr/underconstruction.jpeg',
    'assets/jmr/underconstruction2.jpeg',
    'assets/jmr/underconstruction3.jpeg',
    'assets/jmr/underconstruction4.jpeg',
    'assets/jmr/underconstruction.jpeg',
    'assets/jmr/underconstruction.jpeg',
  ];
  List<Widget> screens = [
    JMRPage(),
    JMRPage(),
    JMRPage(),
    JMRPage(),
    JMRPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Bus Depot'),
            backgroundColor: blue,
            bottom: TabBar(
              labelColor: white,
              labelStyle: buttonWhite,
              unselectedLabelColor: Colors.black,

              //indicatorSize: TabBarIndicatorSize.label,
              indicator: MaterialIndicator(
                  horizontalPadding: 24,
                  bottomLeftRadius: 8,
                  bottomRightRadius: 8,
                  color: white,
                  paintingStyle: PaintingStyle.fill),
              tabs: const [
                Tab(text: 'Civil Engineer'),
                Tab(text: 'Electrical Engineer'),
              ],
            ),
          ),
          body: TabBarView(children: [
            // ListView.builder(
            //   itemCount: title.length,
            //   itemBuilder: (context, index) {
            //     return cardlist(title[index], screens[index], index);
            //   },
            // ),
            // cardlist('title'),
            GridView.builder(
                itemCount: title.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return cardlist(title[index], screens[index], index);
                }),
            GridView.builder(
                itemCount: title.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return cardlist(title[index], screens[index], index);
                })
          ]),
        ));
  }

  Widget cardlist(String title, Widget ontap, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: black)),
        child: ExpansionTile(
          leading: const Icon(Icons.arrow_forward_ios),
          title: Text(title),
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JMRPage(
                        title: 'Civil-$title-JMR1',
                        img: imglist[index],
                      ),
                    ));
              },
              child: const Text('Create New JMR'),
              style: ElevatedButton.styleFrom(backgroundColor: blue),
            )
          ],
        ),
      ),
    );
  }

  Widget _space(double i) {
    return SizedBox(
      height: i,
    );
  }
}
