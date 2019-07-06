import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart' as sli;

void main() => runApp(PageViewWid());

class PageViewWid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _MyPageView());
  }
}

class _MyPageView extends StatefulWidget {
  @override
  __MyPageViewState createState() => __MyPageViewState();
}

class __MyPageViewState extends State<_MyPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sli.SlidingUpPanel(
        collapsed: Center(
          child: Text('collapses'),
        ),
        // panel: _scrollDetail(),
        body: Center(child: Text('testing panel')),
        parallaxEnabled: true,
        parallaxOffset: .5,
      ),
    );
  }

  
}
