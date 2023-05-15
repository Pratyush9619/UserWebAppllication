import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../KeysEvents/upload.dart';
import '../model/employee_statutory.dart';

class EmployeeStatutoryDataSource extends DataGridSource {
  String? cityName;
  String? depoName;
  BuildContext mainContext;
  String? userId;

  /// Creates the employee data source class with required details.
  EmployeeStatutoryDataSource(
      {required this.employeeData,
      required this.mainContext,
      this.cityName,
      this.depoName,
      this.userId}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'srNo', value: e.srNo),
              DataGridCell<String>(columnName: 'Approval', value: e.approval),
              const DataGridCell<Widget>(columnName: 'button', value: null),
              DataGridCell<String>(columnName: 'StartDate', value: e.startDate),
              DataGridCell<String>(columnName: 'EndDate', value: e.endDate),
              DataGridCell<String>(
                  columnName: 'ActualStart', value: e.actualstartDate),
              DataGridCell<String>(
                  columnName: 'ActualEnd', value: e.actualendDate),
              // DataGridCell<double>(columnName: 'Weightage', value: e.weightage),
              DataGridCell<String>(
                  columnName: 'Applicability', value: e.applicability),
              DataGridCell<String>(
                  columnName: 'ApprovingAuthority',
                  value: e.approvingAuthority),
              DataGridCell<int>(
                  columnName: 'CurrentStatusPerc', value: e.currentStatusPerc),
              DataGridCell<int>(
                  columnName: 'OverallWeightage', value: e.overallWeightage),
              DataGridCell<String>(
                  columnName: 'CurrentStatus', value: e.currentStatus),
              DataGridCell<String>(
                  columnName: 'ListDocument', value: e.listDocument),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];
  List<EmployeeStatutory> employeeData;

  @override
  List<DataGridRow> get rows => _employeeData;
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    DateTime? rangeStartDate = DateTime.now();
    DateTime? rangeEndDate = DateTime.now();
    DateTime? date;
    DateTime? endDate;
    DateTime? rangeStartDate1 = DateTime.now();
    DateTime? rangeEndDate1 = DateTime.now();
    DateTime? date1;
    DateTime? endDate1;
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell dataGridCell) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: dataGridCell.columnName == 'button'
            ? LayoutBuilder(
                builder: (BuildContext ctx, BoxConstraints constraints) {
                return ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).push(MaterialPageRoute(
                        builder: (context) => UploadDocument(
                            userId: userId,
                            title: 'checklist',
                            cityName: cityName,
                            depoName: depoName,
                            activity: '${row.getCells()[1].value.toString()}'),
                      ));
                      // showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //         content: SizedBox(
                      //             height: 100,
                      //             child: Column(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Text(
                      //                     'Employee ID: ${row.getCells()[0].value.toString()}'),
                      //                 Text(
                      //                     'Employee Name: ${row.getCells()[1].value.toString()}'),
                      //                 Text(
                      //                     'Employee Designation: ${row.getCells()[2].value.toString()}'),
                      //               ],
                      //             ))));
                    },
                    child: const Text('Upload'));
              })
            : (dataGridCell.columnName == 'ActualStart')
                ? Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: mainContext,
                            builder: (context) => AlertDialog(
                                title: const Text('All Date'),
                                content: Container(
                                  height: 400,
                                  width: 500,
                                  child: SfDateRangePicker(
                                    view: DateRangePickerView.month,
                                    showTodayButton: true,
                                    onSelectionChanged:
                                        (DateRangePickerSelectionChangedArgs
                                            args) {
                                      if (args.value is PickerDateRange) {
                                        rangeStartDate = args.value.startDate;
                                        rangeEndDate = args.value.endDate;
                                      } else {
                                        final List<PickerDateRange>
                                            selectedRanges = args.value;
                                      }
                                    },
                                    selectionMode:
                                        DateRangePickerSelectionMode.range,
                                    showActionButtons: true,
                                    onSubmit: ((value) {
                                      date = DateTime.parse(
                                          rangeStartDate.toString());

                                      endDate = DateTime.parse(
                                          rangeEndDate.toString());

                                      Duration diff =
                                          endDate!.difference(date!);

                                      print('Difference' +
                                          diff.inDays.toString());

                                      final int dataRowIndex =
                                          _employeeData.indexOf(row);
                                      if (dataRowIndex != null) {
                                        employeeData[dataRowIndex]
                                                .actualstartDate =
                                            DateFormat('dd-MM-yyyy')
                                                .format(date!);

                                        _employeeData[dataRowIndex] =
                                            DataGridRow(cells: [
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .srNo,
                                              columnName: 'srNo'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .approval,
                                              columnName: 'Approval'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex],
                                              columnName: 'button'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .startDate,
                                              columnName: 'StartDate'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .endDate,
                                              columnName: 'EndDate'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .actualstartDate,
                                              columnName: 'ActualStart'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .actualendDate,
                                              columnName: 'ActualEnd'),
                                          // DataGridCell(
                                          //     value: employeeData[dataRowIndex]
                                          //         .weightage,
                                          //     columnName: 'Weightage'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .applicability,
                                              columnName: 'Applicability'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .approvingAuthority,
                                              columnName: 'ApprovingAuthority'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .currentStatusPerc,
                                              columnName: 'CurrentStatusPerc'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .overallWeightage,
                                              columnName: 'OverallWeightage'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .currentStatus,
                                              columnName: 'CurrentStatus'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .listDocument,
                                              columnName: 'ListDocument'),
                                        ]);

                                        updateDataGrid(
                                            rowColumnIndex: RowColumnIndex(
                                                dataRowIndex, 5));
                                        notifyListeners();
                                        print('state$date');
                                        print('valuedata$value');

                                        print('start $rangeStartDate');
                                        print('End $rangeEndDate');
                                        // date = rangeStartDate;
                                        print('object$date');

                                        Navigator.pop(context);
                                      }
                                      if (dataRowIndex != null) {
                                        employeeData[dataRowIndex]
                                                .actualendDate =
                                            DateFormat('dd-MM-yyyy')
                                                .format(endDate!);

                                        _employeeData[dataRowIndex] =
                                            DataGridRow(cells: [
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .srNo,
                                              columnName: 'srNo'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .approval,
                                              columnName: 'Approval'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex],
                                              columnName: 'button'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .startDate,
                                              columnName: 'StartDate'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .endDate,
                                              columnName: 'EndDate'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .actualstartDate,
                                              columnName: 'ActualStart'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .actualendDate,
                                              columnName: 'ActualEnd'),
                                          // DataGridCell(
                                          //     value: employeeData[dataRowIndex]
                                          //         .weightage,
                                          //     columnName: 'Weightage'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .applicability,
                                              columnName: 'Applicability'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .approvingAuthority,
                                              columnName: 'ApprovingAuthority'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .currentStatusPerc,
                                              columnName: 'CurrentStatusPerc'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .overallWeightage,
                                              columnName: 'OverallWeightage'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .currentStatus,
                                              columnName: 'CurrentStatus'),
                                          DataGridCell(
                                              value: employeeData[dataRowIndex]
                                                  .listDocument,
                                              columnName: 'ListDocument'),
                                        ]);

                                        updateDataGrid(
                                            rowColumnIndex: RowColumnIndex(
                                                dataRowIndex, 6));

                                        notifyListeners();
                                      }
                                      // if (dataRowIndex != null) {
                                      //   employeeData[dataRowIndex]
                                      //           .actualDuration =
                                      //       int.parse(diff.inDays.toString());

                                      //   _employeeData[dataRowIndex] =
                                      //       DataGridRow(cells: [
                                      //     DataGridCell(
                                      //         value:
                                      //             employeeData[dataRowIndex].srNo,
                                      //         columnName: 'srNo'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .activity,
                                      //         columnName: 'Activity'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex],
                                      //         columnName: 'button'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .originalDuration,
                                      //         columnName: 'OriginalDuration'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .startDate,
                                      //         columnName: 'StartDate'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .endDate,
                                      //         columnName: 'EndDate'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .actualstartDate,
                                      //         columnName: 'ActualStart'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .actualendDate,
                                      //         columnName: 'ActualEnd'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .actualDuration,
                                      //         columnName: 'ActualDuration'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .delay,
                                      //         columnName: 'Delay'),
                                      //     DataGridCell(
                                      //         value:
                                      //             employeeData[dataRowIndex].unit,
                                      //         columnName: 'Unit'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .scope,
                                      //         columnName: 'QtyScope'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .qtyExecuted,
                                      //         columnName: 'QtyExecuted'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .balanceQty,
                                      //         columnName: 'BalancedQty'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .percProgress,
                                      //         columnName: 'Progress'),
                                      //     DataGridCell(
                                      //         value: employeeData[dataRowIndex]
                                      //             .weightage,
                                      //         columnName: 'Weightage'),
                                      //   ]);

                                      //   updateDataGrid(
                                      //       rowColumnIndex: RowColumnIndex(
                                      //           dataRowIndex, 8));
                                      //   notifyListeners();
                                      // }
                                    }),
                                    onCancel: () {
                                      _controller.selectedRanges = null;
                                      Navigator.pop(context);
                                    },
                                  ),
                                )),
                          );
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                      Text(dataGridCell.value.toString()),
                    ],
                  )
                // : (dataGridCell.columnName == 'StartDate')
                //     ? Row(
                //         children: [
                //           IconButton(
                //             onPressed: () {
                //               showDialog(
                //                 context: mainContext,
                //                 builder: (context) => AlertDialog(
                //                     title: const Text('All Date'),
                //                     content: Container(
                //                       height: 400,
                //                       width: 500,
                //                       child: SfDateRangePicker(
                //                         view: DateRangePickerView.month,
                //                         showTodayButton: true,
                //                         controller: _controller,
                //                         onSelectionChanged:
                //                             (DateRangePickerSelectionChangedArgs
                //                                 args) {
                //                           if (args.value is PickerDateRange) {
                //                             rangeStartDate1 =
                //                                 args.value.startDate;
                //                             rangeEndDate1 = args.value.endDate;
                //                           } else {
                //                             final List<PickerDateRange>
                //                                 selectedRanges = args.value;
                //                           }
                //                         },
                //                         selectionMode:
                //                             DateRangePickerSelectionMode.range,
                //                         showActionButtons: true,
                //                         onSubmit: ((value) {
                //                           date1 = DateTime.parse(
                //                               rangeStartDate1.toString());

                //                           endDate1 = DateTime.parse(
                //                               rangeEndDate1.toString());

                //                           Duration diff1 =
                //                               endDate1!.difference(date1!);

                //                           final int dataRowIndex =
                //                               _employeeData.indexOf(row);

                //                           if (dataRowIndex != null) {
                //                             employeeData[dataRowIndex]
                //                                     .startDate =
                //                                 DateFormat('dd-MM-yyyy')
                //                                     .format(date1!);

                //                             _employeeData[dataRowIndex] =
                //                                 DataGridRow(cells: [
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .srNo,
                //                                   columnName: 'srNo'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .approval,
                //                                   columnName: 'Approval'),
                //                               DataGridCell(
                //                                   value: employeeData[
                //                                       dataRowIndex],
                //                                   columnName: 'button'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .startDate,
                //                                   columnName: 'StartDate'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .endDate,
                //                                   columnName: 'EndDate'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .actualstartDate,
                //                                   columnName: 'ActualStart'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .actualendDate,
                //                                   columnName: 'ActualEnd'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .weightage,
                //                                   columnName: 'Weightage'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .applicability,
                //                                   columnName: 'Applicability'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .approvingAuthority,
                //                                   columnName:
                //                                       'ApprovingAuthority'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .currentStatusPerc,
                //                                   columnName:
                //                                       'CurrentStatusPerc'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .overallWeightage,
                //                                   columnName:
                //                                       'OverallWeightage'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .currentStatus,
                //                                   columnName: 'CurrentStatus'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .listDocument,
                //                                   columnName: 'ListDocument'),
                //                             ]);

                //                             updateDataGrid(
                //                                 rowColumnIndex: RowColumnIndex(
                //                                     dataRowIndex, 3));

                //                             notifyListeners();

                //                             print('state$date');
                //                             print('valuedata$value');

                //                             print('start $rangeStartDate');
                //                             print('End $rangeEndDate');
                //                             // date = rangeStartDate;
                //                             print('object$date');

                //                             Navigator.pop(context);
                //                           }
                //                           if (dataRowIndex != null) {
                //                             employeeData[dataRowIndex].endDate =
                //                                 DateFormat('dd-MM-yyyy')
                //                                     .format(endDate1!);

                //                             _employeeData[dataRowIndex] =
                //                                 DataGridRow(cells: [
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .srNo,
                //                                   columnName: 'srNo'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .approval,
                //                                   columnName: 'Approval'),
                //                               DataGridCell(
                //                                   value: employeeData[
                //                                       dataRowIndex],
                //                                   columnName: 'button'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .startDate,
                //                                   columnName: 'StartDate'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .endDate,
                //                                   columnName: 'EndDate'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .actualstartDate,
                //                                   columnName: 'ActualStart'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .actualendDate,
                //                                   columnName: 'ActualEnd'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .weightage,
                //                                   columnName: 'Weightage'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .applicability,
                //                                   columnName: 'Applicability'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .approvingAuthority,
                //                                   columnName:
                //                                       'ApprovingAuthority'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .currentStatusPerc,
                //                                   columnName:
                //                                       'CurrentStatusPerc'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .overallWeightage,
                //                                   columnName:
                //                                       'OverallWeightage'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .currentStatus,
                //                                   columnName: 'CurrentStatus'),
                //                               DataGridCell(
                //                                   value:
                //                                       employeeData[dataRowIndex]
                //                                           .listDocument,
                //                                   columnName: 'ListDocument'),
                //                             ]);

                //                             updateDataGrid(
                //                                 rowColumnIndex: RowColumnIndex(
                //                                     dataRowIndex, 4));

                //                             notifyListeners();
                //                           }
                //                           // if (dataRowIndex != null) {
                //                           //   employeeData[dataRowIndex]
                //                           //           .originalDuration =
                //                           //       int.parse(
                //                           //           diff1.inDays.toString());

                //                           //   _employeeData[dataRowIndex] =
                //                           //       DataGridRow(cells: [
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .srNo,
                //                           //         columnName: 'srNo'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .activity,
                //                           //         columnName: 'Activity'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex],
                //                           //         columnName: 'button'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .originalDuration,
                //                           //         columnName:
                //                           //             'OriginalDuration'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .startDate,
                //                           //         columnName: 'StartDate'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .endDate,
                //                           //         columnName: 'EndDate'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .actualstartDate,
                //                           //         columnName: 'ActualStart'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .actualendDate,
                //                           //         columnName: 'ActualEnd'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .actualDuration,
                //                           //         columnName: 'ActualDuration'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .delay,
                //                           //         columnName: 'Delay'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .unit,
                //                           //         columnName: 'Unit'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .scope,
                //                           //         columnName: 'QtyScope'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .qtyExecuted,
                //                           //         columnName: 'QtyExecuted'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .balanceQty,
                //                           //         columnName: 'BalancedQty'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .percProgress,
                //                           //         columnName: 'Progress'),
                //                           //     DataGridCell(
                //                           //         value:
                //                           //             employeeData[dataRowIndex]
                //                           //                 .weightage,
                //                           //         columnName: 'Weightage'),
                //                           //   ]);

                //                           //   updateDataGrid(
                //                           //       rowColumnIndex: RowColumnIndex(
                //                           //           dataRowIndex, 3));

                //                           //   notifyListeners();
                //                           // }
                //                         }),
                //                         onCancel: () {
                //                           _controller.selectedRanges = null;
                //                           Navigator.pop(context);
                //                         },
                //                       ),
                //                     )),
                //               );
                //             },
                //             icon: const Icon(Icons.calendar_today),
                //           ),
                //           Text(dataGridCell.value.toString()),
                //         ],
                //       )

                : Text(
                    dataGridCell.value.toString(),
                  ),
      );
    }).toList());
  }

  void updateDatagridSource() {
    notifyListeners();
  }

  void updateDataGrid({required RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }
}
