import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/bottomNav.dart';
import 'package:flutter_login_ui/pageView.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sliding_up_panel/sliding_up_panel.dart' as sli;

void main() => runApp(MyHome());

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Paycheck', home: _MyHome());
  }
}

class _MyHome extends StatefulWidget {
  _MyHome({Key key}) : super(key: key);

  @override
  _MyHomeState createState() => new _MyHomeState();
}

class _MyHomeState extends State<_MyHome> {
  final dateFormatter = DateFormat('yyyy-MM-dd');
  String _value = '';

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));
    if (picked != null) setState(() => _value = dateFormatter.format(picked));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text('DuyPA'),
                accountName: Text('Phan Anh Duy'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: Text(
                    'PA',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              ListTile(
                title: Text('Home'),
                trailing: Icon(Icons.home),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Report'),
                trailing: Icon(Icons.warning),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              Divider(),
              ListTile(
                title: Text('Sign Out'),
                trailing: Icon(Icons.exit_to_app),
                onTap: () {
                  //Something
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Testing"),
          centerTitle: true,
        ),
        body: sli.SlidingUpPanel(
          panel: _scrollDetail(),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Welcome,',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      buildFutureBuilder(1)
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 150),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[buildFutureBuilder(2)],
              ),
              Text('Net pay'),
              Padding(
                padding: EdgeInsets.only(bottom: 120),
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Payday',
                    style: TextStyle(fontSize: 25),
                  ),
                  Spacer(),
                  RaisedButton(
                    onPressed: _selectDate,
                    child: Text(_value.isEmpty
                        ? dateFormatter.format(DateTime.now())
                        : _value),
                  )
                ],
              )
            ],
          ),
          collapsed: Container(
            color: Colors.lightBlue,
            child: Center(
              child: Text(
                'Swipe up for details',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          parallaxEnabled: true,
          parallaxOffset: .5,
        )

        // bottomNavigationBar: BottomNav(),
        );
  }

  FutureBuilder<Payroll> buildFutureBuilder(int mode) {
    return FutureBuilder<Payroll>(
      future: fetchPayroll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
            if (mode == 1) {
              return Text(
                snapshot.data.empName.toString(),
                style: TextStyle(fontSize: 30),
              );
            } else if (mode == 2) {
              return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Text(
                    snapshot.data.netPay.toString() + '₫',
                    style: TextStyle(fontSize: 50),
                  ));
            } else {
              return Text(snapshot.data.endDate.toString());
            }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  // FutureBuilder<Allowance> allowBuilder() {
  //   return FutureBuilder<Allowance>(
  //     future: fetchAllowance(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         if (snapshot != null) {}
  //       } else
  //         return Text('Error ${(snapshot.error)}');
  //     },
  //   );
  // }

  FutureBuilder<List<Deduction>> deductBuilder(int index) {
    return FutureBuilder<List<Deduction>>(
      future: fetchDeduction(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot != null) {
            return ListTile(
              title: Text(snapshot.data[index].deName),
              trailing: Text(snapshot.data[index].deAmount.toString()),
            );
          }
        } else
          return Text('Error ${(snapshot.error)}');
      },
    );
  }

  Widget _scrollDetail() {
    return Container(
        margin: const EdgeInsets.only(top: 50),
        color: Colors.white,
        child: FutureBuilder<List<Allowance>>(
          future: fetchAllowance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(snapshot.data[index].alName),
                          trailing:
                              Text(snapshot.data[index].alAmount.toString()),
                        ),
                        deductBuilder(index)
                      ],
                    );
                    ;
                  },
                );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}

Future<Payroll> fetchPayroll() async {
  final respone = await http.get('http://13.251.232.180/api/Payroll/1');
  if (respone.statusCode == 200) {
    return Payroll.formJson(json.decode(respone.body)[0]);
  } else {
    throw Exception('Failed');
  }
}

Future<List<Allowance>> fetchAllowance() async {
  final respone = await http.get('http://13.251.232.180/api/Allowance/1');
  if (respone.statusCode == 200) {
    var jso = json.decode(respone.body);
    List<Allowance> allowList = [];
    for (var u in jso) {
      Allowance allow = Allowance(u['alAmount'], u['alName']);
      allowList.add(allow);
    }
    return allowList;
  } else {
    throw Exception('Failed');
  }
}

Future<List<Deduction>> fetchDeduction() async {
  final respone = await http.get('http://13.251.232.180/api/Deduction/1');
  if (respone.statusCode == 200) {
    var jso = json.decode(respone.body);
    List<Deduction> deductList = [];
    for (var u in jso) {
      Deduction deduct = Deduction(u['deAmount'], u['deName']);
      deductList.add(deduct);
    }
    return deductList;
  } else {
    throw Exception('Failed');
  }
}

class Allowance {
  final double alAmount;
  final String alName;

  Allowance(
    this.alAmount,
    this.alName,
  );
}

class Deduction {
  final double deAmount;
  final String deName;

  Deduction(
    this.deAmount,
    this.deName,
  );
}

class Payroll {
  final double netPay;
  final String empName;
  final String endDate;

  Payroll({
    this.empName,
    this.netPay,
    this.endDate,
  });
  factory Payroll.formJson(Map<String, dynamic> json) {
    return Payroll(
      netPay: json['NetPay'],
      empName: json['EmpName'],
      endDate: json['EndDate'],
    );
  }
}
