// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/DoctorComponents/DoctorPayment.dart';

class DoctorSchedule extends StatefulWidget {
  final String doctorId;
  final String imagePath;
  final String name;
  final String choosenDate;
  const DoctorSchedule(
      {super.key,
      required this.doctorId,
      required this.imagePath,
      required this.name,
      required this.choosenDate});

  @override
  State<DoctorSchedule> createState() => _DoctorScheduleState();
}

class _DoctorScheduleState extends State<DoctorSchedule> {
  int selectedDateIndex = 0;
  int selectedTimeIndex = -1;
  DateTime? selectedDate;
  String? customDate;

  List<String> date = [];

  final List<String> time = [
    '08:00 WIB',
    '10:00 WIB',
    '12:00 WIB',
    '14:00 WIB',
    '16:00 WIB',
    '18:00 WIB',
    '20:00 WIB',
    '22:00 WIB',
  ];

  @override
  void initState() {
    super.initState();
    initializeDate();
  }

  void initializeDate() {
    final DateTime today = DateTime.now();
    date = List.generate(3, (index) {
      final DateTime date = today.add(Duration(days: index));
      return DateFormat('EEE\ndd\nMMM yyyy').format(date);
    });
    date.add('Others');
  }

  void saveToFirebase(String date, String time) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final formattedDate = DateFormat('EEE\ndd\nMMM yyyy').parse(date, true);

      await FirebaseFirestore.instance
          .collection('docter')
          .doc(widget.doctorId)
          .collection('schedule')
          .add({
        'date': DateFormat('EEE, dd MMM yyyy').format(formattedDate),
        'time': time,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Save the appointment under the user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .add({
        'doctorId': widget.doctorId,
        'doctorName': widget.name,
        'date': DateFormat('EEE, dd MMM yyyy').format(formattedDate),
        'time': time,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Appointment Saved!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving appointment')));
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2026));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        customDate = DateFormat('EEE\ndd\nMMMM yyyy').format(selectedDate!);
        selectedDateIndex = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Date',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(date.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (index == 3) {
                        selectDate(context);
                      } else {
                        selectedDateIndex = index;
                        customDate = null;
                      }
                    });
                  },
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selectedDateIndex == index
                          ? Colors.blue
                          : Colors.white,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(children: [
                      if (index < date.length &&
                          date[index].split('\n').length > 2) ...[
                        text(date[index].split('\n')[0], index),
                        text(date[index].split('\n')[1], index),
                        text(date[index].split('\n')[2], index),
                      ] else if (index == 3 && customDate == null) ...[
                        const Column(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 24,
                            ),
                            SizedBox(height: 35),
                            Text(
                              'Others',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ] else if (index == 3 && customDate != null) ...[
                        text(customDate!.split('\n')[0], index),
                        text(customDate!.split('\n')[1], index),
                        text(customDate!.split('\n')[2], index),
                      ],
                    ]),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text('Select Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(time.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTimeIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selectedTimeIndex == index
                          ? Colors.blue
                          : Colors.white,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      time[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: selectedTimeIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                if (selectedDateIndex >= 0 &&
                    selectedDateIndex < date.length &&
                    selectedTimeIndex >= 0 &&
                    selectedTimeIndex < time.length) {
                  final selectedDate = customDate ?? date[selectedDateIndex];
                  final selectedTime = time[selectedTimeIndex];

                  String customSelectedDate;
                  if (customDate != null) {
                    customSelectedDate = DateFormat('d MMMM yyyy')
                        .format(DateFormat('EEE\ndd\nMMM').parse(customDate!));
                  } else {
                    customSelectedDate = DateFormat('d MMMM yyyy').format(
                        DateTime.now().add(Duration(days: selectedDateIndex)));
                  }
                  final choosenDate = "$customSelectedDate $selectedTime";
                  saveToFirebase(selectedDate, selectedTime);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorPayment(
                            image: widget.imagePath,
                            name: widget.name,
                            choosenDate: choosenDate),
                      ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select a date and time')),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(71, 116, 186, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget text(String date, int index) {
    return Text(
      date,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: selectedDateIndex == index ? Colors.white : Colors.black,
      ),
    );
  }
}