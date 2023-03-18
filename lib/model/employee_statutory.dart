class EmployeeStatutory {
  /// Creates the employee class with required details.
  EmployeeStatutory({
    required this.srNo,
    required this.approval,
    required this.startDate,
    required this.endDate,
    required this.actualstartDate,
    required this.actualendDate,
    // required this.weightage,
    required this.applicability,
    required this.approvingAuthority,
    required this.currentStatusPerc,
    required this.overallWeightage,
    required this.currentStatus,
    required this.listDocument,
  });
  int srNo;
  String approval;
  String? startDate;
  String? endDate;
  String? actualstartDate;
  String? actualendDate;
  // double weightage;
  String? applicability;
  String? approvingAuthority;
  int? currentStatusPerc;
  int? overallWeightage;
  String? currentStatus;
  String? listDocument;

  factory EmployeeStatutory.fromJson(Map<String, dynamic> json) {
    return EmployeeStatutory(
        srNo: json['srNo'],
        approval: json['Approval'],
        startDate: json['StartDate'],
        endDate: json['EndDate'],
        actualstartDate: json['ActualStart'],
        actualendDate: json['ActualEnd'],
        // weightage: json['Weightage'],
        applicability: json['Applicability'],
        approvingAuthority: json['ApprovingAuthority'],
        currentStatusPerc: json['CurrentStatusPerc'],
        overallWeightage: json['OverallWeightage'],
        currentStatus: json['CurrentStatus'],
        listDocument: json['ListDocument']);
  }
}
