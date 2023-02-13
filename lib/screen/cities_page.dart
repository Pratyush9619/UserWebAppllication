import 'package:assingment/components/loading_page.dart';
import 'package:assingment/screen/depots_page.dart';
import 'package:assingment/screen/mumbai_depots.dart';
import 'package:assingment/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CitiesPage extends StatefulWidget {
  const CitiesPage({super.key});

  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  List<String> citiesname = [
    'Mumbai',
    'Delhi',
    'Bengaluru',
    'Ahmedabad',
    'Kolkata',
    'Jammu & Shrinagar',
    'Lucknow',
    'Patna',
  ];
  List imglist = [
    'assets/depots/Mumbai.jpg',
    'assets/depots/Delhi.jpg',
    'assets/depots/Bengluru.jpg',
    'assets/depots/Ahmedabad.jpg',
    'assets/depots/Kolkata.jpg',
    'assets/depots/Jammu.jpg',
    'assets/depots/Lucknow.jpg',
    'assets/depots/patna.jpg',
  ];
  List<Widget> menuWidget = [
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
    // const DepotsPage(),
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cities'),
          backgroundColor: blue,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('CityName')
              .orderBy('CityName')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DepotsPage(
                              cityName: snapshot.data!.docs[index]['CityName'],
                            ),
                          ));
                    }),
                    child: Cards(
                      snapshot.data!.docs[index]['ImageUrl'],
                      snapshot.data!.docs[index]['CityName'],
                    ),
                  );
                },
              );
            } else {
              return LoadingPage();
            }
          },
        )

        // GridView.count(
        //   crossAxisCount: 2,
        //   // childAspectRatio: 0.89,
        //   // crossAxisSpacing: 7,
        //   // mainAxisSpacing: 7,
        //   children: List.generate(citiesname.length, (index) {
        //     return Cards(citiesname[index], index);
        //   }),
        // ),
        );
  }

  Widget Cards(String img, String title) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(children: [
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: blue,
            image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 40,
          child: Container(
            // padding: const EdgeInsets.only(left: 0),
            // height: 20,
            width: 180,
            alignment: Alignment.center,
            // color: blue,
            child: Text(
              title,
              style: TextStyle(
                  color: white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        )
      ]),
      // child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //       shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(10.0)),
      //       //   minimumSize: MediaQuery.of(context).size,
      //       backgroundColor: blue,
      //     ),
      //     onPressed: () {
      //       onToScreen(index);
      //     },
      //     child: Text(title))
    );
  }

  // void onToScreen(int index) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => menuWidget[index],
  //       ));
  // }
}
