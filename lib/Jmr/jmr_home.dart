import 'package:assingment/components/loading_page.dart';
import 'package:assingment/model/jmr.dart';
import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../datasource/jmr_datasource.dart';

class JMRPage extends StatefulWidget {
  String? title;
  String? img;
  JMRPage({super.key, this.title, this.img});

  @override
  State<JMRPage> createState() => _JMRPageState();
}

class _JMRPageState extends State<JMRPage> {
  List<JMRModel> jmrtable = <JMRModel>[];
  late JmrDataSource _jmrDataSource;
  late DataGridController _dataGridController;
  bool _isloading = true;
  Stream? _stream;

  @override
  void initState() {
    _isloading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title.toString()),
          backgroundColor: blue,
        ),
        body: _isloading
            ? LoadingPage()
            : StreamBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SfDataGrid(
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
                          allowEditing: false,
                          label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                          columnName: 'Description',
                          allowEditing: false,
                          label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Description of items',
                              overflow: TextOverflow.values.first,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Activity',
                          width: 130,
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('Activity Details '),
                          ),
                        ),
                        GridColumn(
                          columnName: 'RefNo',
                          allowEditing: false,
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text(
                              'BOQ RefNo',
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Actual Start',
                              overflow: TextOverflow.values.first,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'ActualEnd',
                          allowEditing: true,
                          width: 180,
                          label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                  } else {
                    return SfDataGrid(
                      source: _jmrDataSource,
                      // key: key,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Actual Start',
                              overflow: TextOverflow.values.first,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'ActualEnd',
                          allowEditing: true,
                          width: 180,
                          label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                },
              )

        //   Center(
        // child: Image.asset(widget.img.toString()),
        );
  }
}
