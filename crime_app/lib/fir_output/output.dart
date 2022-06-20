import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';
import 'dart:ui';

class FIROutput extends StatefulWidget {
  const FIROutput({super.key, this.value});
  final value;

  @override
  State<FIROutput> createState() => _FIROutputState();
}

List<Widget> listOfWidgets(List<int> item) {
  List<Widget> list = <Widget>[];
  for (var i = 0; i < item.length; i++) {
    list.add(Container(
        padding: EdgeInsets.symmetric(vertical: 3.0),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            item[i].toString(),
            style: TextStyle(
                fontSize: 30.0, color: Colors.white, fontFamily: 'Libre'),
          ),
        )));
  }
  return list;
}

class _FIROutputState extends State<FIROutput> {
  @override
  Widget build(BuildContext context) {
    var val = widget.value;
    val = {
      "firs": [420, 69, 143, 123]
    };
    print(val["firs"]);

    // val["firs"].map((var num) {
    //   return Text(num);
    // });
    return Scaffold(
        body: Container(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/images/police.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.5, sigmaY: 5.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                                color: Colors.white, Icons.arrow_back_ios)),
                        SizedBox(
                          width: 20.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.0)),
                          child: const Text(
                            "FIRs",
                            style: TextStyle(
                                fontSize: 50,
                                color: Colors.white,
                                fontFamily: 'KaushanScript'),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 56.0, vertical: 0.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 30.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: const Color.fromARGB(174, 110, 87, 87),
                        ),
                        child: Column(children: listOfWidgets(val['firs']))),
                    // ListTile(
                    //   contentPadding:
                    //       EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    //   title: Text(
                    //     val['firs'][0].toString(),
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    //   trailing: Icon(Icons.keyboard_arrow_right),
                    //   onTap: () {},
                    // ),
                    // Column(children: <Widget>[
                    //   val["firs"].map((var num) {
                    //     return Text(num.toString());
                    //   }).toList(),
                    // ])
                    SizedBox(
                      height: 100,
                    )
                  ],
                ))));
  }
}
