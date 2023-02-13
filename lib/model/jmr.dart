import 'package:assingment/Jmr/jmr_home.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class JMRModel {
  JMRModel({
    required this.srNo,
    required this.Description,
    required this.Activity,
    required this.RefNo,
    required this.JmrAbstract,
    required this.Uom,
    required this.rate,
    required this.TotalQty,
    required this.TotalAmount,
  });

  int? srNo;
  String? Description;
  dynamic Activity;
  dynamic RefNo;
  dynamic JmrAbstract;
  String? Uom;
  double? rate;
  int? TotalQty;
  double? TotalAmount;

  factory JMRModel.fromjson(Map<String, dynamic> json) {
    return JMRModel(
        srNo: json['srNo'],
        Description: json['Description'],
        Activity: json['Activity'],
        RefNo: json['RefNo'],
        JmrAbstract: json['JmrAbstract'],
        Uom: json['Uom'],
        rate: json['rate'],
        TotalQty: json['TotalQty'],
        TotalAmount: json['TotalAmount']);
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell<int>(columnName: 'srNo', value: srNo),
      DataGridCell<String>(columnName: 'Description', value: Description),
      DataGridCell<dynamic>(columnName: 'Activity', value: Activity),
      DataGridCell<dynamic>(columnName: 'RefNo', value: RefNo),
      DataGridCell<dynamic>(columnName: 'Abstract', value: JmrAbstract),
      DataGridCell<dynamic>(columnName: 'Uom', value: Uom),
      DataGridCell<dynamic>(columnName: 'Rate', value: rate),
      DataGridCell<dynamic>(columnName: 'TotalQty', value: TotalQty),
      DataGridCell<dynamic>(columnName: 'TotalAmount', value: TotalAmount),
    ]);
  }
}
