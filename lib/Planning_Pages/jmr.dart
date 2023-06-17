import 'dart:async';

import 'package:assingment/Authentication/login.dart';
import 'package:assingment/Authentication/login_register.dart';
import 'package:assingment/Jmr/jmr_home.dart';
import 'package:assingment/screen/home_page.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../Authentication/auth_service.dart';

class Jmr extends StatefulWidget {
  int? finalLenOfView;
  dynamic userId;
  String? cityName;
  String? depoName;
  Jmr({super.key, this.cityName, this.depoName, this.finalLenOfView});

  @override
  State<Jmr> createState() => _JmrState();
}

class _JmrState extends State<Jmr> {
  List<int> tempList = [];
  List<List<int>> items = [
    [1],
    [1],
    [1],
    [1],
    [1]
  ];
  List<int> jmrListLength = [];
  dynamic userId;
  List<String> title = ['R1', 'R2', 'R3', 'R4', 'R5'];

  List<Widget> screens = [
    JMRPage(
      isCreateJmr: false,
    ),
    JMRPage(
      isCreateJmr: false,
    ),
    JMRPage(
      isCreateJmr: false,
    ),
    JMRPage(
      isCreateJmr: false,
    ),
    JMRPage(
      isCreateJmr: false,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Rebuild the widget when navigating back from the second page
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('${widget.cityName} / ${widget.depoName} / JMR'),
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
            GridView.builder(
                itemCount: title.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisExtent: 250,
                ),
                itemBuilder: (BuildContext context, int index) {
                  getUserId().then((value) => {
                        getDopoData(index).then((value) => {setState(() {})})
                      });
                  return cardlist(title[index], index, title[index], 'Civil');
                }),
            GridView.builder(
                itemCount: title.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisExtent: 250,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return cardlist(
                      title[index], index, title[index], 'Electrical');
                }),
          ]),
        ));
  }

  Widget cardlist(String title, int index, String title2, String Designation) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: black)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  bottom: 8.0, left: 2.0, right: 2.0, top: 6.0),
              decoration:
                  const BoxDecoration(border: Border(bottom: BorderSide())),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {},
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JMRPage(
                            title: '$Designation-$title-JM$title2',
                            title1: title,
                            cityName: widget.cityName,
                            depoName: widget.depoName,
                            isCreateJmr: false,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: blue),
                    child: const Text(
                      'Create New JMR',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items[index][0],
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('JMR${tempList[index]}'),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JMRPage(
                                    title: '$Designation-$title-JM$title2',
                                    title1: title,
                                    cityName: widget.cityName,
                                    depoName: widget.depoName,
                                    isCreateJmr: true,
                                    jmrViewLen: index + 1,
                                  ),
                                )).then((value) {
                              // Rebuild the first page when returning from the second page
                              setState(() {});
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text('View'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
        // child: ExpansionTile(
        //       leading: SizedBox(
        //         width: 48,
        //         child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.blue
        //         ),
        //         onPressed: () {  },
        //         child: Text(title,
        //         style: const TextStyle(
        //           color: Colors.white,
        //           fontSize: 11
        //         ),
        //         ),
        //       ),
        //       ),
        //       title: ElevatedButton(
        //         onPressed: (){
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => JMRPage(
        //                   title: '$Designation-$title-JM$title2',
        //                   title1: title,
        //                   cityName: widget.cityName,
        //                   depoName: widget.depoName,
        //                   isCreateJmr: false,
        //                 ),
        //               ),
        //             );
        //         },
        //         style: ElevatedButton.styleFrom(backgroundColor: blue),
        //         child:  const Text('Create New JMR',
        //           style: TextStyle(
        //             fontSize: 11
        //           ),
        //         ),
        //       ),
        //
        //       children: [
        //         _space(5),
        //         Container(
        //           padding:const EdgeInsets.all(8.0),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               children: [
        //
        //                    ElevatedButton(
        //                      style: ElevatedButton.styleFrom(
        //                          backgroundColor: Colors.blue[900]
        //                      ),
        //                      onPressed: () {  },
        //                      child: const Text('JMR 1',
        //                   style: TextStyle(
        //                     fontSize: 11,
        //                     color: Colors.white
        //                   ),
        //                      ),
        //                    ),
        //
        //                 SizedBox(
        //                 child:ElevatedButton(
        //                   style:  const ButtonStyle(
        //                     backgroundColor:  MaterialStatePropertyAll<Color>(Colors.blue),
        //                   ),
        //                   onPressed: () {
        //                     Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                         builder: (context) => JMRPage(
        //                            title: '$Designation-$title-JM$title2',
        //                           title1: title,
        //                           cityName: widget.cityName,
        //                           depoName: widget.depoName,
        //                           isCreateJmr: true,
        //                         ),
        //                       ),
        //                     );
        //                   },
        //                     child:  const Text('View',
        //                     style: TextStyle(
        //                       fontSize: 11
        //                     ),),
        //                 ),)
        //               ],
        //             ),
        //         ),
        //         _space(10),
        //       ],
        //     ),
      ),
    );
  }

  Widget _space(double i) {
    return SizedBox(
      height: i,
    );
  }
  //Function for Reading Jmr List Length For Creating Jmr List below Create New JMR

  Future<void> getDopoData(int index) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('${widget.depoName}${title[index]}')
        .doc(userId)
        .collection('JM${title[index]}');
    QuerySnapshot querySnapshot = await collectionReference.get();
    jmrListLength.add(querySnapshot.docs.length);
    items[index][0] = jmrListLength[0];
    for (int i = 1; i <= jmrListLength[0]; i++) {
      tempList.add(i);
    }
    jmrListLength.clear();
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }
}
