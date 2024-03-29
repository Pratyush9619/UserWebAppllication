import 'package:assingment/components/loading_page.dart';
import 'package:assingment/datasource/detailedeng_datasource.dart';
import 'package:assingment/model/detailed_engModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Authentication/auth_service.dart';
import '../KeysEvents/Grid_DataTable.dart';
import '../datasource/detailedengEV_datasource.dart';
import '../datasource/detailedengShed_datasource.dart';
import '../widget/custom_appbar.dart';
import '../widget/style.dart';

class DetailedEng extends StatefulWidget {
  String? cityName;
  String? depoName;
  DetailedEng({super.key, required this.cityName, required this.depoName});

  @override
  State<DetailedEng> createState() => _DetailedEngtState();
}

class _DetailedEngtState extends State<DetailedEng>
    with TickerProviderStateMixin {
  List<DetailedEngModel> DetailedProject = <DetailedEngModel>[];
  List<DetailedEngModel> DetailedProjectev = <DetailedEngModel>[];
  List<DetailedEngModel> DetailedProjectshed = <DetailedEngModel>[];
  late DetailedEngSourceShed _detailedEngSourceShed;
  late DetailedEngSource _detailedDataSource;
  late DetailedEngSourceEV _detailedEngSourceev;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  List<dynamic> ev_tabledatalist = [];
  List<dynamic> shed_tabledatalist = [];
  TabController? _controller;
  int _selectedIndex = 0;
  Stream? _stream;
  Stream? _stream1;
  Stream? _stream2;
  var alldata;
  bool _isloading = true;
  dynamic userId;

  @override
  void initState() {
    getmonthlyReport();
    getmonthlyReportEv();
    getUserId().whenComplete(() {
      DetailedProject = getmonthlyReport();
      _detailedDataSource = DetailedEngSource(DetailedProject, context,
          widget.cityName.toString(), widget.depoName.toString(), userId);
      _dataGridController = DataGridController();

      DetailedProjectev = getmonthlyReportEv();
      _detailedEngSourceev = DetailedEngSourceEV(DetailedProjectev, context,
          widget.cityName.toString(), widget.depoName.toString(), userId);
      _dataGridController = DataGridController();

      DetailedProjectshed = getmonthlyReportEv();
      _detailedEngSourceShed = DetailedEngSourceShed(
          DetailedProjectshed,
          context,
          widget.cityName.toString(),
          widget.depoName.toString(),
          userId);
      _dataGridController = DataGridController();
      _controller = TabController(length: 3, vsync: this);

      _stream = FirebaseFirestore.instance
          .collection('DetailEngineering')
          .doc('${widget.depoName}')
          .collection('RFC LAYOUT DRAWING')
          .doc(userId)
          .snapshots();

      _stream1 = FirebaseFirestore.instance
          .collection('DetailEngineering')
          .doc('${widget.depoName}')
          .collection('EV LAYOUT DRAWING')
          .doc(userId)
          .snapshots();

      _stream2 = FirebaseFirestore.instance
          .collection('DetailEngineering')
          .doc('${widget.depoName}')
          .collection('Shed LAYOUT DRAWING')
          .doc(userId)
          .snapshots();

      _isloading = false;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: blue,
            title: Text(
              '${widget.cityName} / ${widget.depoName} / Detailed Engineering',
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
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
              onTap: (value) {
                _selectedIndex = value;
              },
              tabs: const [
                Tab(text: "RFC Drawings of Civil Activities"),
                Tab(text: "EV Layout Drawings of Electrical Activities"),
                Tab(text: "Shed Lighting Drawings & Specification"),
              ],
            )),
        // PreferredSize(
        //     // ignore: sort_child_properties_last
        //     child: CustomAppBar(
        //       text:
        //           'Detailed Engineering/ ${widget.cityName}/ ${widget.depoName}',
        //       haveSynced: true,
        //       havebottom: false,
        //       store: () {
        //         StoreData();
        //       },
        //     ),
        //     preferredSize: Size.fromHeight(100)),

        body: TabBarView(children: [
          tabScreen(),
          tabScreen1(),
          tabScreen2(),
        ]),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: (() {
        //     DetailedProject.add(DetailedEngModel(
        //       siNo: 1,
        //       title: 'EV Layout',
        //       number: 12345,
        //       preparationDate: DateFormat().add_yMd().format(DateTime.now()),
        //       submissionDate: DateFormat().add_yMd().format(DateTime.now()),
        //       approveDate: DateFormat().add_yMd().format(DateTime.now()),
        //       releaseDate: DateFormat().add_yMd().format(DateTime.now()),
        //     ));
        //     _detailedDataSource.buildDataGridRows();
        //     _detailedDataSource.updateDatagridSource();
        //   }),
        // ),
      ),
    );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  void StoreData() {
    Map<String, dynamic> table_data = Map();
    Map<String, dynamic> ev_table_data = Map();
    Map<String, dynamic> shed_table_data = Map();

    for (var i in _detailedDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName != 'ViewDrawing' ||
            data.columnName != "Delete") {
          table_data[data.columnName] = data.value;
        }
      }

      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('DetailEngineering')
        .doc('${widget.depoName}')
        .collection('RFC LAYOUT DRAWING')
        .doc(userId)
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      for (var i in _detailedEngSourceev.dataGridRows) {
        for (var data in i.getCells()) {
          if (data.columnName != 'button' ||
              data.columnName != 'ViewDrawing' ||
              data.columnName != "Delete") {
            ev_table_data[data.columnName] = data.value;
          }
        }

        ev_tabledatalist.add(ev_table_data);
        ev_table_data = {};
      }

      FirebaseFirestore.instance
          .collection('DetailEngineering')
          .doc('${widget.depoName}')
          .collection('EV LAYOUT DRAWING')
          .doc(userId)
          .set({
        'data': ev_tabledatalist,
      }).whenComplete(() {
        for (var i in _detailedEngSourceShed.dataGridRows) {
          for (var data in i.getCells()) {
            if (data.columnName != 'button' ||
                data.columnName != 'ViewDrawing' ||
                data.columnName != "Delete") {
              shed_table_data[data.columnName] = data.value;
            }
          }

          shed_tabledatalist.add(shed_table_data);
          shed_table_data = {};
        }

        FirebaseFirestore.instance
            .collection('DetailEngineering')
            .doc('${widget.depoName}')
            .collection('Shed LAYOUT DRAWING')
            .doc(userId)
            .set({
          'data': shed_tabledatalist,
        }).whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Data are synced'),
            backgroundColor: blue,
          ));
        });
      });
      // tabledata2.clear();
      // Navigator.pop(context);
    });
  }

  List<DetailedEngModel> getmonthlyReportEv() {
    return [
      DetailedEngModel(
        siNo: 2,
        title: 'EV Layout',
        number: 123458656,
        preparationDate: DateFormat().add_yMd().format(DateTime.now()),
        submissionDate: DateFormat().add_yMd().format(DateTime.now()),
        approveDate: DateFormat().add_yMd().format(DateTime.now()),
        releaseDate: DateFormat().add_yMd().format(DateTime.now()),
      ),
    ];
  }

  List<DetailedEngModel> getmonthlyReportShed() {
    return [
      DetailedEngModel(
        siNo: 2,
        title: 'EV Layout',
        number: 123458656,
        preparationDate: DateFormat().add_yMd().format(DateTime.now()),
        submissionDate: DateFormat().add_yMd().format(DateTime.now()),
        approveDate: DateFormat().add_yMd().format(DateTime.now()),
        releaseDate: DateFormat().add_yMd().format(DateTime.now()),
      ),
    ];
  }

  List<DetailedEngModel> getmonthlyReport() {
    return [
      // DetailedEngModel(
      //   siNo: 1,
      //   title: 'RFC Drawings of Civil Activities',
      //   number: 0,
      //   preparationDate: '',
      //   submissionDate: '',
      //   approveDate: '',
      //   releaseDate: '',
      // ),
      DetailedEngModel(
        siNo: 1,
        title: 'EV Layout',
        number: 12345,
        preparationDate: DateFormat().add_yMd().format(DateTime.now()),
        submissionDate: DateFormat().add_yMd().format(DateTime.now()),
        approveDate: DateFormat().add_yMd().format(DateTime.now()),
        releaseDate: DateFormat().add_yMd().format(DateTime.now()),
      ),
      // DetailedEngModel(
      //   siNo: 3,
      //   title: 'EV Layout Drawings of Electrical Activities',
      //   number: 0,
      //   preparationDate: '',
      //   submissionDate: '',
      //   approveDate: '',
      //   releaseDate: '',
      // ),
      // DetailedEngModel(
      //   siNo: 2,
      //   title: 'Electrical Work',
      //   number: 12345,
      //   preparationDate: DateFormat().add_yMd().format(DateTime.now()),
      //   submissionDate: DateFormat().add_yMd().format(DateTime.now()),
      //   approveDate: DateFormat().add_yMd().format(DateTime.now()),
      //   releaseDate: DateFormat().add_yMd().format(DateTime.now()),
      // ),
      // DetailedEngModel(
      //   siNo: 5,
      //   title: 'Shed Lighting Drawings & Specification',
      //   number: 0,
      //   preparationDate: '',
      //   submissionDate: '',
      //   approveDate: '',
      //   releaseDate: '',
      // ),
      // DetailedEngModel(
      //   siNo: 3,
      //   title: 'Illumination Design',
      //   number: 12345,
      //   preparationDate: DateFormat().add_yMd().format(DateTime.now()),
      //   submissionDate: DateFormat().add_yMd().format(DateTime.now()),
      //   approveDate: DateFormat().add_yMd().format(DateTime.now()),
      //   releaseDate: DateFormat().add_yMd().format(DateTime.now()),
      // ),
    ];
  }

  tabScreen() {
    return Scaffold(
        body: _isloading
            ? LoadingPage()
            : Column(children: [
                Expanded(
                    child: SfDataGridTheme(
                  data: SfDataGridThemeData(headerColor: blue),
                  child: StreamBuilder(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data.exists == false) {
                        return SfDataGrid(
                            source: _selectedIndex == 0
                                ? _detailedDataSource
                                : _detailedEngSourceev,
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
                                columnName: 'SiNo',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 80,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('SI No.',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'button',
                                width: 130,
                                allowEditing: false,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Upload Drawing ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ViewDrawing',
                                width: 130,
                                allowEditing: false,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('View Drawing ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Title',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 300,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Description',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Number',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 130,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Drawing Number',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'PreparationDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Preparation Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'SubmissionDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Submission Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ApproveDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Approve Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ReleaseDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Release Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Delete',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Delete Row',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ]);
                      } else {
                        alldata = '';
                        alldata = snapshot.data['data'] as List<dynamic>;
                        DetailedProject.clear();
                        alldata.forEach((element) {
                          DetailedProject.add(
                              DetailedEngModel.fromjsaon(element));
                          _detailedDataSource = DetailedEngSource(
                              DetailedProject,
                              context,
                              widget.cityName.toString(),
                              widget.depoName.toString(),
                              userId);
                          _dataGridController = DataGridController();
                        });

                        return SfDataGrid(
                            source: _selectedIndex == 0
                                ? _detailedDataSource
                                : _detailedEngSourceev,
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
                                columnName: 'SiNo',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 80,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('SI No.',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'button',
                                width: 130,
                                allowEditing: false,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Upload Drawing ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ViewDrawing',
                                width: 130,
                                allowEditing: false,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('View Drawing ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Title',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 300,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Description',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Number',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 130,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Drawing Number',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'PreparationDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Preparation Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'SubmissionDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Submission Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ApproveDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Approve Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ReleaseDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Release Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Delete',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Delete Row',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ]);
                      }
                    },
                  ),
                )),
              ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (() {
            DetailedProject.add(DetailedEngModel(
              siNo: 1,
              title: 'EV Layout',
              number: 12345,
              preparationDate: DateFormat().add_yMd().format(DateTime.now()),
              submissionDate: DateFormat().add_yMd().format(DateTime.now()),
              approveDate: DateFormat().add_yMd().format(DateTime.now()),
              releaseDate: DateFormat().add_yMd().format(DateTime.now()),
            ));
            _detailedDataSource.buildDataGridRows();
            _detailedDataSource.updateDatagridSource();
          }),
        ));
  }

  tabScreen1() {
    return Scaffold(
      body: _isloading
          ? LoadingPage()
          : Column(children: [
              Expanded(
                  child: SfDataGridTheme(
                data: SfDataGridThemeData(headerColor: blue),
                child: StreamBuilder(
                  stream: _stream1,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data.exists == false) {
                      return SfDataGrid(
                          source: _selectedIndex == 0
                              ? _detailedDataSource
                              : _detailedEngSourceev,
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
                              columnName: 'SiNo',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 80,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('SI No.',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'button',
                              width: 130,
                              allowEditing: false,
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text('Upload Drawing ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ViewDrawing',
                              width: 130,
                              allowEditing: false,
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text('View Drawing ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Title',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 300,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Description',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Number',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 130,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Drawing Number',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'PreparationDate',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              width: 170,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Preparation Date',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'SubmissionDate',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              width: 170,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Submission Date',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ApproveDate',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              width: 170,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Approve Date',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ReleaseDate',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              width: 170,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Release Date',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Delete',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Delete Row',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                          ]);
                    } else {
                      alldata = '';
                      alldata = snapshot.data['data'] as List<dynamic>;
                      DetailedProjectev.clear();
                      alldata.forEach((element) {
                        DetailedProjectev.add(
                            DetailedEngModel.fromjsaon(element));
                        _detailedEngSourceev = DetailedEngSourceEV(
                            DetailedProjectev,
                            context,
                            widget.cityName.toString(),
                            widget.depoName.toString(),
                            userId);
                        _dataGridController = DataGridController();
                      });

                      return SfDataGrid(
                          source: _selectedIndex == 0
                              ? _detailedDataSource
                              : _detailedEngSourceev,
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
                              columnName: 'SiNo',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 80,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('SI No.',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'button',
                              width: 130,
                              allowEditing: false,
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text('Upload Drawing ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ViewDrawing',
                              width: 130,
                              allowEditing: false,
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text('View Drawing ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Title',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 300,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Description',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Number',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 130,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Drawing Number',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'PreparationDate',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              width: 170,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Preparation Date',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'SubmissionDate',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              width: 170,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Submission Date',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ApproveDate',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              width: 170,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Approve Date',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ReleaseDate',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              width: 170,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Release Date',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Delete',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Delete Row',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: white)
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                          ]);
                    }
                  },
                ),
              )),
            ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (() {
          if (_selectedIndex == 0) {
            DetailedProjectev.add(DetailedEngModel(
              siNo: 1,
              title: 'EV Layout',
              number: 123456878,
              preparationDate: DateFormat().add_yMd().format(DateTime.now()),
              submissionDate: DateFormat().add_yMd().format(DateTime.now()),
              approveDate: DateFormat().add_yMd().format(DateTime.now()),
              releaseDate: DateFormat().add_yMd().format(DateTime.now()),
            ));
            _detailedDataSource.buildDataGridRows();
            _detailedDataSource.updateDatagridSource();
          }
          if (_selectedIndex == 1) {
            DetailedProjectev.add(DetailedEngModel(
              siNo: 1,
              title: 'EV Layout',
              number: 12345,
              preparationDate: DateFormat().add_yMd().format(DateTime.now()),
              submissionDate: DateFormat().add_yMd().format(DateTime.now()),
              approveDate: DateFormat().add_yMd().format(DateTime.now()),
              releaseDate: DateFormat().add_yMd().format(DateTime.now()),
            ));
            _detailedEngSourceev.buildDataGridRowsEV();
            _detailedEngSourceev.updateDatagridSource();
          }
        }),
      ),
    );
  }

  tabScreen2() {
    return Scaffold(
        body: _isloading
            ? LoadingPage()
            : Column(children: [
                Expanded(
                    child: SfDataGridTheme(
                  data: SfDataGridThemeData(headerColor: blue),
                  child: StreamBuilder(
                    stream: _stream2,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data.exists == false) {
                        return SfDataGrid(
                            source: _selectedIndex == 0
                                ? _detailedDataSource
                                : _detailedEngSourceShed,
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
                                columnName: 'SiNo',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 80,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('SI No.',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'button',
                                width: 130,
                                allowEditing: false,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Upload Drawing ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ViewDrawing',
                                width: 130,
                                allowEditing: false,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('View Drawing ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Title',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 300,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Description',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Number',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 130,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Drawing Number',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'PreparationDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Preparation Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'SubmissionDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Submission Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ApproveDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Approve Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ReleaseDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Release Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Delete',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Delete Row',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ]);
                      } else {
                        alldata = '';
                        alldata = snapshot.data['data'] as List<dynamic>;
                        DetailedProjectshed.clear();
                        alldata.forEach((element) {
                          DetailedProjectshed.add(
                              DetailedEngModel.fromjsaon(element));
                          _detailedEngSourceShed = DetailedEngSourceShed(
                              DetailedProjectshed,
                              context,
                              widget.cityName.toString(),
                              widget.depoName.toString(),
                              userId);
                          _dataGridController = DataGridController();
                        });

                        return SfDataGrid(
                            source: _selectedIndex == 0
                                ? _detailedDataSource
                                : _detailedEngSourceShed,
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
                                columnName: 'SiNo',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 80,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('SI No.',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'button',
                                width: 130,
                                allowEditing: false,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Upload Drawing ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ViewDrawing',
                                width: 130,
                                allowEditing: false,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('View Drawing ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Title',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 300,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Description',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Number',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                width: 130,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Drawing Number',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'PreparationDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Preparation Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'SubmissionDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Submission Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ApproveDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Approve Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ReleaseDate',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 170,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Release Date',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Delete',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Delete Row',
                                      overflow: TextOverflow.values.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: white)
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ]);
                      }
                    },
                  ),
                )),
              ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (() {
            DetailedProjectshed.add(DetailedEngModel(
              siNo: 1,
              title: 'EV Layout',
              number: 12345,
              preparationDate: DateFormat().add_yMd().format(DateTime.now()),
              submissionDate: DateFormat().add_yMd().format(DateTime.now()),
              approveDate: DateFormat().add_yMd().format(DateTime.now()),
              releaseDate: DateFormat().add_yMd().format(DateTime.now()),
            ));
            _detailedEngSourceShed.buildDataGridRowsEV();
            _detailedEngSourceShed.updateDatagridSource();
          }),
        ));
  }
}
