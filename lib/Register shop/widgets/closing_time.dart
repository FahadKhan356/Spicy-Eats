import 'package:flutter/material.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/Register%20shop/widgets/TimePicker.dart';

class Closing_Time extends StatefulWidget {
  Closing_Time({
    super.key,
  });

  @override
  State<Closing_Time> createState() => _Opening_TimeState();
}

class _Opening_TimeState extends State<Closing_Time> {
  int clhours = 0;
  int clmins = 0;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black38,
                  offset: Offset(1, 2),
                  blurRadius: 5,
                  spreadRadius: 1)
            ],
            //border: Border.all(color: Colors.black, width: 2),
            color: Colors.white, // Colors.indigo[100],
            borderRadius: BorderRadius.circular(10)),
        height: 200,
        child: Column(children: [
          const Text('Closing Hours',
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red)),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Hours',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                            onSelectedItemChanged: (value) {
                              setState(() {
                                clhours = value;
                              });
                            },
                            physics: const FixedExtentScrollPhysics(),
                            diameterRatio: 1.0,
                            itemExtent: 40,
                            childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 13,
                                builder: (context, index) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: clhours == index
                                          ? Colors.black12
                                          : Colors.transparent,
                                    ),
                                    child:
                                        Center(child: MyHours(hours: index))))),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    ':',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Minutes',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                            onSelectedItemChanged: (value) {
                              setState(() {
                                clmins = value;
                              });
                              print(value);
                            },
                            physics: FixedExtentScrollPhysics(),
                            diameterRatio: 1.0,
                            itemExtent: 40,
                            childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 60,
                                builder: (context, index) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: clmins == index
                                            ? Colors.black12
                                            : Colors.transparent,
                                      ),
                                      child: Center(
                                        child: MyMinutes(
                                          mins: index,
                                        ),
                                      ),
                                    ))),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 200,
                    child: Column(
                      children: [
                        const Text(
                          'Am/Pm',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                            child: ListWheelScrollView.useDelegate(
                                onSelectedItemChanged: (value) {
                                  setState(() {
                                    ampmvalue = value;
                                  });
                                  print(value);
                                },
                                physics: FixedExtentScrollPhysics(),
                                diameterRatio: 1.0,
                                itemExtent: 40,
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: ampmlist.length,
                                  builder: (context, index) => Container(
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ampmvalue == index
                                          ? Colors.black12
                                          : Colors.transparent,
                                    ),
                                    child: Center(
                                        child: Text(
                                      ampmlist[index],
                                      style: TextStyle(fontSize: 15),
                                    )),
                                  ),
                                ))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
