import 'package:assingment/Authentication/auth_service.dart';
import 'package:assingment/widget/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../components/loading_page.dart';
import '../datasource/closereport_datasource.dart';
import '../model/close_report.dart';
import '../widget/style.dart';

class ClosureReport extends StatefulWidget {
  String? cityName;
  String? depoName;
  ClosureReport({super.key, this.cityName, this.depoName});

  @override
  State<ClosureReport> createState() => _ClosureReportState();
}

class _ClosureReportState extends State<ClosureReport> {
  List<CloseReportModel> closereport = <CloseReportModel>[];
  late CloseReportDataSource _closeReportDataSource;
  late DataGridController _dataGridController;
  Stream? _stream;
  var alldata;
  String? depotname, state;
  var buses;
  var longitude, latitude, loa;
  dynamic userId;
  bool _isUserId = false;
  bool _isloading = true;
  List<dynamic> tabledata2 = [];

  @override
  void initState() {
    // _fetchClosureField();
    getUserId().whenComplete(() {
      closereport = getcloseReport();
      _closeReportDataSource = CloseReportDataSource(
          closereport, context, widget.depoName!, widget.cityName!, userId);
      _dataGridController = DataGridController();
      _stream = FirebaseFirestore.instance
          .collection('ClosureProjectReport')
          .doc('${widget.depoName}')
          .collection('ClosureReport')
          .doc(userId)
          .snapshots();

      _isloading = false;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            // ignore: sort_child_properties_last
            child: CustomAppBar(
              text: ' ${widget.cityName}/ ${widget.depoName} / Closure Report',
              haveSynced: true,
              store: () {
                FirebaseFirestore.instance
                    .collection('ClosureReport')
                    .doc('${widget.depoName}')
                    .collection("ClosureData")
                    .doc(userId)
                    .set(
                  {
                    'DepotName': depotname ?? 'Enter Depot Name',
                    'Longitude': longitude ?? 'Enter Longitude',
                    'Latitude': latitude ?? 'Enter Latitude',
                    'State': state ?? 'Enter State',
                    'Buses': buses ?? 'Enter Buse',
                    'LaoNo': loa ?? 'Enter LOA No.',
                  },
                );

                store();
              },
            ),
            preferredSize: const Size.fromHeight(50)),
        body: _isloading ? LoadingPage() : upperScreen());
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  upperScreen() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('ClosureReport')
          .doc('${widget.depoName}')
          .collection("ClosureData")
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                height: 80,
                decoration: BoxDecoration(color: lightblue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/Tata-Power.jpeg',
                            height: 50, width: 100),
                        const Text('TATA POWER'),
                      ],
                    ),
                    const Text(
                      '',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const Text('TPCL /DIST/EV/CHECKLIST ')
                  ],
                ),
              ),
              Container(
                  decoration: BoxDecoration(color: lightblue),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            color: lightblue,
                            width: 625,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text('Depot Name', style: formtext)),
                                SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              hintText: 'Depot Name',
                                              contentPadding: EdgeInsets.only(
                                                  top: 0, bottom: 0, left: 5)),
                                          initialValue: snapshot.data!
                                                  .data()
                                                  .toString()
                                                  .contains('DepotName')
                                              ? snapshot.data!
                                                      .get('DepotName') ??
                                                  ''
                                              : '',
                                          style: formtext,
                                          onChanged: (value) {
                                            depotname = value;
                                          },
                                          onSaved: (newValue) {
                                            // empName = newValue.toString();
                                          },
                                        ))),
                              ],
                            ),
                          ),
                          Container(
                            color: lightblue,
                            width: 625,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                      'Longitude',
                                      style: formtext,
                                    )),
                                SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              hintText: 'Longitude',
                                              contentPadding: EdgeInsets.only(
                                                  top: 0, bottom: 0, left: 5)),
                                          initialValue: snapshot.data!
                                                  .data()
                                                  .toString()
                                                  .contains('Longitude')
                                              ? snapshot.data!
                                                      .get('Longitude') ??
                                                  ''
                                              : '',
                                          style: formtext,
                                          onChanged: (value) {
                                            longitude = value;
                                          },
                                          onSaved: (newValue) {
                                            // distev = newValue.toString();
                                          },
                                        ))),
                              ],
                            ),
                          ),
                          Container(
                            color: lightblue,
                            width: 625,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text('Latitude', style: formtext)),
                                SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              hintText: 'Latitude',
                                              contentPadding: EdgeInsets.only(
                                                  top: 0, bottom: 0, left: 5)),
                                          initialValue: snapshot.data!
                                                  .data()
                                                  .toString()
                                                  .contains('Latitude')
                                              ? snapshot.data!
                                                      .get('Latitude') ??
                                                  ''
                                              : '',
                                          style: formtext,
                                          onChanged: (value) {
                                            latitude = value;
                                          },
                                          onSaved: (newValue) {
                                            // vendorname =
                                            //     newValue.toString();
                                          },
                                        ))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            color: lightblue,
                            width: 625,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                      ' State',
                                      style: formtext,
                                    )),
                                SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              hintText: 'State',
                                              contentPadding: EdgeInsets.only(
                                                  top: 0, bottom: 0, left: 5)),
                                          initialValue: snapshot.data!
                                                  .data()
                                                  .toString()
                                                  .contains('State')
                                              ? snapshot.data!.get('State') ??
                                                  ''
                                              : '',
                                          style: formtext,
                                          onChanged: (value) {
                                            state = value;
                                          },
                                          onSaved: (newValue) {
                                            // olano = newValue.toString();
                                          },
                                        ))),
                              ],
                            ),
                          ),
                          Container(
                            color: lightblue,
                            width: 625,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                      ' No. Of Buses',
                                      style: formtext,
                                    )),
                                SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              hintText: 'Buses',
                                              contentPadding: EdgeInsets.only(
                                                  top: 0, bottom: 0, left: 5)),
                                          initialValue: snapshot.data!
                                                  .data()
                                                  .toString()
                                                  .contains('Buses')
                                              ? snapshot.data!.get('Buses') ??
                                                  ''
                                              : '',
                                          style: formtext,
                                          onChanged: (value) {
                                            buses = value.toString();
                                          },
                                          onSaved: (newValue) {
                                            // panel = newValue.toString();
                                          },
                                        ))),
                              ],
                            ),
                          ),
                          Container(
                            color: lightblue,
                            width: 625,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                      ' LOA No.',
                                      style: formtext,
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              hintText: 'LOA No',
                                              contentPadding: EdgeInsets.only(
                                                  top: 0, bottom: 0, left: 5)),
                                          initialValue: snapshot.data!
                                                  .data()
                                                  .toString()
                                                  .contains('LaoNo')
                                              ? snapshot.data!.get('LaoNo') ??
                                                  ''
                                              : '',
                                          style: formtext,
                                          onChanged: (value) {
                                            loa = value;
                                          },
                                          onSaved: (newValue) {
                                            // depotname =
                                            //     newValue.toString();
                                          },
                                        ))),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
              Expanded(
                child: StreamBuilder(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingPage();
                    }
                    if (!snapshot.hasData || snapshot.data.exists == false) {
                      return SfDataGridTheme(
                        data: SfDataGridThemeData(headerColor: blue),
                        child: SfDataGrid(
                          source: _closeReportDataSource,
                          //key: key,
                          allowEditing: true,
                          frozenColumnsCount: 2,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.cell,
                          columnWidthMode: ColumnWidthMode.auto,
                          editingGestureType: EditingGestureType.tap,
                          controller: _dataGridController,

                          columns: [
                            GridColumn(
                              columnName: 'srNo',
                              width: 80,
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Sr No',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Content',
                              width: 700,
                              allowEditing: false,
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text(
                                    'List of Content for ${widget.depoName}  Infrastructure',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: white,
                                    )),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Upload',
                              allowEditing: false,
                              visible: true,
                              width: 250,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Upload',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'View',
                              allowEditing: false,
                              width: 250,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('View',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)),
                              ),
                            ),
                          ],

                          stackedHeaderRows: [
                            StackedHeaderRow(cells: [
                              StackedHeaderCell(
                                  columnNames: ['Upload', 'View'],
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Attachment Details',
                                      style:
                                          TextStyle(color: white, fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                            ])
                          ],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      // alldata = '';
                      // alldata = snapshot.data['data'] as List<dynamic>;
                      // qualitylisttable1.clear();
                      alldata.forEach((element) {});
                      return SfDataGridTheme(
                        data: SfDataGridThemeData(headerColor: blue),
                        child: SfDataGrid(
                          source: _closeReportDataSource,
                          //key: key,
                          allowEditing: true,
                          frozenColumnsCount: 2,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.cell,
                          columnWidthMode: ColumnWidthMode.auto,
                          editingGestureType: EditingGestureType.tap,
                          controller: _dataGridController,

                          columns: [
                            GridColumn(
                              columnName: 'srNo',
                              width: 80,
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Sr No',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Content',
                              width: 450,
                              allowEditing: false,
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text(
                                    'List of Content for ${widget.depoName}  Infrastructure',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: white,
                                    )),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Upload',
                              allowEditing: false,
                              visible: true,
                              width: 150,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Upload',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'View',
                              allowEditing: false,
                              width: 150,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('View',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)),
                              ),
                            ),
                          ],

                          stackedHeaderRows: [
                            StackedHeaderRow(cells: [
                              StackedHeaderCell(
                                  columnNames: ['Upload', 'View'],
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Attachment Details',
                                      style:
                                          TextStyle(color: white, fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                            ])
                          ],
                        ),
                      );
                    } else {
                      // here w3e have to put Nodata page
                      return LoadingPage();
                    }
                  },
                ),
              ),
              //  Padding(
              //         padding: const EdgeInsets.all(10.0),
              //         child: Align(
              //           alignment: Alignment.bottomRight,
              //           child: FloatingActionButton(
              //             child: Icon(Icons.add),
              //             onPressed: (() {
              //               if (_selectedIndex == 0) {
              //                 qualitylisttable1.add(
              //                   QualitychecklistModel(
              //                     srNo: 1,
              //                     checklist: 'checklist',
              //                     responsibility: 'responsibility',
              //                     reference: 'reference',
              //                     observation: 'observation',
              //                     // photoNo: 12345,
              //                   ),
              //                 );
              //                 _qualityPSSDataSource.buildDataGridRows();
              //                 _qualityPSSDataSource.updateDatagridSource();
              //               } else if (_selectedIndex == 1) {
              //                 qualitylisttable1.add(
              //                   QualitychecklistModel(
              //                     srNo: 1,
              //                     checklist: 'checklist',
              //                     responsibility: 'responsibility',
              //                     reference: 'reference',
              //                     observation: 'observation',
              //                     // photoNo: 12345,
              //                   ),
              //                 );
              //                 _qualityrmuDataSource.buildDataGridRows();
              //                 _qualityrmuDataSource.updateDatagridSource();
              //               } else if (_selectedIndex == 2) {
              //                 qualitylisttable1.add(
              //                   QualitychecklistModel(
              //                     srNo: 1,
              //                     checklist: 'checklist',
              //                     responsibility: 'responsibility',
              //                     reference: 'reference',
              //                     observation: 'observation',
              //                     // photoNo: 12345,
              //                   ),
              //                 );
              //                 _qualityctDataSource.buildDataGridRows();
              //                 _qualityctDataSource.updateDatagridSource();
              //               } else if (_selectedIndex == 3) {
              //                 qualitylisttable1.add(
              //                   QualitychecklistModel(
              //                     srNo: 1,
              //                     checklist: 'checklist',
              //                     responsibility: 'responsibility',
              //                     reference: 'reference',
              //                     observation: 'observation',
              //                     // photoNo: 12345,
              //                   ),
              //                 );
              //                 _qualitycmuDataSource.buildDataGridRows();
              //                 _qualitycmuDataSource.updateDatagridSource();
              //               } else if (_selectedIndex == 4) {
              //                 qualitylisttable1.add(
              //                   QualitychecklistModel(
              //                     srNo: 1,
              //                     checklist: 'checklist',
              //                     responsibility: 'responsibility',
              //                     reference: 'reference',
              //                     observation: 'observation',
              //                     // photoNo: 12345,
              //                   ),
              //                 );
              //                 _qualityacdDataSource.buildDataGridRows();
              //                 _qualityacdDataSource.updateDatagridSource();
              //               } else if (_selectedIndex == 5) {
              //                 qualitylisttable1.add(
              //                   QualitychecklistModel(
              //                     srNo: 1,
              //                     checklist: 'checklist',
              //                     responsibility: 'responsibility',
              //                     reference: 'reference',
              //                     observation: 'observation',
              //                     // photoNo: 12345,
              //                   ),
              //                 );
              //                 _qualityCIDataSource.buildDataGridRows();
              //                 _qualityCIDataSource.updateDatagridSource();
              //               } else if (_selectedIndex == 6) {
              //                 qualitylisttable1.add(
              //                   QualitychecklistModel(
              //                     srNo: 1,
              //                     checklist: 'checklist',
              //                     responsibility: 'responsibility',
              //                     reference: 'reference',
              //                     observation: 'observation',
              //                     // photoNo: 12345,
              //                   ),
              //                 );
              //                 _qualityCDIDataSource.buildDataGridRows();
              //                 _qualityCDIDataSource.updateDatagridSource();
              //               } else if (_selectedIndex == 7) {
              //                 qualitylisttable1.add(
              //                   QualitychecklistModel(
              //                     srNo: 1,
              //                     checklist: 'checklist',
              //                     responsibility: 'responsibility',
              //                     reference: 'reference',
              //                     observation: 'observation',
              //                     // photoNo: 12345,
              //                   ),
              //                 );
              //                 _qualityMSPDataSource.buildDataGridRows();
              //                 _qualityMSPDataSource.updateDatagridSource();
              //               } else if (_selectedIndex == 8) {
              //                 qualitylisttable1.add(
              //                   QualitychecklistModel(
              //                     srNo: 1,
              //                     checklist: 'checklist',
              //                     responsibility: 'responsibility',
              //                     reference: 'reference',
              //                     observation: 'observation',
              //                     // photoNo: 12345,
              //                   ),
              //                 );
              //                 _qualityChargerDataSource.buildDataGridRows();
              //                 _qualityChargerDataSource.updateDatagridSource();
              //               } else if (_selectedIndex == 9) {
              //                 qualitylisttable1.add(
              //                   QualitychecklistModel(
              //                     srNo: 1,
              //                     checklist: 'checklist',
              //                     responsibility: 'responsibility',
              //                     reference: 'reference',
              //                     observation: 'observation',
              //                     // photoNo: 12345,
              //                   ),
              //                 );
              //                 _qualityEPDataSource.buildDataGridRows();
              //                 _qualityEPDataSource.updateDatagridSource();
              //               }
              //             }),
              //           ),
              //         ),
              //       )
            ],
          );
        } else {
          return LoadingPage();
        }
      },
    );
  }

  // void _fetchClosureField() async {
  //   await FirebaseFirestore.instance
  //       .collection('ClosureReport')
  //       .doc('${widget.depoName}')
  //       .collection("ClosureData")
  //       .doc(userId)
  //       .get()
  //       .then((ds) {
  //     setState(() {
  //       depotname = ds.data()!['DepotName'];
  //       longitude = ds.data()!['Longitude'];
  //       latitude = ds.data()!['Latitude'];
  //       state = ds.data()!['State'];
  //       buses = ds.data()!['Buses'];
  //       loa = ds.data()!['LaoNo'];
  //     });
  //   });
  // }

  List<CloseReportModel> getcloseReport() {
    return [
      CloseReportModel(
        siNo: 1,
        content: 'Introduction of Project',
      ),
      CloseReportModel(
        siNo: 1.1,
        content: 'RFP for DTC Bus Project ',
      ),
      CloseReportModel(
        siNo: 1.2,
        content: 'Project Purchase Order or LOI or LOA ',
      ),
      CloseReportModel(
        siNo: 1.3,
        content: 'Project Governance Structure',
      ),
      CloseReportModel(
        siNo: 1.4,
        content: 'Site Location Details',
      ),
      CloseReportModel(
        siNo: 1.5,
        content: 'Final  Site Survey Report.',
      ),
      CloseReportModel(
        siNo: 1.6,
        content: 'BOQ (Bill of Quantity)',
      ),
    ];
  }

  void store() {
    Map<String, dynamic> table_data = Map();
    for (var i in _closeReportDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'Photo' && data.columnName != 'ViewPhoto') {
          table_data[data.columnName] = data.value;
        }
      }

      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('ClosureReportTable')
        .doc(widget.depoName!)
        .collection('Closure Report')
        .doc(userId)
        // .collection(userId)
        // .doc(DateFormat.yMMMMd().format(DateTime.now()))
        .set(
      {'data': tabledata2},
      SetOptions(merge: true),
    ).whenComplete(() {
      tabledata2.clear();
      // Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }
}
