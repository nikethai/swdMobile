import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/bottomNav.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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
      appBar: AppBar(
        title: Center(
          child: Text("Testing"),
        ),
      ),
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
                    'Hello Testing,',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
            children: <Widget>[
              buildFutureBuilder(2)
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 100),
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
      bottomNavigationBar: BottomNav(),
    );
  }

  FutureBuilder<Payroll> buildFutureBuilder(int mode) {
    return FutureBuilder<Payroll>(
      future: fetchPayroll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (mode == 1){
            return Text(snapshot.data.grossPay.toString());
          }else if (mode == 2){
            return Text(snapshot.data.netPay.toString()+'₫',style: TextStyle(fontSize: 50),);
          }
          else{
            return Text(snapshot.data.endDate.toString());
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
      },
    );
  }
}

Future<Payroll> fetchPayroll() async {
  final respone = await http.get('http://13.251.232.180/api/Payroll');
  if (respone.statusCode == 200) {
    return Payroll.formJson(json.decode(respone.body)[0]);
  } else {
    throw Exception('Failed');
  }
}

class Payroll {
  final double netPay;
  final double grossPay;
  final String endDate;

  Payroll(
      {
      this.grossPay,
      this.netPay,
      this.endDate,
      });

  factory Payroll.formJson(Map<String, dynamic> json) {
    return Payroll(
        netPay: json['NetPay'],
        grossPay: json['GrossPay'],
        endDate: json['EndDate'],
    );
  }
}
