import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/Register%20shop/widgets/TimePicker.dart';

class Opening_Time extends ConsumerStatefulWidget {
  final String days;
  const Opening_Time({super.key, required this.days});

  @override
  ConsumerState<Opening_Time> createState() => _Opening_TimeState();
}

class _Opening_TimeState extends ConsumerState<Opening_Time> {
  int ophours = 0;
  int opmins = 0;
  int ampm = 0;

  @override
  Widget build(BuildContext context) {
    // final openingTime = openinghours[widget.days]?['opening_time'] ?? {};
    final currentamPm = openinghours[widget.days]!["opening_period"] ?? 'AM';

    final currentHours =
        openinghours[widget.days]!['opening_time']['hours'] ?? 0;
    final currentMinutes =
        openinghours[widget.days]!['opening_time']['mins'] ?? 0;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black38,
                  offset: Offset(1, 2),
                  blurRadius: 5,
                  spreadRadius: 1)
            ],
            // border: Border.all(color: Colors.black, width: 2),
            color: Colors.white, // Colors.indigo[100],
            borderRadius: BorderRadius.circular(10)),
        height: 280,
        //color: Colors.blue[50],
        child: Column(children: [
          Text(
            'Opening Hours ${widget.days} ${openinghours[widget.days]!["opening_time"]}',
            style:
                const TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
          ),
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
                                ophours = value;
                                openinghours[widget.days]!['opening_time']
                                    ['hours'] = ophours;
                                print(
                                    ' for checking hours  ${openinghours[widget.days]!['opening_time']}');
                              });
                            },
                            physics: const FixedExtentScrollPhysics(),
                            diameterRatio: 1.0,
                            itemExtent: 40,
                            childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 13,
                                builder: (context, index) {
                                  //index = currentHours;
                                  return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ophours == index
                                            ? Colors.black12
                                            : Colors.transparent,
                                      ),
                                      child:
                                          Center(child: MyHours(hours: index)));
                                })),
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
                                opmins = value;
                                openinghours[widget.days]!['opening_time']
                                    ['mins'] = opmins;
                              });
                              print(
                                  ' for checking hours  ${openinghours[widget.days]!['opening_time']}');
                            },
                            physics: const FixedExtentScrollPhysics(),
                            diameterRatio: 1.0,
                            itemExtent: 40,
                            childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 60,
                                builder: (context, index) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: index == opmins
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
                  child: SizedBox(
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
                                    ampm = value;
                                    openinghours[widget.days]![
                                        "opening_period"] = ampmlist[value];
                                  });
                                  print(value);
                                },
                                physics: const FixedExtentScrollPhysics(),
                                diameterRatio: 1.0,
                                itemExtent: 40,
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: ampmlist.length,
                                  builder: (context, index) => Container(
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ampm == index
                                          ? Colors.black12
                                          : Colors.transparent,
                                    ),
                                    child: Center(
                                        child: Text(
                                      ampmlist[index],
                                      style: const TextStyle(fontSize: 15),
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
          Center(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Text(openinghours[widget.days]!['opening_time'].toString()),
                    Text(
                      currentHours < 10
                          ? '0 $currentHours'.toString()
                          : currentHours.toString(),
                      style: GoogleFonts.aBeeZee(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          const BoxShadow(
                            color: Colors.black45,
                            offset: Offset(2, 4),
                            blurRadius: 1,
                            spreadRadius: 1,
                          ),
                        ],
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      currentMinutes < 10
                          ? ' : 0 $currentMinutes'
                          : ' : $currentMinutes',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          const BoxShadow(
                            color: Colors.black45,
                            offset: Offset(2, 4),
                            blurRadius: 1,
                            spreadRadius: 1,
                          ),
                        ],
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      currentamPm.toString(),
                      style: GoogleFonts.aBeeZee(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          const BoxShadow(
                            color: Colors.black45,
                            offset: Offset(2, 4),
                            blurRadius: 1,
                            spreadRadius: 1,
                          ),
                        ],
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
