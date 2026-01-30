import 'package:bus_reservation_flutter_starter/models/bus_schedule.dart';
import 'package:flutter/material.dart';

class BookingConfirmationPage extends StatefulWidget {
  const BookingConfirmationPage({super.key});

  @override
  State<BookingConfirmationPage> createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  late BusSchedule schedule;
  late String departureDate;
  late int totalSeatBooked = 0;
  late String seatNumbers;
  bool isFirst = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    nameController.text = 'Name';
    phoneController.text = 'Phone';
    emailController.text = 'Email';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isFirst) {
      final argList =
          ModalRoute.of(context)!.settings.arguments as List<dynamic>;
      departureDate = argList[0];
      schedule = argList[1];
      seatNumbers = argList[2];
      totalSeatBooked = argList[3];
      isFirst = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Please provide your details.',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    // labelText: 'Name',
                    hintText: 'Enter your name',
                    filled: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ],
          )),
    );
  }
}
