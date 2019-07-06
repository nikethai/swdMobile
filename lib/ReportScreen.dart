import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'report.dart';

class ReportScreen extends StatefulWidget {
  final int todoId;
  //constructor
  ReportScreen({this.todoId}):super();
  @override
  State<StatefulWidget> createState() => _ReportScreenState();
}
class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("List of reports"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              //Press this button to navigate to detail Report
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: fetchReports(http.Client(), widget.todoId),
          builder: (context, snapshot){
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ReportList(reports: snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
}
class ReportList extends StatelessWidget {
  final List<Report> reports;
  ReportList({Key key, this.reports}) : super(key: key);
  @override
  Widget build(BuildContext context) => ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              padding: EdgeInsets.all(10.0),
              color: index % 2 == 0 ? Colors.deepOrangeAccent : Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  Text(this.reports[index].message, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                  new Text('Status: ${reports[index].status==true?"Yes":"No"}', style: TextStyle(fontSize: 16.0))
                ],
              ),
            ),
            // onTap: () {
            //   int selectedId = reports[index].id;
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => new DetailReportScreen(id: selectedId))
            //   );
            // } ,
          );
        },
      itemCount: this.reports.length,
    );
}