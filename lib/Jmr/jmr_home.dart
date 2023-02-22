import 'package:assingment/components/loading_page.dart';
import 'package:assingment/model/jmr.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../KeysEvents/Grid_DataTable.dart';
import '../datasource/jmr_datasource.dart';
import '../widget/custom_appbar.dart';

class JMRPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? title;
  String? title1;
  String? img;
  JMRPage(
      {super.key,
      this.title,
      this.img,
      this.cityName,
      this.depoName,
      this.title1});

  @override
  State<JMRPage> createState() => _JMRPageState();
}

class _JMRPageState extends State<JMRPage> {
  List<JMRModel> jmrtable = <JMRModel>[];
  late JmrDataSource _jmrDataSource;
  late DataGridController _dataGridController;
  bool _isloading = true;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  var alldata;

  @override
  void initState() {
    _isloading = false;
    _stream = FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc('${widget.depoName}${widget.title1}')
        .snapshots();
    jmrtable = getData();
    _jmrDataSource = JmrDataSource(jmrtable);
    _dataGridController = DataGridController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: CustomAppBar(
              text: widget.title.toString(),
              // icon: Icons.logout,
              haveSynced: true,
              store: () {
                StoreData();
              }),
          preferredSize: Size.fromHeight(50),
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
                            width: 200,
                            columnName: 'Description',
                            allowEditing: true,
                            label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                            columnName: 'Abstract',
                            allowEditing: true,
                            width: 180,
                            label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              alignment: Alignment.center,
                              child: Text('Amount',
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
                    jmrtable.clear();
                    alldata.forEach((element) {
                      jmrtable.add(JMRModel.fromjson(element));
                      _jmrDataSource = JmrDataSource(jmrtable);
                      _dataGridController = DataGridController();
                    });
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
                            width: 200,
                            columnName: 'Description',
                            allowEditing: true,
                            label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                            columnName: 'Abstract',
                            allowEditing: true,
                            width: 180,
                            label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              alignment: Alignment.center,
                              child: Text('Amount',
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
                                columnNames: ['srNo', 'Description'],
                                child: Container(child: Text('Project')))
                          ])
                        ],
                      ),
                    );
                  } else {
                    return NodataAvailable();
                  }
                },
              )

        //   Center(
        // child: Image.asset(widget.img.toString()),
        );
  }

  void StoreData() {
    Map<String, dynamic> table_data = Map();
    for (var i in _jmrDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        // if (data.columnName != 'button') {
        table_data[data.columnName] = data.value;
        // }
      }

      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc('${widget.depoName}${widget.title1}')
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
}

List<JMRModel> getData() {
  return [
    JMRModel(
        srNo: 1,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 2,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 3,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 4,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 5,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 6,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 7,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 8,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 9,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 10,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 11,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 12,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 13,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 14,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 15,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 16,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
    JMRModel(
        srNo: 17,
        Description: 'Supply and Laying',
        Activity: 'onboarding one no. of EV charger of 200kw',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'bstract of JMR sheet No 1 & Item Sr No 1',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
  ];
}
