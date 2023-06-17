import 'dart:html';
import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:assingment/components/loading_page.dart';
import 'package:assingment/model/jmr.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Authentication/auth_service.dart';
import '../datasource/jmr_datasource.dart';
import '../widget/custom_appbar.dart';
import '../widget/nodata_available.dart';

class JMRPage extends StatefulWidget {
  int? jmrViewLen;
  String? cityName;
  String? depoName;
  String? title;
  String? title1;
  final bool isCreateJmr;

  JMRPage(
      {super.key,
        this.title,
        // this.img,
        this.cityName,
        this.depoName,
        this.title1,
      required this.isCreateJmr,
        this.jmrViewLen
      });

  @override
  State<JMRPage> createState() => _JMRPageState();
}

class _JMRPageState extends State<JMRPage> {
  List<int> jmrListLen = [] ;
  int finalLength = 0;
  //List for storing number of times sync button clicked
  late List<dynamic> jmrSyncList ;

  List<List<dynamic>> data = [
    [1,'Supply and Laying','onboarding one no. of EV charger of 200kw','8.31','abstract of JMR sheet No 1 & Item Sr No 1','Mtr',500,300,25000],
  ];

  List<JMRModel> jmrtable = <JMRModel>[];
  late JmrDataSource _jmrDataSource;
  late DataGridController _dataGridController;
  bool _isloading = true;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  var alldata;
  dynamic userId;


  @override
  void initState() {
    getUserId().whenComplete(() {
      _stream = FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('${widget.depoName}${widget.title1}')
          .doc(userId)
          .snapshots();
      _isloading = false;
      setState(() {
        if(widget.isCreateJmr){
            _fetchDataFromFirestore().then((value) => {
              setState(() {
                for (dynamic item in jmrSyncList) {
                  List<dynamic> tempData = [];
                  if (item is List<dynamic>) {
                    for (dynamic innerItem in item) {
                      if (innerItem is Map<String, dynamic>) {
                        tempData = [
                          innerItem['srNo'],
                          innerItem['Description'],
                          innerItem['Activity'],
                          innerItem['RefNo'],
                          innerItem['Abstract'],
                          innerItem['Uom'],
                          innerItem['Rate'],
                          innerItem['TotalQty'],
                          innerItem['TotalAmount']
                        ];
                      }
                      data.add(tempData);
                    }
                    print(data);
                  }
                }
              })
            });
        }
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: CustomAppBar(
            text:
            '${widget.cityName} / ${widget.depoName} / ${widget.title.toString()}',
            // icon: Icons.logout,
            haveSynced: true,
            store: () {
              firestoreListLen().then((value) => {
              StoreData()
              });
            }
            ),
        preferredSize: const Size.fromHeight(50),
      ),
      body: _isloading
          ? LoadingPage()
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    HeaderValue('Project', 'TML e-bus Project'),
                    HeaderValue('LOI Ref Number', 'TML-LOI-Dated'),
                    HeaderValue('Site Location', ''),
                    // HeaderValue('Working Period')
                    Container(
                      width: 600,
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 50,),
                          const SizedBox(
                              width: 110,
                              child: Text('Working Dates')),
                          Expanded(
                              child: TextFormField(
                                scrollPadding: const EdgeInsets.all(0),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(5.0),
                                ),
                              ),),
                          const SizedBox(width: 10),
                          Expanded(
                              child: TextFormField(
                                scrollPadding: const EdgeInsets.all(0),
                                decoration: const InputDecoration(
                                    contentPadding:
                                    EdgeInsets.only(top: 0, bottom: 0)),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    HeaderValue('Ref No', 'Abstract of Cost/1'),
                    HeaderValue('Date', ''),
                    HeaderValue('Note', ''),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height:10 ,
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.99,
              child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingPage();
                  }
                  if (!snapshot.hasData) {
                    jmrtable = getData();
                    _jmrDataSource = JmrDataSource(jmrtable);
                    _dataGridController = DataGridController();
                    return SfDataGridTheme(
                      data: SfDataGridThemeData(headerColor: blue),
                      child: SfDataGrid(
                        source: _jmrDataSource,
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
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
                            columnName: 'Description',
                            allowEditing: true,
                            label: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
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
                            columnName: 'Activity',
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
                            columnName: 'RefNo',
                            allowEditing: true,
                            label: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
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
                            columnName: 'Abstract',
                            allowEditing: true,
                            width: 180,
                            label: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
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
                            columnName: 'UOM',
                            allowEditing: true,
                            width: 80,
                            label: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              alignment: Alignment.center,
                              child: Text('UOM',
                                  overflow: TextOverflow.values.first,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: white)),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Rate',
                            allowEditing: true,
                            width: 80,
                            label: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              alignment: Alignment.center,
                              child: Text('Rate',
                                  overflow: TextOverflow.values.first,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: white)),
                            ),
                          ),
                          GridColumn(
                            columnName: 'TotalQty',
                            allowEditing: true,
                            width: 120,
                            label: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              alignment: Alignment.center,
                              child: Text('Total Qty',
                                  overflow: TextOverflow.values.first,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: white)),
                            ),
                          ),
                          GridColumn(
                            columnName: 'TotalAmount',
                            allowEditing: true,
                            label: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              alignment: Alignment.center,
                              child: Text('Amount',
                                  overflow: TextOverflow.values.first,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: white)),
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
                    // alldata = '';
                    // alldata = snapshot.data['data'] as List<dynamic>;
                    // jmrtable.clear();
                    jmrtable = convertListToJmrModel(data);
                    _jmrDataSource = JmrDataSource(jmrtable);
                    _dataGridController = DataGridController();
                    // alldata.forEach((element) {
                    //   jmrtable.add(JMRModel.fromjson(element));
                    //   _jmrDataSource = JmrDataSource(jmrtable);
                    //   _dataGridController = DataGridController();
                    // });

                    return SfDataGridTheme(
                      data: SfDataGridThemeData(headerColor: blue),
                      child: SfDataGrid(
                        source: _jmrDataSource,
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
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
                            columnName: 'Description',
                            allowEditing: true,
                            label: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
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
                            columnName: 'Activity',
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
                            columnName: 'RefNo',
                            allowEditing: true,
                            label: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
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
                            columnName: 'Abstract',
                            allowEditing: true,
                            width: 180,
                            label: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
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
                            columnName: 'UOM',
                            allowEditing: true,
                            width: 80,
                            label: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              alignment: Alignment.center,
                              child: Text('UOM',
                                  overflow: TextOverflow.values.first,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: white)),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Rate',
                            allowEditing: true,
                            width: 80,
                            label: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              alignment: Alignment.center,
                              child: Text('Rate',
                                  overflow: TextOverflow.values.first,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: white)),
                            ),
                          ),
                          GridColumn(
                            columnName: 'TotalQty',
                            allowEditing: true,
                            width: 120,
                            label: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              alignment: Alignment.center,
                              child: Text('Total Qty',
                                  overflow: TextOverflow.values.first,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: white)),
                            ),
                          ),
                          GridColumn(
                            columnName: 'TotalAmount',
                            allowEditing: true,
                            label: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              alignment: Alignment.center,
                              child: Text('Amount',
                                  overflow: TextOverflow.values.first,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: white)),
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
                        ],
                        // stackedHeaderRows: [
                        //   StackedHeaderRow(cells: [
                        //     StackedHeaderCell(
                        //         columnNames: ['srNo'],
                        //         child: Container(
                        //           child: Center(
                        //             child: Text(
                        //               'Project',
                        //               style: TextStyle(
                        //                   color: white,
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //           ),
                        //         )),
                        //     StackedHeaderCell(
                        //       columnNames: ['Description', 'Activity'],
                        //       child: Center(
                        //         child: Text(
                        //           'TML e-bus Project',
                        //           style: TextStyle(
                        //               color: white,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //       ),
                        //     ),
                        //     StackedHeaderCell(
                        //       columnNames: ['RefNo'],
                        //       child: Center(
                        //         child: Text(
                        //           'Ref No',
                        //           style: TextStyle(
                        //               color: white,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //       ),
                        //     ),
                        //     StackedHeaderCell(
                        //       columnNames: [
                        //         'RefNo',
                        //         'Abstract',
                        //         'UOM',
                        //         'Rate',
                        //         'TotalQty',
                        //         'TotalAmount'
                        //       ],
                        //       child: Center(
                        //         child: Text(
                        //           'TML e-bus Project',
                        //           style: TextStyle(
                        //               color: white,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //       ),
                        //     )
                        //   ]),
                        // ],

                        // // stackedHeaderRows: [
                        //   StackedHeaderRow(cells: [
                        //     StackedHeaderCell(
                        //         columnNames: ['srNo'],
                        //         child: Container(child: Text('Project'))),
                        //     // StackedHeaderCell(columnNames: [
                        //     //   'srNo'
                        //     // ], child: Container(child: Text('LOI Ref Number'))),
                        //     StackedHeaderCell(
                        //         columnNames: ['Description', 'Activity'],
                        //         child: Container(
                        //             child: Center(
                        //                 child: Text('TML E-BUS PROJECT')))),
                        //     StackedHeaderCell(columnNames: [
                        //       'srNo'
                        //     ], child: Container(child: Text('Working Period'))),
                        //   ])
                        // ],
                      ),
                    );
                  } else {
                    return const NodataAvailable();
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 80, right: 20),
            child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    jmrSyncList.add(
                      JMRModel(
                          srNo: 1,
                          Description: 'Supply and Laying',
                          Activity:
                          'onboarding one no. of EV charger of 200kw',
                          RefNo: '8.31 (Additional)',
                          JmrAbstract:
                          'abstract of JMR sheet No 1 & Item Sr No 1',
                          Uom: 'Mtr',
                          rate: 500.00,
                          TotalQty: 110,
                          TotalAmount: 55000.00),
                    );
                    _jmrDataSource.buildDataGridRows();
                    _jmrDataSource.updateDatagridSource();
                  },
                  child: const Icon(Icons.add),
                )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "btn2",
        isExtended: true,
        onPressed: (){
          selectExcelFile().then((value){
            setState(() {

            });
          });
        },
        label: const Text('Upload Excel For Data'),
      ),

      //   Center(
      // child: Image.asset(widget.img.toString()),
    );
  }

  Future<List<List<dynamic>>> selectExcelFile() async {
    final input = FileUploadInputElement()..accept = '.xlsx';
    input.click();

    await input.onChange.first;
    final files = input.files;

    if (files?.length == 1) {
      final file = files?[0];
      final reader = FileReader();

      reader.readAsArrayBuffer(file!);

      await reader.onLoadEnd.first;


      final excel = Excel.decodeBytes(reader.result as List<int>);
      for(var table in excel.tables.keys){
        final sheet = excel.tables[table];
        for(var rows in sheet!.rows.skip(1)){
          List<dynamic> rowData = [];
          for(var cell in rows){
            rowData.add(cell?.value);
          }
          data.add(rowData);
        }
      }
      data = convertSubstringsToStrings(data);
    }
    return data;
  }

  List<List<dynamic>> convertSubstringsToStrings(List<List<dynamic>> listOfLists) {
    List<List<dynamic>> result = [];

    for (List<dynamic> sublist in listOfLists) {
      List<dynamic> convertedSublist = sublist.map((item) => item.toString()).toList();
      result.add(convertedSublist);
    }
    return result;
  }

  List<JMRModel> convertListToJmrModel(List<List<dynamic>> data){
  return data.map((list){
    return JMRModel(
        srNo: list[0],
        Description: list[1],
        Activity: list[2],
        RefNo: list[3],
        JmrAbstract: list[4],
        Uom: list[5],
        rate: list[6],
        TotalQty: list[7],
        TotalAmount: list[8]);
  }).toList();
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value){
      userId = value;
    });
  }

  Future<void> firestoreListLen() async{
    CollectionReference collectionReference =  FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('${widget.depoName}${widget.title1}')
        .doc('ZW3210')
        .collection('JM${widget.title1}');
    QuerySnapshot querySnapshot = await collectionReference.get();
    jmrListLen.add(querySnapshot.docs.length);
      finalLength = jmrListLen[0] + 1;
    //Clearing Length of JMR list
    jmrListLen.clear();
  }


  Future<void> StoreData() async {

    Map<String, dynamic> tableData = {};
    for (var i in _jmrDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        // if (data.columnName != 'button') {
        tableData[data.columnName] = data.value;
        // }
      }
      tabledata2.add(tableData);
      tableData = {};
    }

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('${widget.depoName}${widget.title1}')
        .doc(userId)
        .collection('JM${widget.title1}').doc('JMR${finalLength}List')
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



  //Function to fetch data and show in JMR view

  Future<List<dynamic>> _fetchDataFromFirestore() async {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('${widget.depoName}${widget.title1}')
          .doc(userId)
          .collection('JM${widget.title1}')
          .doc('JMR${widget.jmrViewLen}List').get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data1 = documentSnapshot.data() as Map<String, dynamic>?;
        setState(() {
          jmrSyncList = data1!.entries.map((entry) => entry.value).toList();
        });
        return jmrSyncList;
      }
      else{
        return jmrSyncList;
      }
  }


}



List<JMRModel> getData() {
  return [
    JMRModel(
        srNo: 1,
        Description: 'Supply and Laying',
        Activity: 'Software',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'Dumble Door',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 2,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 3,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 4,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 5,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'abstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 6,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 7,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 8,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 9,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 10,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 11,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 12,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 13,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 14,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 15,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 16,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
    // JMRModel(
    //     srNo: 17,
    //     Description: 'Supply and Laying',
    //     Activity: 'onboarding one no. of EV charger of 200kw',
    //     RefNo: '8.31 (Additional)',
    //     JmrAbstract: 'abstract of JMR sheet No 1 & Item Sr No 1',
    //     Uom: 'Mtr',
    //     rate: 500.00,
    //     TotalQty: 110,
    //     TotalAmount: 55000.00),
  ];
}

HeaderValue(String title, String hintValue) {
  return Container(
    width: 500,
    padding: const EdgeInsets.all(3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
            width: 100,
            child: Text(
              title,
            )),
        const SizedBox(width: 15),
        Expanded(
            child: TextFormField(
              decoration:  const InputDecoration(
                  contentPadding: EdgeInsets.all(5.0),
              ),
              initialValue: hintValue,
              style: const TextStyle(fontSize: 14),
            ),
        ),
      ],
    ),
  );
}