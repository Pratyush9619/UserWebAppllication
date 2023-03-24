// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../components/loading_page.dart';
import '../datasource/depot_overviewdatasource.dart';
import '../model/depot_overview.dart';
import '../widget/chart_data.dart';
import '../widget/custom_appbar.dart';
import '../widget/style.dart';

class DepotOverview extends StatefulWidget {
  String? cityName;
  String? depoName;

  DepotOverview({super.key, required this.cityName, required this.depoName});

  @override
  State<DepotOverview> createState() => _DepotOverviewState();
}

class _DepotOverviewState extends State<DepotOverview> {
  late DepotOverviewDatasource _employeeDataSource;
  List<DepotOverviewModel> _employees = <DepotOverviewModel>[];
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  FilePickerResult? result;
  FilePickerResult? result1;
  TextEditingController? _addressController = TextEditingController();
  // TextEditingController? _textEditingController,
  //     _textEditingController2,
  //     _textEditingController3,
  //     _textEditingController4,
  //     _textEditingController5,
  //     _textEditingController6;
  var address,
      scope,
      required,
      charger,
      load,
      powerSource,
      boqElectrical,
      boqCivil,
      managername;

  Stream? _stream, _stream1;
  var alldata;
  Uint8List? fileBytes;
  Uint8List? fileBytes1;

  @override
  void initState() {
    _employees = getEmployeeData();
    _employeeDataSource = DepotOverviewDatasource(_employees, context);
    _dataGridController = DataGridController();
    _stream = FirebaseFirestore.instance
        .collection('OverviewCollectionTable')
        .doc(widget.depoName)
        .snapshots();

    _stream1 = FirebaseFirestore.instance
        .collection('OverviewCollection')
        .doc(widget.depoName)
        .snapshots();

    _fetchUserData();

    super.initState();
    // _textEditingController =
    //     TextEditingController(text: _textprovider.changedata);
    // _textEditingController2 =
    //     TextEditingController(text: _textprovider.changedata);
    // _textEditingController3 =
    //     TextEditingController(text: _textprovider.changedata);
    // _textEditingController4 =
    //     TextEditingController(text: _textprovider.changedata);
    // _textEditingController5 =
    //     TextEditingController(text: _textprovider.changedata);
    // _textEditingController6 =
    //     TextEditingController(text: _textprovider.changedata);
  }

  final List<PieChartData> chartData = [
    PieChartData('A1', 25, blue),
    PieChartData('A2', 38, Colors.lightBlue),
    PieChartData('A3', 34, green),
    PieChartData('A4', 52, Colors.yellow)
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: PreferredSize(
            // ignore: sort_child_properties_last
            child: CustomAppBar(
              text: '${widget.cityName} / ${widget.depoName} / Depot Overview',
              haveSynced: true,
              store: () {
                FirebaseFirestore.instance
                    .collection('OverviewCollection')
                    .doc(widget.depoName)
                    .set({
                  'address': address ?? 'Enter Address',
                  'scope': scope ?? 'Enter Scope',
                  'required': required ?? 'Enter Required',
                  'charger': charger ?? 'Enter Charger',
                  'load': load ?? 'Enter Load',
                  'powerSource': powerSource ?? 'Enter PowerSource',
                  'ManagerName': managername ?? 'Enter Manager Name',
                });

                storeData();
              },
            ),
            preferredSize: Size.fromHeight(50)),
        body: Column(
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.blue),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                        'Current Progress of Depot Infrastructure Work ',
                        style: TextStyle(color: white, fontSize: 18)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '50 %',
                      style: TextStyle(color: white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: 500,
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: blue),
                              child: Text(
                                'Brief Overview of ${widget.depoName} E-Bus Depot',
                                style: TextStyle(color: white, fontSize: 16),
                              )),
                          const SizedBox(height: 25),
                          cards(),
                          SizedBox(height: 20),
                          // ElevatedButton(
                          //     onPressed: () async {
                          //       FirebaseFirestore.instance
                          //           .collection('OverviewCollection')
                          //           .doc(widget.depoName)
                          //           .set({
                          //         'address': address,
                          //         'scope': scope ?? 'Enter Scope',
                          //         'required': required ?? 'Enter Required',
                          //         'charger': charger ?? 'Enter Charger',
                          //         'load': load ?? 'Enter Load',
                          //         'powerSource':
                          //             powerSource ?? 'Enter PowerSource',
                          //       });

                          //       storeData();
                          //     },
                          //     child: Text('Sync'))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'E-Bus Depot Name : ${widget.depoName}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Project Manager: ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                // width: 250,
                                height: 35,
                                child: StreamBuilder(
                                  stream: _stream1,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      managername =
                                          snapshot.data!.get('ManagerName');
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          managername,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: black),
                                        ),
                                      );
                                    } else {
                                      return Text('ddd');
                                    }

                                    // TextFormField(
                                    //     initialValue: snapshot.data!
                                    //             .data()
                                    //             .toString()
                                    //             .contains('ManagerName')
                                    //         ? snapshot.data!
                                    //                 .get('ManagerName') ??
                                    //             'ManagerName '
                                    //         : 'ManagerName',
                                    //     // initialValue:
                                    //     //     snapshot.data!.get('ManagerName') ??
                                    //     //         '',
                                    //     maxLines: 1,
                                    //     textInputAction: TextInputAction.done,
                                    //     minLines: 1,
                                    //     autofocus: false,
                                    //     textAlign: TextAlign.center,
                                    //     style: TextStyle(
                                    //         color: black, fontSize: 16),
                                    //     onChanged: (value) {
                                    //       managerName = value;
                                    //     });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: blue),
                              child: Text('Risk Register',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: white)),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 12)),
                          Expanded(
                              child: StreamBuilder(
                            stream: _stream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.data.exists == false) {
                                return SfDataGrid(
                                  source: _employeeDataSource,
                                  allowEditing: true,
                                  frozenColumnsCount: 2,
                                  gridLinesVisibility: GridLinesVisibility.both,
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.both,
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
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sr No',
                                          overflow: TextOverflow.values.first,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          //    textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Date',
                                      width: 160,
                                      allowEditing: false,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Risk On Date',
                                          overflow: TextOverflow.values.first,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'RiskDescription',
                                      width: 180,
                                      allowEditing: true,
                                      label: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        alignment: Alignment.center,
                                        child: const Text('Risk Description',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'TypeRisk',
                                      width: 180,
                                      allowEditing: false,
                                      label: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        alignment: Alignment.center,
                                        child: const Text('Type',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'impactRisk',
                                      width: 150,
                                      allowEditing: false,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Impact Risk',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Owner',
                                      allowEditing: true,
                                      width: 150,
                                      label: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text('Owner',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                          ),
                                          Text(
                                              'Person Who will manage the risk',
                                              overflow:
                                                  TextOverflow.values.first,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12))
                                        ],
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'MigratingRisk',
                                      allowEditing: true,
                                      columnWidthMode:
                                          ColumnWidthMode.fitByCellValue,
                                      width: 150,
                                      label: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text('Mitigation Action',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                          ),
                                          Text(
                                              'Action to Mitigate the risk e.g reduce the likelihood',
                                              overflow:
                                                  TextOverflow.values.first,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12))
                                        ],
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ContigentAction',
                                      allowEditing: true,
                                      width: 180,
                                      label: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: Text('Contigent Action',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                          ),
                                          Text(
                                              'Action to be taken if the risk happens',
                                              overflow:
                                                  TextOverflow.values.first,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12))
                                        ],
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ProgressionAction',
                                      allowEditing: true,
                                      width: 180,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text('Progression Action',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Reason',
                                      allowEditing: true,
                                      width: 150,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text('Remark',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'TargetDate',
                                      allowEditing: false,
                                      width: 160,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Target Completion Date Of Risk',
                                            overflow: TextOverflow.values.first,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Status',
                                      allowEditing: false,
                                      width: 150,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text('Status',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                alldata =
                                    snapshot.data['data'] as List<dynamic>;
                                _employees.clear();
                                alldata.forEach((element) {
                                  _employees.add(
                                      DepotOverviewModel.fromJson(element));
                                  _employeeDataSource = DepotOverviewDatasource(
                                      _employees, context);
                                  _dataGridController = DataGridController();
                                });
                                return SfDataGrid(
                                  source: _employeeDataSource,
                                  allowEditing: true,
                                  frozenColumnsCount: 2,
                                  gridLinesVisibility: GridLinesVisibility.both,
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.both,
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
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sr No',
                                          overflow: TextOverflow.values.first,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          //    textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Date',
                                      width: 160,
                                      allowEditing: false,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Date',
                                          overflow: TextOverflow.values.first,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'RiskDescription',
                                      width: 130,
                                      allowEditing: true,
                                      label: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        alignment: Alignment.center,
                                        child: const Text('Risk Description',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'TypeRisk',
                                      width: 180,
                                      allowEditing: false,
                                      label: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        alignment: Alignment.center,
                                        child: const Text('Type',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'impactRisk',
                                      width: 150,
                                      allowEditing: false,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Impact Risk',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Owner',
                                      allowEditing: true,
                                      width: 150,
                                      label: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text('Owner',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                          ),
                                          Text(
                                              'Person Who will manage the risk',
                                              overflow:
                                                  TextOverflow.values.first,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12))
                                        ],
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'MigratingRisk',
                                      allowEditing: true,
                                      columnWidthMode: ColumnWidthMode.fill,
                                      label: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: const Text(
                                                'Mitigation Action',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                          ),
                                          Text(
                                              'Action to Mitigate the risk e.g reduce the likelihood',
                                              overflow:
                                                  TextOverflow.values.first,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12))
                                        ],
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ContigentAction',
                                      allowEditing: true,
                                      width: 180,
                                      label: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: Text('Contigent Action',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                          ),
                                          Text(
                                              'Action to be taken if the risk happens',
                                              overflow:
                                                  TextOverflow.values.first,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12))
                                        ],
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ProgressionAction',
                                      allowEditing: true,
                                      width: 180,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text('Progression Action',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Reason',
                                      allowEditing: true,
                                      width: 150,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text('Remark',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'TargetDate',
                                      allowEditing: false,
                                      width: 160,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Target Completion Date Of Risk',
                                            overflow: TextOverflow.values.first,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Status',
                                      allowEditing: false,
                                      width: 150,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text('Status',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (() {
              _employees.add(
                DepotOverviewModel(
                  srNo: 1,
                  date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                  riskDescription: 'dedd',
                  typeRisk: 'Material Supply',
                  impactRisk: 'High',
                  owner: 'Pratyush',
                  migrateAction: ' lkmlm',
                  contigentAction: 'mlkmlk',
                  progressAction: 'pending',
                  reason: '',
                  TargetDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                  status: 'Close',
                ),
              );
              _employeeDataSource.buildDataGridRows();
              _employeeDataSource.updateDatagridSource();
            })),
      ),
    );
  }

  cards() {
    return Expanded(
      child: Container(
        width: 550,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('OverviewCollection')
              .doc(widget.depoName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 280,
                          child: const Text(
                            'Depots location and Address ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                            width: 200,
                            height: 35,
                            child: TextFormField(
                                initialValue: snapshot.data!
                                        .data()
                                        .toString()
                                        .contains('address')
                                    ? snapshot.data!.get('address')
                                    : 'Enter Address',
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
                                minLines: 1,
                                autofocus: false,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                                onChanged: (value) {
                                  address = value;
                                },
                                onSaved: (value) {
                                  address = value;
                                })),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: const Text(
                            'No of Buses in Scope',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 35,
                          child: TextFormField(
                              initialValue: snapshot.data!
                                      .data()
                                      .toString()
                                      .contains('scope')
                                  ? snapshot.data!.get('scope') ?? 'Enter scope'
                                  : 'Enter scope',
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              minLines: 1,
                              autofocus: false,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15),
                              onSaved: (newValue) {
                                scope = newValue;
                              },
                              onChanged: (value) {
                                scope = value;
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: const Text(
                            'No. of Charger Required ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 35,
                          child: TextFormField(
                              initialValue: snapshot.data!
                                      .data()
                                      .toString()
                                      .contains('required')
                                  ? snapshot.data!.get('required') ??
                                      'Enter Required'
                                  : 'Enter Required',
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              minLines: 1,
                              autofocus: false,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                              onChanged: (value) {
                                required = value;
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: const Text(
                            'Rating Of charger ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 35,
                          child: TextFormField(
                              initialValue: snapshot.data!
                                      .data()
                                      .toString()
                                      .contains('charger')
                                  ? snapshot.data!.get('charger') ??
                                      'Enter no. of Charger '
                                  : 'Enter no. of Charger',
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              minLines: 1,
                              autofocus: false,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                              onChanged: (value) {
                                charger = value;
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: const Text(
                            'Required Sanctioned load ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 35,
                          child: TextFormField(
                              initialValue: snapshot.data!
                                      .data()
                                      .toString()
                                      .contains('load')
                                  ? snapshot.data!.get('load') ?? 'Enter  load '
                                  : 'Enter  load ',
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              minLines: 1,
                              autofocus: false,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                              onChanged: (value) {
                                load = value;
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 280,
                          child: const Text(
                            'Existing Utility for power source ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 35,
                          child: TextFormField(
                              initialValue: snapshot.data!
                                      .data()
                                      .toString()
                                      .contains('powerSource')
                                  ? snapshot.data!.get('powerSource') ??
                                      'Enter  PowerSource '
                                  : 'Enter  PowerSource ',
                              textInputAction: TextInputAction.done,
                              minLines: 1,
                              autofocus: false,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                              onChanged: (value) {
                                powerSource = value;
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 30),
                          width: 280,
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'BOQ Electrical',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: black),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    result = await FilePicker.platform
                                        .pickFiles(
                                            type: FileType.custom,
                                            withData: true,
                                            allowedExtensions: ['pdf']);
                                    fileBytes = result!.files.first.bytes;
                                    if (result == null) {
                                      print("No file selected");
                                    } else {
                                      setState(() {});
                                      result?.files.forEach((element) {
                                        print(element.name);
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Pick file',
                                    textAlign: TextAlign.end,
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                width: 150,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: lighblue,
                                    border: Border.all(color: grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    if (result != null)
                                      Text(
                                        result!.files.first.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15, color: white),
                                      ),
                                  ],
                                )),
                            IconButton(
                                alignment: Alignment.bottomRight,
                                padding: EdgeInsets.only(bottom: 5),
                                onPressed: () {},
                                icon: Icon(Icons.delete, color: red))
                          ],
                        ),
                        // TextFormField(
                        //     initialValue: snapshot.data!
                        //             .data()
                        //             .toString()
                        //             .contains('powerSource')
                        //         ? snapshot.data!.get('powerSource') ??
                        //             'Enter  PowerSource '
                        //         : 'Enter  PowerSource ',
                        //     textInputAction: TextInputAction.done,
                        //     minLines: 1,
                        //     autofocus: false,
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(fontSize: 15),
                        //     onChanged: (value) {
                        //       powerSource = value;
                        //     }),

                        // Container(
                        //     width: 200,
                        //     height: 100,
                        //     child: Column(
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             if (result != null)
                        //               const Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //               ),
                        //             ElevatedButton(
                        //                 onPressed: () async {
                        //                   result = await FilePicker.platform
                        //                       .pickFiles(
                        //                           type: FileType.custom,
                        //                           withData: true,
                        //                           allowedExtensions: ['pdf']);
                        //                   if (result == null) {
                        //                     print("No file selected");
                        //                   } else {
                        //                     setState(() {});
                        //                     result?.files.forEach((element) {
                        //                       print(element.name);
                        //                     });
                        //                   }
                        //                 },
                        //                 child: const Text(
                        //                   'Pick file',
                        //                   textAlign: TextAlign.end,
                        //                 )),
                        //             ElevatedButton(
                        //                 onPressed: () async {
                        //                   result = await FilePicker.platform
                        //                       .pickFiles(withData: true);
                        //                   if (result == null) {
                        //                     print("No file selected");
                        //                   } else {
                        //                     setState(() {});
                        //                     result?.files.forEach((element) {
                        //                       print(element.name);
                        //                     });
                        //                   }
                        //                 },
                        //                 child: Row(
                        //                   children: [
                        //                     if (result != null)
                        //                       Container(
                        //                         width: 65,
                        //                         child: Text(
                        //                           result!.files.first.name,
                        //                           overflow:
                        //                               TextOverflow.ellipsis,
                        //                           textAlign: TextAlign.end,
                        //                         ),
                        //                       )
                        //                   ],
                        //                 )),
                        //           ],
                        //         ),
                        //         Container(
                        //             width: 200,
                        //             height: 70,
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 if (result != null)
                        //                   Padding(
                        //                     padding: const EdgeInsets.all(8.0),
                        //                     child: Container(
                        //                       width: 170,
                        //                       child: Text(
                        //                         result!.files.first.name,
                        //                         overflow: TextOverflow.ellipsis,
                        //                         style: const TextStyle(
                        //                             fontSize: 16,
                        //                             fontWeight:
                        //                                 FontWeight.bold),
                        //                       ),
                        //                     ),
                        //                   ),
                        //               ],
                        //             )),
                        //       ],
                        //     )),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 30),
                          width: 280,
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'BOQ Civil',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: black),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    result1 = await FilePicker.platform
                                        .pickFiles(
                                            type: FileType.custom,
                                            withData: true,
                                            allowedExtensions: ['pdf']);
                                    fileBytes1 = result1!.files.first.bytes;
                                    if (result == null) {
                                      print("No file selected");
                                    } else {
                                      setState(() {});
                                      result?.files.forEach((element) {
                                        print(element.name);
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Pick file',
                                    textAlign: TextAlign.end,
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                width: 150,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(color: grey),
                                    borderRadius: BorderRadius.circular(5),
                                    color: lighblue),
                                child: Row(
                                  children: [
                                    if (result1 != null)
                                      Text(
                                        result1!.files.first.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15, color: white),
                                      ),
                                  ],
                                )),
                            IconButton(
                                alignment: Alignment.bottomRight,
                                padding: EdgeInsets.only(bottom: 5),
                                onPressed: () {},
                                icon: Icon(
                                  Icons.delete,
                                  color: red,
                                ))
                          ],
                        ),

                        // Container(
                        //     width: 200,
                        //     height: 80,
                        //     child: Column(
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             if (result1 != null)
                        //               const Padding(
                        //                 padding: const EdgeInsets.only(top: 10),
                        //               ),
                        //             ElevatedButton(
                        //                 onPressed: () async {
                        //                   result1 = await FilePicker.platform
                        //                       .pickFiles(withData: true);
                        //                   if (result1 == null) {
                        //                     print("No file selected");
                        //                   } else {
                        //                     setState(() {});
                        //                     result1?.files.forEach((element) {
                        //                       print(element.name);
                        //                     });
                        //                   }
                        //                 },
                        //                 child: const Text('Pick file')),
                        //             ElevatedButton(
                        //                 onPressed: () async {
                        //                   result1 = await FilePicker.platform
                        //                       .pickFiles(withData: true);
                        //                   if (result1 == null) {
                        //                     print("No file selected");
                        //                   } else {
                        //                     setState(() {});
                        //                     result1?.files.forEach((element) {
                        //                       print(element.name);
                        //                     });
                        //                   }
                        //                 },
                        //                 child: const Text('Pick file')),
                        //           ],
                        //         ),
                        //         Container(
                        //             child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             if (result1 != null)
                        //               Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Container(
                        //                   decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(10)),
                        //                   width: 150,
                        //                   child: Text(
                        //                     result1!.files.first.name,
                        //                     overflow: TextOverflow.ellipsis,
                        //                     style: const TextStyle(
                        //                         fontSize: 14,
                        //                         fontWeight: FontWeight.bold),
                        //                   ),
                        //                 ),
                        //               ),
                        //           ],
                        //         )),
                        //       ],
                        //     )),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Center(
                        child: SfCircularChart(
                      legend: Legend(
                          isVisible: true, position: LegendPosition.right),
                      series: [
                        PieSeries<PieChartData, String>(
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                            dataSource: chartData,
                            pointColorMapper: (PieChartData data, _) =>
                                data.color,
                            xValueMapper: (PieChartData data, _) => data.x,
                            yValueMapper: (PieChartData data, _) => data.y)
                      ],
                    ))
                  ],
                ),
              );
            }
            return LoadingPage();
          },
        ),
      ),
    );
  }

  // overviewDetails(String title, String subtitle) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Container(
  //         width: 250,
  //         child: Text(
  //           subtitle,
  //           textAlign: TextAlign.start,
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //       Container(
  //           width: 200,
  //           height: 35,
  //           child: TextFormField(
  //               initialValue: subtitle,
  //               textInputAction: TextInputAction.done,
  //               minLines: 1,
  //               autofocus: false,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(color: black, fontSize: 16),
  //               onChanged: (value) {
  //                 address = value;
  //               },
  //               onSaved: (value) {
  //                 address = value;
  //               })),
  //     ],
  //   );
  // }

  void storeData() {
    Map<String, dynamic> table_data = Map();
    for (var i in _employeeDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        table_data[data.columnName] = data.value;
      }

      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('OverviewCollectionTable')
        .doc(widget.depoName)
        .set({
      'data': tabledata2,
    }).whenComplete(() async {
      tabledata2.clear();
      if (fileBytes != null && fileBytes1 != null) {
        await FirebaseStorage.instance
            .ref(
                'BOQElectrical/${widget.cityName}/${widget.depoName}/${result!.files.first.name}')
            .putData(
                fileBytes!, SettableMetadata(contentType: 'application/pdf'));
        await FirebaseStorage.instance
            .ref(
                'BOQCivil/${widget.cityName}/${widget.depoName}/${result1!.files.first.name}')
            .putData(
                fileBytes1!, SettableMetadata(contentType: 'application/pdf'));
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  void _fetchUserData() async {
    await FirebaseFirestore.instance
        .collection('OverviewCollection')
        .doc(widget.depoName)
        .get()
        .then((ds) {
      setState(() {
        managername = ds.data()!['ManagerName'];
        address = ds.data()!['address'];
        scope = ds.data()!['scope'];
        required = ds.data()!['required'];
        charger = ds.data()!['charger'];
        load = ds.data()!['load'];
        powerSource = ds.data()!['powerSource'];
      });
    });
  }
}

List<DepotOverviewModel> getEmployeeData() {
  return [
    DepotOverviewModel(
        srNo: 1,
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        riskDescription: '',
        typeRisk: 'Material Supply',
        impactRisk: 'High',
        owner: '',
        migrateAction: ' ',
        contigentAction: '',
        progressAction: '',
        reason: '',
        TargetDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        status: 'Close')
  ];
}
