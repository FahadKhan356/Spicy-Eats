import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/businessInformation.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/Register%20shop/widgets/closing_time.dart';
import 'package:spicy_eats/Register%20shop/widgets/opening_time.dart';

var daynameProvider = StateProvider((ref) => 'Monday');
var dayIndexProvider = StateProvider<int>((ref) => 0);

class TimePicker extends ConsumerStatefulWidget {
  const TimePicker({
    super.key,
  });

  @override
  ConsumerState<TimePicker> createState() => _TimePickerState();
}

int daysvalue = 0;
int ampmvalue = 0;

class _TimePickerState extends ConsumerState<TimePicker> {
  final daysList = openinghours.keys.toList();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, BusinessDetailsScreen.routename);
            }),
        elevation: 8,
        title: Center(
            child: Text(
          'Restaurant Schedule',
          style: TextStyle(
            color: Colors.black,
            fontSize: height * 0.03,
          ),
        )),
        backgroundColor: Colors.white, //Color(0xFFD1C4E9),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                child: Image.network(
                  'https://static.vecteezy.com/system/resources/previews/007/500/121/original/food-delivery-icon-clip-art-logo-simple-illustration-free-vector.jpg',
                  width: 200,
                  height: 200,
                  // scale: 10,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  const Text(
                    'Days',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    //color: Colors.amber,
                    height: 200,
                    // decoration:
                    //     BoxDecoration(border: Border.all(color: Colors.black)),
                    child: ListWheelScrollView.useDelegate(
                        onSelectedItemChanged: (value) {
                          setState(() {
                            daysvalue = value;
                            ref.read(dayIndexProvider.notifier).state = value;
                            print('day wala index : $value');
                          });
                        },
                        physics: const FixedExtentScrollPhysics(),
                        diameterRatio: 1.0,
                        itemExtent: 30,
                        childDelegate: ListWheelChildBuilderDelegate(
                            childCount: daysList.length,
                            builder: (context, index) {
                              final days = daysList[index];
                              return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: daysvalue == index
                                        ? Colors.black12
                                        : Colors.transparent,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(
                                          days,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // Update the opening hours map
                                              setState(() {
                                                print(
                                                    'status value before${openinghours[days]!['status']}');
                                                openinghours[days]!['status'] =
                                                    true;

                                                print(
                                                    'status value after${openinghours[days]!['status']}');
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5))),
                                                backgroundColor: openinghours[
                                                            days]!['status'] ==
                                                        true
                                                    ? Colors.black
                                                    : Colors.white),
                                            child: Text(
                                              'OPEN',
                                              style: TextStyle(
                                                  color: openinghours[days]![
                                                              'status'] ==
                                                          true
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 10),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                // Update the opening hours map
                                                print(
                                                    'status value before${openinghours[days]!['status']}');
                                                openinghours[days]!['status'] =
                                                    false;
                                                print(
                                                    'status value after${openinghours[days]!['status']}');
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight: Radius
                                                                .circular(5),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    5))),
                                                backgroundColor: openinghours[
                                                            days]!['status'] ==
                                                        false
                                                    ? Colors.black
                                                    : Colors.white),
                                            child: Text(
                                              'CLOSE',
                                              style: TextStyle(
                                                  color: openinghours[days]![
                                                              'status'] ==
                                                          false
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ));
                            })),
                  ),
                ],
              ),
              openinghours[daysList[daysvalue]]!['status'] == false
                  ? Container(
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.lock,
                              size: 50,
                              color: Colors.red,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "${daysList[daysvalue]} is Closed",
                              style: TextStyle(
                                  letterSpacing: 10,
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black38,
                                offset: Offset(1, 2),
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                          // border: Border.all(color: Colors.black, width: 2),
                          color: Colors.grey[200], // Colors.indigo[100],
                          borderRadius: BorderRadius.circular(10)),
                    )
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          // SizedBox(width: 10), // Adjust the width as needed

                          Opening_Time(
                            days: days[daysvalue],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 200,
                            width: 3,
                            child: Container(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),

                          Closing_Time(
                            days: days[daysvalue],
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Save',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20)),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class MyMinutes extends StatelessWidget {
  final int mins;
  MyMinutes({
    super.key,
    required this.mins,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Text(
          mins < 10 ? '0' + mins.toString() : mins.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class MyHours extends StatelessWidget {
  final int hours;
  MyHours({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          hours < 10 ? '0' + hours.toString() : hours.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class MyDays extends ConsumerStatefulWidget {
  final String days;
  final int index;
  MyDays({
    super.key,
    required this.days,
    required this.index,
  });

  @override
  ConsumerState<MyDays> createState() => _MyDaysState();
}

class _MyDaysState extends ConsumerState<MyDays> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Text(
            widget.days,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                // Update the opening hours map
                setState(() {
                  print(
                      'status value before${openinghours[widget.days]!['status']}');
                  openinghours[widget.days]!['status'] = true;

                  print(
                      'status value after${openinghours[widget.days]!['status']}');
                });
              },
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5))),
                  backgroundColor: openinghours[widget.days]!['status'] == true
                      ? Colors.black
                      : Colors.white),
              child: Text(
                'OPEN',
                style: TextStyle(
                    color: openinghours[widget.days]!['status'] == true
                        ? Colors.white
                        : Colors.black,
                    fontSize: 10),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Update the opening hours map
                  print(
                      'status value before${openinghours[widget.days]!['status']}');
                  openinghours[widget.days]!['status'] = false;
                  print(
                      'status value after${openinghours[widget.days]!['status']}');
                });
              },
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  backgroundColor: openinghours[widget.days]!['status'] == false
                      ? Colors.black
                      : Colors.white),
              child: Text(
                'CLOSE',
                style: TextStyle(
                    color: openinghours[widget.days]!['status'] == false
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// class MyCheckBox extends StatefulWidget {
//   bool status;
//   int hours;
//   int minutes;
//   MyCheckBox(
//       {super.key,
//       required this.status,
//       required this.hours,
//       required this.minutes});

//   @override
//   State<MyCheckBox> createState() => _MyCheckBoxState();
// }

// class _MyCheckBoxState extends State<MyCheckBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Checkbox(
//         value: widget.status,
//         onChanged: (value) {
//           value == true ? setState(() {

//           }) : null;
//         });
//   }
// }
