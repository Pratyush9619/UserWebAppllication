import 'package:assingment/model/employee.dart';
import 'package:assingment/KeysEvents/openpdf.dart';
import 'package:assingment/KeysEvents/upload.dart';
import 'package:assingment/components/loading_page.dart';
import 'package:assingment/overview/project_planning.dart';
import 'package:assingment/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../datasource/employee_datasouce.dart';

void main() {
  runApp(MyHomePage());
}

/// The application that contains datagrid on it.

/// The home page of the application which hosts the datagrid.
class MyHomePage extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? keyEvents;
  String? keyEvents2;

  /// Creates the home page.
  MyHomePage(
      {Key? key, this.cityName, this.depoName, this.keyEvents, this.keyEvents2})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isloading = false;
  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource;
  late DataGridController _dataGridController;
  Stream? _stream;
  var alldata;
  List<dynamic> tabledata2 = [];

  @override
  void initState() {
    _stream = FirebaseFirestore.instance
        .collection(widget.depoName!)
        .doc('${widget.depoName}${widget.keyEvents}')
        .snapshots();
    super.initState();

    // getFirestoreData().whenComplete(() {
    //   setState(() {
    //     employeeDataSource = EmployeeDataSource(employees);
    //     _dataGridController = DataGridController();
    //     _isloading = false;
    //   });
    // });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.cityName}/ ${widget.depoName}/ ${widget.keyEvents2}'),
        backgroundColor: blue,
        actions: [
          TextButton(
              onPressed: () {
                StoreData();
              },
              child: Text(
                'Sync Data',
                style: TextStyle(color: white),
              )),
        ],
        leading: InkWell(
            onTap: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back)),
      ),
      body: _isloading
          ? LoadingPage()
          : StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingPage();
                }
                if (!snapshot.hasData || snapshot.data.exists == false) {
                  return NodataAvailable();
                }
                // if (snapshot.hasData)
                else {
                  alldata = '';
                  alldata = snapshot.data['data'] as List<dynamic>;
                  employees.clear();
                  alldata.forEach((element) {
                    employees.add(Employee.fromJson(element));
                    employeeDataSource = EmployeeDataSource(employees, context,
                        widget.cityName.toString(), widget.depoName.toString());
                    _dataGridController = DataGridController();
                  });

                  return SfDataGrid(
                    source: employeeDataSource,
                    key: key,
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
                        allowEditing: false,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Sr No',
                            overflow: TextOverflow.values.first,
                            //    textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      GridColumn(
                        width: 200,
                        columnName: 'Activity',
                        allowEditing: false,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Activity',
                            overflow: TextOverflow.values.first,
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
                          child: const Text('Upload Checklist '),
                        ),
                      ),
                      GridColumn(
                        columnName: 'OriginalDuration',
                        allowEditing: false,
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Original Duration',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'StartDate',
                        allowEditing: false,
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Start Date',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'EndDate',
                        allowEditing: false,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'End Date',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'ActualStart',
                        allowEditing: false,
                        width: 180,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Actual Start',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'ActualEnd',
                        allowEditing: false,
                        width: 180,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Actual End',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'ActualDuration',
                        allowEditing: false,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Actual Duration',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Delay',
                        allowEditing: false,
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Delay',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Unit',
                        allowEditing: true,
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Unit',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'QtyScope',
                        allowEditing: true,
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Oty as per scope',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'QtyExecuted',
                        allowEditing: true,
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Qty executed',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'BalancedQty',
                        allowEditing: false,
                        label: Container(
                          width: 150,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Balanced Qty',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Progress',
                        allowEditing: false,
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            '% of Progress',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Weightage',
                        allowEditing: false,
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Weightage',
                            overflow: TextOverflow.values.first,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.refresh),
      //     onPressed: () {
      //       _isloading = false;
      //     })
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Future<void> getFirestoreData() async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    CollectionReference tabledata = instance.collection(widget.depoName!);

    DocumentSnapshot snapshot =
        await tabledata.doc('${widget.depoName}${widget.keyEvents}').get();
    var data = snapshot.data() as Map;
    var alldata = data['data'] as List<dynamic>;

    alldata.forEach((element) {
      employees.add(Employee.fromJson(element));
    });
  }

  void StoreData() {
    Map<String, dynamic> table_data = Map();
    for (var i in employeeDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button') {
          table_data[data.columnName] = data.value;
        }
      }

      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection(widget.depoName!)
        .doc('${widget.depoName}${widget.keyEvents}')
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();
      // Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  // List<Employee> getEmployeeData() {
  //   return [
  //     Employee(
  //         srNo: 1,
  //         activity: 'Initial Survey Of Depot With TML & STA Team.',
  //         originalDuration: 1,
  //         startDate: DateFormat().add_yMd().format(DateTime.now()),
  //         endDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualstartDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualendDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualDuration: 0,
  //         delay: 0,
  //         unit: 0,
  //         scope: 0,
  //         qtyExecuted: 0,
  //         balanceQty: 0,
  //         percProgress: 0,
  //         weightage: 0.5),
  //     Employee(
  //         srNo: 2,
  //         activity: 'Details Survey Of Depot With TPC Civil & Electrical Team',
  //         originalDuration: 1,
  //         startDate: DateFormat().add_yMd().format(DateTime.now()),
  //         endDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualstartDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualendDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualDuration: 0,
  //         delay: 0,
  //         unit: 0,
  //         scope: 0,
  //         qtyExecuted: 0,
  //         balanceQty: 0,
  //         percProgress: 0,
  //         weightage: 0.5),
  //     Employee(
  //         srNo: 3,
  //         activity:
  //             'Survey Report Submission With Existing & Proposed Layout Drawings.',
  //         originalDuration: 1,
  //         startDate: DateFormat().add_yMd().format(DateTime.now()),
  //         endDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualstartDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualendDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualDuration: 0,
  //         delay: 0,
  //         unit: 0,
  //         scope: 0,
  //         qtyExecuted: 0,
  //         balanceQty: 0,
  //         percProgress: 0,
  //         weightage: 0.5),
  //     Employee(
  //         srNo: 4,
  //         activity: 'Job Scope Finalization & Preparation Of BOQ',
  //         originalDuration: 1,
  //         startDate: DateFormat().add_yMd().format(DateTime.now()),
  //         endDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualstartDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualendDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualDuration: 0,
  //         delay: 0,
  //         unit: 0,
  //         scope: 0,
  //         qtyExecuted: 0,
  //         balanceQty: 0,
  //         percProgress: 0,
  //         weightage: 0.5),
  //     Employee(
  //         srNo: 5,
  //         activity: 'Power Connection / Load Applied By STA To Discom.',
  //         originalDuration: 1,
  //         startDate: DateFormat().add_yMd().format(DateTime.now()),
  //         endDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualstartDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualendDate: DateFormat().add_yMd().format(DateTime.now()),
  //         actualDuration: 0,
  //         delay: 0,
  //         unit: 0,
  //         scope: 0,
  //         qtyExecuted: 0,
  //         balanceQty: 0,
  //         percProgress: 0,
  //         weightage: 0.5)
  //   ];
  // }
}

// class Employee {
//   /// Creates the employee class with required details.
//   Employee({
//     required this.srNo,
//     required this.activity,
//     required this.originalDuration,
//     required this.startDate,
//     required this.endDate,
//     required this.actualstartDate,
//     required this.actualendDate,
//     required this.actualDuration,
//     required this.delay,
//     required this.unit,
//     required this.scope,
//     required this.qtyExecuted,
//     required this.balanceQty,
//     required this.percProgress,
//     required this.weightage,
//   });

//   int srNo;
//   String activity;
//   int originalDuration;
//   String? startDate;
//   String? endDate;
//   String? actualstartDate;
//   String? actualendDate;
//   int actualDuration;
//   int delay;
//   int unit;
//   int scope;
//   int qtyExecuted;
//   int balanceQty;
//   int percProgress;
//   double weightage;

//   factory Employee.fromJson(Map<String, dynamic> json) {
//     return Employee(
//         srNo: json['srNo'],
//         activity: json['Activity'],
//         originalDuration: json['OriginalDuration'],
//         startDate: json['StartDate'],
//         endDate: json['EndDate'],
//         actualstartDate: json['ActualStart'],
//         actualendDate: json['ActualEnd'],
//         actualDuration: json['ActuaslDuration'],
//         delay: json['Delay'],
//         unit: json['Unit'],
//         scope: json['QtyScope'],
//         qtyExecuted: json['QtyExecuted'],
//         balanceQty: json['BalancedQty'],
//         percProgress: json['Progress'],
//         weightage: json['Weightage']);
//   }
// }

// class EmployeeDataSource extends DataGridSource {
//   /// Creates the employee data source class with required details.
//   EmployeeDataSource({required List<Employee> employeeData}) {
//     _employeeData = employeeData
//         .map<DataGridRow>((e) => DataGridRow(cells: [
//               DataGridCell(columnName: 'srNo', value: e.srNo),
//               DataGridCell<String>(columnName: 'Activity', value: e.activity),
//               const DataGridCell<Widget>(columnName: 'button', value: null),
//               DataGridCell<int>(
//                   columnName: 'OriginalDuration', value: e.originalDuration),
//               DataGridCell<String>(columnName: 'StartDate', value: e.startDate),
//               DataGridCell<String>(columnName: 'EndDate', value: e.endDate),
//               DataGridCell<String>(
//                   columnName: 'ActualStart', value: e.actualstartDate),
//               DataGridCell<String>(
//                   columnName: 'ActualEnd', value: e.actualendDate),
//               DataGridCell<int>(
//                   columnName: 'ActuaslDuration', value: e.actualDuration),
//               DataGridCell<int>(columnName: 'Delay', value: e.delay),
//               DataGridCell<int>(columnName: 'Unit', value: e.unit),
//               DataGridCell<int>(columnName: 'QtyScope', value: e.scope),
//               DataGridCell<int>(
//                   columnName: 'QtyExecuted', value: e.qtyExecuted),
//               DataGridCell<int>(columnName: 'BalancedQty', value: e.balanceQty),
//               DataGridCell<int>(columnName: 'Progress', value: e.percProgress),
//               DataGridCell<double>(columnName: 'Weightage', value: e.weightage),
//             ]))
//         .toList();
//   }

//   List<DataGridRow> _employeeData = [];

//   @override
//   List<DataGridRow> get rows => _employeeData;

//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((e) {
//       return Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.all(8.0),
//         child: e.columnName == 'button'
//             ? LayoutBuilder(
//                 builder: (BuildContext context, BoxConstraints constraints) {
//                 return ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => UploadDocument(
//                             activity: '${row.getCells()[1].value.toString()}'),
//                       ));
//                       // showDialog(
//                       //     context: context,
//                       //     builder: (context) => AlertDialog(
//                       //         content: SizedBox(
//                       //             height: 100,
//                       //             child: Column(
//                       //               mainAxisAlignment:
//                       //                   MainAxisAlignment.spaceBetween,
//                       //               children: [
//                       //                 Text(
//                       //                     'Employee ID: ${row.getCells()[0].value.toString()}'),
//                       //                 Text(
//                       //                     'Employee Name: ${row.getCells()[1].value.toString()}'),
//                       //                 Text(
//                       //                     'Employee Designation: ${row.getCells()[2].value.toString()}'),
//                       //               ],
//                       //             ))));
//                     },
//                     child: const Text('Upload'));
//               })
//             : Text(e.value.toString()),
//       );
//     }).toList());
//   }

NodataAvailable() {
  return Center(
      child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      padding: EdgeInsets.all(10),
      height: 1000,
      width: 1000,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: blue)),
      child: Column(children: [
        Image.asset(
          'assets/Tata-Power.jpeg',
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/sustainable.jpeg',
              height: 100,
              width: 100,
            ),
            SizedBox(width: 50),
            Image.asset(
              'assets/Green.jpeg',
              height: 100,
              width: 100,
            )
          ],
        ),
        const SizedBox(height: 50),
        Center(
          child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: blue)),
            child: const Text(
              '     No data available yet \n Please wait for admin process',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ]),
    ),
  )
      // Text(
      //   "No Depot Available at This Time....",
      //   style: TextStyle(color: black),
      // ),
      );
}
