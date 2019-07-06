import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Report {
  int id;
  String message;
  bool status;
  DateTime date;
  int empID;

// Constructor
  Report ({
    this.id,
    this.message,
    this.status,
    this.empID
  });
  //Do the same as Report
  factory Report.fromJson(Map<String, dynamic> json) {
    Report newReport = Report(
      id: json['id'],
      message: json['message'],
      status: json['status'],
      empID: json['empID']
    );
    return newReport;
  }
  //clone a report
  factory Report.fromReport(Report anotherReport) {
    return Report(
      id: anotherReport.id,
      message: anotherReport.message,
      status: anotherReport.status,
      empID: anotherReport.empID
      );
  }
}
  //Controller ="function relating to Report"
  Future<List<Report>> fetchReports(http.Client client, int empID) async {
    final response = await client.get('http://13.251.232.180/api/Report/empID');
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final reports = mapResponse["data"].cast<Map<String, dynamic>>();
        return reports.map<Report>((json){
          return Report.fromJson(json);
        }).toList();
      } else {
        return [];
      }
    }
    else {
      throw Exception('Failed to load Report');
    }
  }
  //Fetch Report by Id
Future<Report> fetchReportById(http.Client client, int id) async {
  final String url = 'http://13.251.232.180/api/Report/id';
  final response = await client.get(url);
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (mapResponse["result"] == "ok") {
      Map<String, dynamic> mapReport = mapResponse["data"];
      return Report.fromJson(mapReport);
    } else {
      return Report();
    }
  } else {
    throw Exception('Failed to get detail Report with Id = {id}');
  }
}
//Update a Report
Future<Report> updateAReport(http.Client client,  Map<String, dynamic> params) async {
  final response = await client.put('http://13.251.232.180/api/Report/{params["id"]}', body: params);
  if (response.statusCode == 200) {
    final responseBody = await json.decode(response.body);
    return Report.fromJson(responseBody);
  } else {
    throw Exception('Failed to update a Report. Error: ${response.toString()}');
  }
}
//Delete a Report
Future<Report> deleteAReport(http.Client client, int id) async {
  final String url = 'http://13.251.232.180/api/Report/id';
  final response = await client.delete(url);
  if (response.statusCode == 200) {final responseBody = await json.decode(response.body);
  return Report.fromJson(responseBody);

  } else {
    throw Exception('Failed to delete a Report');
  }
}