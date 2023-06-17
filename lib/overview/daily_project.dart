import 'package:assingment/datasource/dailyproject_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Authentication/auth_service.dart';
import '../Planning_Pages/summary.dart';
import '../components/loading_page.dart';
import '../model/daily_projectModel.dart';
import '../widget/custom_appbar.dart';
import '../widget/style.dart';

class DailyProject extends StatefulWidget {
  String? cityName;
  String? depoName;
  DailyProject({super.key, required this.cityName, required this.depoName});

  @override
  State<DailyProject> createState() => _DailyProjectState();
}

class _DailyProjectState extends State<DailyProject> {
  List<DailyProjectModel> dailyproject = <DailyProjectModel>[];
  late DailyDataSource _dailyDataSource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  var alldata;
  dynamic userId;
  bool _isloading = true;

  @override
  void initState() {
    dailyproject = getmonthlyReport();
    _dailyDataSource = DailyDataSource(dailyproject, context, widget.depoName!);
    _dataGridController = DataGridController();

    print(CustomAppBar().text);
    getUserId().whenComplete(() {
      getmonthlyReport();
      dailyproject = getmonthlyReport();
      _dailyDataSource =
          DailyDataSource(dailyproject, context, widget.depoName!);
      _dataGridController = DataGridController();

      _stream = FirebaseFirestore.instance
          .collection('DailyProjectReport')
          .doc('${widget.depoName}')
          .collection(userId)
          .doc(DateFormat.yMMMMd().format(DateTime.now()))
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
            text: ' ${widget.cityName}/ ${widget.depoName} / Daily Report',
            //  ${DateFormat.yMMMMd().format(DateTime.now())}',
            haveSynced: true,
            haveSummary: true,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewSummary(
                    cityName: widget.cityName.toString(),
                    depoName: widget.depoName.toString(),
                    id: 'Daily Report',
                    userId: userId,
                  ),
                )),
            store: () {
              _showDialog(context);
              storeData();
            },
          ),
          preferredSize: const Size.fromHeight(50)),
      body: _isloading
          ? LoadingPage()
          : Column(children: [
              Expanded(
                  child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingPage();
                  } else if (!snapshot.hasData ||
                      snapshot.data.exists == false) {
                    return SfDataGridTheme(
                      data: SfDataGridThemeData(headerColor: lightblue),
                      child: SfDataGrid(
                          source: _dailyDataSource,
                          allowEditing: true,
                          frozenColumnsCount: 2,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.cell,
                          columnWidthMode: ColumnWidthMode.fitByCellValue,
                          editingGestureType: EditingGestureType.tap,
                          controller: _dataGridController,
                          columns: [
                            GridColumn(
                              columnName: 'SiNo',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 70,
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
                            // GridColumn(
                            //   columnName: 'Date',
                            //   autoFitPadding:
                            //       const EdgeInsets.symmetric(horizontal: 16),
                            //   allowEditing: false,
                            //   width: 160,
                            //   label: Container(
                            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //     alignment: Alignment.center,
                            //     child: Text('Date',
                            //         textAlign: TextAlign.center,
                            //         overflow: TextOverflow.values.first,
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 16,
                            //             color: white)),
                            //   ),
                            // ),
                            // GridColumn(
                            //   visible: false,
                            //   columnName: 'State',
                            //   autoFitPadding:
                            //       const EdgeInsets.symmetric(horizontal: 16),
                            //   allowEditing: true,
                            //   width: 120,
                            //   label: Container(
                            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //     alignment: Alignment.center,
                            //     child: Text('State',
                            //         textAlign: TextAlign.center,
                            //         overflow: TextOverflow.values.first,
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 16,
                            //             color: white)
                            //         //    textAlign: TextAlign.center,
                            //         ),
                            //   ),
                            // ),
                            // GridColumn(
                            //   visible: false,
                            //   columnName: 'DepotName',
                            //   autoFitPadding:
                            //       const EdgeInsets.symmetric(horizontal: 16),
                            //   allowEditing: true,
                            //   width: 150,
                            //   label: Container(
                            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //     alignment: Alignment.center,
                            //     child: Text('Depot Name',
                            //         overflow: TextOverflow.values.first,
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 16,
                            //             color: white)
                            //         //    textAlign: TextAlign.center,
                            //         ),
                            //   ),
                            // ),
                            GridColumn(
                              columnName: 'TypeOfActivity',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 200,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Type of Activity',
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
                              columnName: 'ActivityDetails',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 220,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Activity Details',
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
                              columnName: 'Progress',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              columnWidthMode: ColumnWidthMode.fill,
                              // width: 320,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Progress',
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
                              columnName: 'Status',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 320,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Remark / Status',
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
                          ]),
                    );
                  } else {
                    alldata = '';
                    alldata = snapshot.data['data'] as List<dynamic>;
                    dailyproject.clear();
                    alldata.forEach((element) {
                      dailyproject.add(DailyProjectModel.fromjson(element));
                      _dailyDataSource = DailyDataSource(
                          dailyproject, context, widget.depoName!);
                      _dataGridController = DataGridController();
                    });
                    return SfDataGridTheme(
                      data: SfDataGridThemeData(headerColor: lightblue),
                      child: SfDataGrid(
                          source: _dailyDataSource,
                          allowEditing: true,
                          frozenColumnsCount: 2,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.cell,
                          editingGestureType: EditingGestureType.tap,
                          controller: _dataGridController,
                          columns: [
                            GridColumn(
                              columnName: 'SiNo',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 70,
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
                              columnName: 'TypeOfActivity',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 200,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Type of Activity',
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
                              columnName: 'ActivityDetails',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 220,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Activity Details',
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
                              columnName: 'Progress',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 320,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Progress',
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
                              columnName: 'Status',
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: true,
                              width: 320,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Remark / Status',
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
                          ]),
                    );
                  }
                },
              ))
            ]),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (() {
            dailyproject.add(DailyProjectModel(
                siNo: 1,
                // date: DateFormat().add_yMd(storeData()).format(DateTime.now()),
                // state: "Maharashtra",
                // depotName: 'depotName',
                typeOfActivity: 'Electrical Infra',
                activityDetails: "Initial Survey of DEpot",
                progress: '',
                status: ''));
            _dailyDataSource.buildDataGridRows();
            _dailyDataSource.updateDatagridSource();
          })),
    );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  void storeData() {
    Map<String, dynamic> tableData = Map();
    for (var i in _dailyDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' && data.columnName != 'Delete') {
          tableData[data.columnName] = data.value;
        }
      }

      tabledata2.add(tableData);
      tableData = {};
    }

    FirebaseFirestore.instance
        .collection('DailyProjectReport')
        .doc('${widget.depoName}')
        .collection(userId)
        .doc(DateFormat.yMMMMd().format(DateTime.now()))
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  List<DailyProjectModel> getmonthlyReport() {
    return [
      DailyProjectModel(
          siNo: 1,
          // date: DateFormat().add_yMd().format(DateTime.now()),
          // state: "Maharashtra",
          // depotName: 'depotName',
          typeOfActivity: 'Electrical Infra',
          activityDetails: "Initial Survey of Depot",
          progress: '',
          status: '')
    ];
  }

  void _showDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(
              color: blue,
            ),
          ),
        ),
      ),
    );
  }
}
