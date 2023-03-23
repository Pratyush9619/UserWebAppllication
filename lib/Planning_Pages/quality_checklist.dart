import 'package:assingment/QualityDatasource/quality_acdb.dart';
import 'package:assingment/QualityDatasource/quality_cdi.dart';
import 'package:assingment/QualityDatasource/quality_charger.dart';
import 'package:assingment/QualityDatasource/quality_ci.dart';
import 'package:assingment/QualityDatasource/quality_cmu.dart';
import 'package:assingment/QualityDatasource/quality_msp.dart';
import 'package:assingment/QualityDatasource/quality_rmu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../KeysEvents/Grid_DataTable.dart';
import '../QualityDatasource/quality_EP.dart';
import '../QualityDatasource/quality_ct.dart';
import '../QualityDatasource/quality_pss.dart';
import '../model/quality_checklistModel.dart';
import '../widget/style.dart';

class QualityChecklist extends StatefulWidget {
  String? cityName;
  String? depoName;
  QualityChecklist({super.key, this.cityName, this.depoName});

  @override
  State<QualityChecklist> createState() => _QualityChecklistState();
}

// List<QualitychecklistModel> checklisttable = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable1 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable2 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable3 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable4 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable5 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable6 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable7 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable8 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable9 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable10 = <QualitychecklistModel>[];

// late QualityChecklistDataSource _checklistDataSource;
late QualityPSSDataSource _qualityPSSDataSource;
late QualityrmuDataSource _qualityrmuDataSource;
late QualityctDataSource _qualityctDataSource;
late QualitycmuDataSource _qualitycmuDataSource;
late QualityacdDataSource _qualityacdDataSource;
late QualityCIDataSource _qualityCIDataSource;
late QualityCDIDataSource _qualityCDIDataSource;
late QualityMSPDataSource _qualityMSPDataSource;
late QualityChargerDataSource _qualityChargerDataSource;
late QualityEPDataSource _qualityEPDataSource;

late DataGridController _dataGridController;
bool _isloading = true;
List<dynamic> psstabledatalist = [];
List<dynamic> rmu_tabledatalist = [];
List<dynamic> ct_tabledatalist = [];
List<dynamic> cmu_tabledatalist = [];
List<dynamic> acdb_tabledatalist = [];
List<dynamic> ci_tabledatalist = [];
List<dynamic> cdi_tabledatalist = [];
List<dynamic> msp_tabledatalist = [];
List<dynamic> charger_tabledatalist = [];
List<dynamic> ep_tabledatalist = [];
Stream? _stream;
var alldata;
int? _selectedIndex = 0;
List<String> title = [
  'CHECKLIST FOR INSTALLATION OF PSS',
  'CHECKLIST FOR INSTALLATION OF RMU',
  'CHECKLIST FOR INSTALLATION OF  COVENTIONAL TRANSFORMER',
  'CHECKLIST FOR INSTALLATION OF CTPT METERING UNIT',
  'CHECKLIST FOR INSTALLATION OF ACDB',
  'CHECKLIST FOR  CABLE INSTALLATION ',
  'CHECKLIST FOR  CABLE DRUM / ROLL INSPECTION',
  'CHECKLIST FOR MCCB PANEL',
  'CHECKLIST FOR CHARGER PANEL',
  'CHECKLIST FOR INSTALLATION OF  EARTH PIT',
];

class _QualityChecklistState extends State<QualityChecklist> {
  @override
  void initState() {
    _isloading = false;
    _stream = FirebaseFirestore.instance
        .collection('c')
        .doc('${widget.depoName}')
        .snapshots();

    // checklisttable = getData();
    // _checklistDataSource = QualityChecklistDataSource(checklisttable);
    // _dataGridController = DataGridController();

    qualitylisttable1 = getData();
    _qualityPSSDataSource = QualityPSSDataSource(qualitylisttable1);
    _dataGridController = DataGridController();

    qualitylisttable2 = getData();
    _qualityrmuDataSource = QualityrmuDataSource(qualitylisttable2);
    _dataGridController = DataGridController();

    qualitylisttable3 = getData();
    _qualityctDataSource = QualityctDataSource(qualitylisttable2);
    _dataGridController = DataGridController();

    qualitylisttable4 = getData();
    _qualitycmuDataSource = QualitycmuDataSource(qualitylisttable4);
    _dataGridController = DataGridController();

    qualitylisttable5 = getData();
    _qualityacdDataSource = QualityacdDataSource(qualitylisttable5);
    _dataGridController = DataGridController();

    qualitylisttable6 = getData();
    _qualityCIDataSource = QualityCIDataSource(qualitylisttable6);
    _dataGridController = DataGridController();

    qualitylisttable7 = getData();
    _qualityCDIDataSource = QualityCDIDataSource(qualitylisttable7);
    _dataGridController = DataGridController();

    qualitylisttable8 = getData();
    _qualityMSPDataSource = QualityMSPDataSource(qualitylisttable8);
    _dataGridController = DataGridController();

    qualitylisttable9 = getData();
    _qualityChargerDataSource = QualityChargerDataSource(qualitylisttable9);
    _dataGridController = DataGridController();

    qualitylisttable10 = getData();
    _qualityEPDataSource = QualityEPDataSource(qualitylisttable10);
    _dataGridController = DataGridController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
          length: 10,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: blue,
              title: Text(
                  '${widget.cityName} / ${widget.depoName} / Quality Checklist /'),
              actions: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                    child: TextButton(
                        onPressed: () {
                          StoreData();
                        },
                        child: Text(
                          'Sync Data',
                          style: TextStyle(color: white, fontSize: 20),
                        )),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 150),
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
                    )
              ],
              bottom: TabBar(
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
                onTap: (value) {
                  _selectedIndex = value;
                  setState(() {});
                },
                tabs: const [
                  Tab(text: "PSS"),
                  Tab(text: "RMU"),
                  Tab(text: "CT"),
                  Tab(text: "CMU"),
                  Tab(text: "ACDB"),
                  Tab(text: "CI"),
                  Tab(text: "CDI"),
                  Tab(text: "MSP"),
                  Tab(text: "CHARGER"),
                  Tab(text: "EARTH PIT"),
                ],
              ),
            ),
            //  PreferredSize(
            //   child:
            //   CustomAppBar(
            //     text:
            //         'Quality Checklist / ${widget.cityName} / ${widget.depoName}',
            //     haveSynced: true,
            //     havebottom: true,
            //   ),
            //   preferredSize: Size.fromHeight(100),
            // ),
            body: TabBarView(children: [
              upperScreen(),
              upperScreen(),
              upperScreen(),
              upperScreen(),
              upperScreen(),
              upperScreen(),
              upperScreen(),
              upperScreen(),
              upperScreen(),
              upperScreen(),
            ]),
          )),
    );
  }

  void StoreData() {
    Map<String, dynamic> pss_table_data = Map();
    Map<String, dynamic> rmu_table_data = Map();
    Map<String, dynamic> ct_table_data = Map();
    Map<String, dynamic> cmu_table_data = Map();
    Map<String, dynamic> acdb_table_data = Map();
    Map<String, dynamic> ci_table_data = Map();
    Map<String, dynamic> cdi_table_data = Map();
    Map<String, dynamic> msp_table_data = Map();
    Map<String, dynamic> charger_table_data = Map();
    Map<String, dynamic> ep_table_data = Map();

    for (var i in _qualityPSSDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button') {
          pss_table_data[data.columnName] = data.value;
        }
      }

      psstabledatalist.add(pss_table_data);
      pss_table_data = {};
    }

    FirebaseFirestore.instance
        .collection('QualityChecklist')
        .doc('${widget.depoName}')
        .collection('PSS TABLE DATA')
        .doc('PSS DATA')
        .set({
      'data': psstabledatalist,
    }).whenComplete(() {
      for (var i in _qualityrmuDataSource.dataGridRows) {
        for (var data in i.getCells()) {
          if (data.columnName != 'button') {
            rmu_table_data[data.columnName] = data.value;
          }
        }

        rmu_tabledatalist.add(rmu_table_data);
        rmu_table_data = {};
      }

      FirebaseFirestore.instance
          .collection('QualityChecklist')
          .doc('${widget.depoName}')
          .collection('RMU TABLE DATA')
          .doc('RMU DATA')
          .set({
        'data': rmu_tabledatalist,
      }).whenComplete(() {
        for (var i in _qualityctDataSource.dataGridRows) {
          for (var data in i.getCells()) {
            if (data.columnName != 'button') {
              ct_table_data[data.columnName] = data.value;
            }
          }

          ct_tabledatalist.add(ct_table_data);
          ct_table_data = {};
        }

        FirebaseFirestore.instance
            .collection('QualityChecklist')
            .doc('${widget.depoName}')
            .collection('CONVENTIONAL TRANSFORMER TABLE DATA')
            .doc('CONVENTIONAL TRANSFORMER DATA')
            .set({
          'data': ct_tabledatalist,
        }).whenComplete(() {
          for (var i in _qualitycmuDataSource.dataGridRows) {
            for (var data in i.getCells()) {
              if (data.columnName != 'button') {
                cmu_table_data[data.columnName] = data.value;
              }
            }

            cmu_tabledatalist.add(cmu_table_data);
            cmu_table_data = {};
          }

          FirebaseFirestore.instance
              .collection('QualityChecklist')
              .doc('${widget.depoName}')
              .collection('CTPT METERING UNIT TABLE DATA')
              .doc('CTPT METERING DATA')
              .set({
            'data': cmu_tabledatalist,
          }).whenComplete(
                  () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Data are synced'),
                        backgroundColor: blue,
                      )));
        });
      });
    });
    // tabledata2.clear();
    // Navigator.pop(context);
  }
}

upperScreen() {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(8),
        height: 80,
        decoration: BoxDecoration(color: lighblue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('assets/Tata-Power.jpeg', height: 50, width: 100),
                Text('TATA POWER'),
              ],
            ),
            Text(
              title[int.parse(_selectedIndex.toString())],
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text('TPCL /DIST/EV/CHECKLIST ')
          ],
        ),
      ),
      Container(
        decoration: BoxDecoration(color: lighblue),
        child: Row(
          children: [
            Column(
              children: [
                HeaderValue('DIST-EV', ''),
                HeaderValue('Doc No.:TPCL/ DIST-EV', ''),
                HeaderValue('VENDOR NAME', ''),
                HeaderValue('DATE', ''),
              ],
            ),
            Column(
              children: [
                HeaderValue('OLA NUMBER', ''),
                HeaderValue('PANEL SR NO.', ''),
                HeaderValue('LOCATION NAME', 'Abstract of Cost/1'),
                HeaderValue('CUSTOMER NAME', ''),
              ],
            )
          ],
        ),
      ),
      Expanded(
        child: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return LoadingPage();
            // }
            if (!snapshot.hasData || snapshot.data.exists == false) {
              return SfDataGridTheme(
                data: SfDataGridThemeData(headerColor: blue),
                child: SfDataGrid(
                  source: _selectedIndex == 0
                      ? _qualityPSSDataSource
                      : _selectedIndex == 1
                          ? _qualityrmuDataSource
                          : _selectedIndex == 2
                              ? _qualityctDataSource
                              : _selectedIndex == 3
                                  ? _qualitycmuDataSource
                                  : _selectedIndex == 4
                                      ? _qualityacdDataSource
                                      : _selectedIndex == 5
                                          ? _qualityCIDataSource
                                          : _selectedIndex == 6
                                              ? _qualityCDIDataSource
                                              : _selectedIndex == 7
                                                  ? _qualityMSPDataSource
                                                  : _selectedIndex == 8
                                                      ? _qualityChargerDataSource
                                                      : _qualityEPDataSource,

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

                  // onQueryRowHeight: (details) {
                  //   return details.rowIndex == 0 ? 60.0 : 49.0;
                  // },
                  columns: [
                    GridColumn(
                      columnName: 'srNo',
                      width: 80,
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      width: 350,
                      columnName: 'checklist',
                      allowEditing: true,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('ACTIVITY',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: white)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'responsibility',
                      width: 250,
                      allowEditing: true,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('RESPONSIBILITY',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: white,
                            )),
                      ),
                    ),
                    GridColumn(
                      columnName: 'DOCUMENT REFERENCE',
                      allowEditing: true,
                      width: 250,
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('DOCUMENT REFERENCE',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: white)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'observation',
                      allowEditing: true,
                      width: 200,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('OBSERVATION',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: white)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'photoNo',
                      allowEditing: true,
                      width: 150,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('PHOTO NO.',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: white)),
                      ),
                    ),
                  ],

                  // stackedHeaderRows: [
                  //   StackedHeaderRow(cells: [
                  //     StackedHeaderCell(
                  //         columnNames: ['SrNo'],
                  //         child: Container(child: Text('Project')))
                  //   ])
                  // ],
                ),
              );
            } else if (snapshot.hasData) {
              alldata = '';
              alldata = snapshot.data['data'] as List<dynamic>;
              qualitylisttable1.clear();
              alldata.forEach((element) {
                qualitylisttable1.add(QualitychecklistModel.fromJson(element));
                _qualityPSSDataSource = QualityPSSDataSource(qualitylisttable1);
                _dataGridController = DataGridController();
              });
              return SfDataGridTheme(
                data: SfDataGridThemeData(headerColor: blue),
                child: SfDataGrid(
                  source: _qualityPSSDataSource,
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

                  // onQueryRowHeight: (details) {
                  //   return details.rowIndex == 0 ? 60.0 : 49.0;
                  // },
                  columns: [
                    GridColumn(
                      columnName: 'srNo',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      width: 200,
                      columnName: 'checklist',
                      allowEditing: true,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Description of items',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: white)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'responsibility',
                      allowEditing: true,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Activity Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: white,
                            )),
                      ),
                    ),
                    GridColumn(
                      columnName: 'reference',
                      allowEditing: true,
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('BOQ RefNo',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: white)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'observation',
                      allowEditing: true,
                      width: 180,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Abstract of JMR',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: white)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'photoNo',
                      allowEditing: true,
                      width: 80,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('UOM',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: white)),
                      ),
                    ),
                  ],

                  // stackedHeaderRows: [
                  //   StackedHeaderRow(cells: [
                  //     StackedHeaderCell(
                  //         columnNames: ['SrNo'],
                  //         child: Container(child: Text('Project')))
                  //   ])
                  // ],
                ),
              );
            } else {
              return NodataAvailable();
            }
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (() {
              if (_selectedIndex == 0) {
                qualitylisttable1.add(
                  QualitychecklistModel(
                    srNo: 1,
                    checklist: 'checklist',
                    responsibility: 'responsibility',
                    reference: 'reference',
                    observation: 'observation',
                    photoNo: 12345,
                  ),
                );
                _qualityPSSDataSource.buildDataGridRows();
                _qualityPSSDataSource.updateDatagridSource();
              } else if (_selectedIndex == 1) {
                qualitylisttable2.add(
                  QualitychecklistModel(
                    srNo: 1,
                    checklist: 'checklist',
                    responsibility: 'responsibility',
                    reference: 'reference',
                    observation: 'observation',
                    photoNo: 12345,
                  ),
                );
                _qualityrmuDataSource.buildDataGridRows();
                _qualityrmuDataSource.updateDatagridSource();
              } else if (_selectedIndex == 2) {
                qualitylisttable3.add(
                  QualitychecklistModel(
                    srNo: 1,
                    checklist: 'checklist',
                    responsibility: 'responsibility',
                    reference: 'reference',
                    observation: 'observation',
                    photoNo: 12345,
                  ),
                );
                _qualityctDataSource.buildDataGridRows();
                _qualityctDataSource.updateDatagridSource();
              } else if (_selectedIndex == 3) {
                qualitylisttable4.add(
                  QualitychecklistModel(
                    srNo: 1,
                    checklist: 'checklist',
                    responsibility: 'responsibility',
                    reference: 'reference',
                    observation: 'observation',
                    photoNo: 12345,
                  ),
                );
                _qualitycmuDataSource.buildDataGridRows();
                _qualitycmuDataSource.updateDatagridSource();
              } else if (_selectedIndex == 4) {
                qualitylisttable5.add(
                  QualitychecklistModel(
                    srNo: 1,
                    checklist: 'checklist',
                    responsibility: 'responsibility',
                    reference: 'reference',
                    observation: 'observation',
                    photoNo: 12345,
                  ),
                );
                _qualityacdDataSource.buildDataGridRows();
                _qualityacdDataSource.updateDatagridSource();
              } else if (_selectedIndex == 5) {
                qualitylisttable6.add(
                  QualitychecklistModel(
                    srNo: 1,
                    checklist: 'checklist',
                    responsibility: 'responsibility',
                    reference: 'reference',
                    observation: 'observation',
                    photoNo: 12345,
                  ),
                );
                _qualityCIDataSource.buildDataGridRows();
                _qualityCIDataSource.updateDatagridSource();
              } else if (_selectedIndex == 6) {
                qualitylisttable7.add(
                  QualitychecklistModel(
                    srNo: 1,
                    checklist: 'checklist',
                    responsibility: 'responsibility',
                    reference: 'reference',
                    observation: 'observation',
                    photoNo: 12345,
                  ),
                );
                _qualityCDIDataSource.buildDataGridRows();
                _qualityCDIDataSource.updateDatagridSource();
              } else if (_selectedIndex == 7) {
                qualitylisttable8.add(
                  QualitychecklistModel(
                    srNo: 1,
                    checklist: 'checklist',
                    responsibility: 'responsibility',
                    reference: 'reference',
                    observation: 'observation',
                    photoNo: 12345,
                  ),
                );
                _qualityMSPDataSource.buildDataGridRows();
                _qualityMSPDataSource.updateDatagridSource();
              } else if (_selectedIndex == 8) {
                qualitylisttable9.add(
                  QualitychecklistModel(
                    srNo: 1,
                    checklist: 'checklist',
                    responsibility: 'responsibility',
                    reference: 'reference',
                    observation: 'observation',
                    photoNo: 12345,
                  ),
                );
                _qualityChargerDataSource.buildDataGridRows();
                _qualityChargerDataSource.updateDatagridSource();
              } else if (_selectedIndex == 9) {
                qualitylisttable10.add(
                  QualitychecklistModel(
                    srNo: 1,
                    checklist: 'checklist',
                    responsibility: 'responsibility',
                    reference: 'reference',
                    observation: 'observation',
                    photoNo: 12345,
                  ),
                );
                _qualityEPDataSource.buildDataGridRows();
                _qualityEPDataSource.updateDatagridSource();
              }
            }),
          ),
        ),
      ),
    ],
  );
}

HeaderValue(String title, String hintValue) {
  return Container(
    color: lighblue,
    width: 625,
    padding: EdgeInsets.all(3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
            width: 150,
            child: Text(
              title,
            )),
        SizedBox(width: 5),
        Expanded(
            child: Container(
          height: 30,
          child: TextFormField(
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5)),
            initialValue: hintValue,
            style: TextStyle(fontSize: 15),
          ),
        )),
      ],
    ),
  );
}

List<QualitychecklistModel> getData() {
  return [
    QualitychecklistModel(
      srNo: 1,
      checklist: 'checklist',
      responsibility: 'responsibility',
      reference: 'reference',
      observation: 'observation',
      photoNo: 12345,
    ),
  ];
}
