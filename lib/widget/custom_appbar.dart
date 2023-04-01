import 'package:assingment/widget/style.dart';
import 'package:assingment/widget/will_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../Authentication/login_register.dart';

class CustomAppBar extends StatelessWidget {
  final String? text;
  // final IconData? icon;
  final bool haveSynced;
  final bool haveSummary;
  final void Function()? store;
  VoidCallback? onTap;
  bool havebottom;
  bool isdetailedTab;
  TabBar? tabBar;

  CustomAppBar(
      {super.key,
      this.text,
      this.haveSynced = false,
      this.haveSummary = false,
      this.store,
      this.onTap,
      this.havebottom = false,
      this.isdetailedTab = false,
      this.tabBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: blue,
            title: Text(
              text.toString(),
            ),
            actions: [
              haveSummary
                  ? Padding(
                      padding:
                          const EdgeInsets.only(right: 40, top: 10, bottom: 10),
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),
                        child: TextButton(
                            onPressed: onTap,
                            child: Text(
                              'View Summary',
                              style: TextStyle(color: white, fontSize: 20),
                            )),
                      ),
                    )
                  : Container(),
              haveSynced
                  ? Padding(
                      padding:
                          const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),
                        child: TextButton(
                            onPressed: () {
                              store!();
                            },
                            child: Text(
                              'Sync Data',
                              style: TextStyle(color: white, fontSize: 20),
                            )),
                      ),
                    )
                  : Container(),
              Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: GestureDetector(
                      onTap: () {
                        onWillPop(context);
                      },
                      child: Image.asset(
                        'assets/logout.png',
                        height: 20,
                        width: 20,
                      ))
                  //  IconButton(
                  //   icon: Icon(
                  //     Icons.logout_rounded,
                  //     size: 25,
                  //     color: white,
                  //   ),
                  //   onPressed: () {
                  //     onWillPop(context);
                  //   },
                  // )
                  ),
            ],
            bottom: havebottom
                ? TabBar(
                    labelColor: Colors.yellow,
                    labelStyle: buttonWhite,
                    unselectedLabelColor: white,

                    //indicatorSize: TabBarIndicatorSize.label,
                    indicator: MaterialIndicator(
                      horizontalPadding: 24,
                      bottomLeftRadius: 8,
                      bottomRightRadius: 8,
                      color: almostblack,
                      paintingStyle: PaintingStyle.fill,
                    ),

                    tabs: const [
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                    ],
                  )
                : isdetailedTab
                    ? TabBar(
                        labelColor: Colors.yellow,
                        labelStyle: buttonWhite,
                        unselectedLabelColor: white,

                        //indicatorSize: TabBarIndicatorSize.label,
                        indicator: MaterialIndicator(
                          horizontalPadding: 24,
                          bottomLeftRadius: 8,
                          bottomRightRadius: 8,
                          color: almostblack,
                          paintingStyle: PaintingStyle.fill,
                        ),

                        tabs: const [
                          Tab(text: "RFC Drawings of Civil Activities"),
                          Tab(
                              text:
                                  "EV Layout Drawings of Electrical Activities"),
                          Tab(text: "Shed Lighting Drawings & Specification"),
                        ],
                      )
                    : tabBar));
  }

  Future<bool> onWillPop(BuildContext context) async {
    bool a = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Close TATA POWER?",
                      style: subtitle1White,
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              //color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "No",
                              style: button.copyWith(color: blue),
                            )),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            a = true;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginRegister(),
                                ));
                            // exit(0);
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "Yes",
                              style: button,
                            )),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ));
    return a;
  }
}
