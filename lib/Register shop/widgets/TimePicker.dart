import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/businessInformation.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/Register%20shop/widgets/closing_time.dart';
import 'package:spicy_eats/Register%20shop/widgets/opening_time.dart';
import 'package:spicy_eats/commons/shapes.dart';

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
          child: Stack(
            children: [
              Container(
                height: 800,
                width: double.infinity,
                color: Colors.white,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 800),
                      painter: RPSCustomPainter(),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  // Container(
                  //   child: Image.network(
                  //     'https://w7.pngwing.com/pngs/669/158/png-transparent-extra-spicy-label-with-peppers-thumbnail.png',
                  //     width: 200,
                  //     height: 200,
                  //     // scale: 10,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  Column(
                    children: [
                      const Text(
                        'Days',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w900),
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
                                ref.read(dayIndexProvider.notifier).state =
                                    value;
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              days,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
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
                                                    openinghours[days]![
                                                        'status'] = true;

                                                    print(
                                                        'status value after${openinghours[days]!['status']}');
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5))),
                                                    backgroundColor:
                                                        openinghours[days]![
                                                                    'status'] ==
                                                                true
                                                            ? Colors.black
                                                            : Colors.white),
                                                child: Text(
                                                  'OPEN',
                                                  style: TextStyle(
                                                      color: openinghours[
                                                                      days]![
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
                                                    openinghours[days]![
                                                        'status'] = false;
                                                    print(
                                                        'status value after${openinghours[days]!['status']}');
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        5))),
                                                    backgroundColor:
                                                        openinghours[days]![
                                                                    'status'] ==
                                                                false
                                                            ? Colors.black
                                                            : Colors.white),
                                                child: Text(
                                                  'CLOSE',
                                                  style: TextStyle(
                                                      color: openinghours[
                                                                      days]![
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
                  const SizedBox(
                    height: 30,
                  ),
                  openinghours[daysList[daysvalue]]!['status'] == false
                      ? Container(
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(1, 2),
                                    blurRadius: 5,
                                    spreadRadius: 1)
                              ],
                              // border: Border.all(color: Colors.black, width: 2),
                              color: Colors.grey[200], // Colors.indigo[100],
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.lock,
                                  size: 50,
                                  color: Colors.red,
                                ),
                                const SizedBox(
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
                        )
                      : Container(
                          padding: const EdgeInsets.all(10),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Save',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 20)),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CustomClippath extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     double h = size.height;
//     double w = size.width;
//     var path = Path();
//     // path.lineTo(0, h);
//     // path.lineTo(w, h);
//     // path.lineTo(w, 0);
//     // path.close();
//     //path.moveTo(0, 100);
//     path.moveTo(0, size.height * 0.7);
//     path.quadraticBezierTo(size.width * 0.25, size.height * 0.7,
//         size.width * 0.5, size.height * 0.8);
//     path.quadraticBezierTo(size.width * 0.75, size.height * 0.9,
//         size.width * 1.0, size.height * 0.8);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }

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
