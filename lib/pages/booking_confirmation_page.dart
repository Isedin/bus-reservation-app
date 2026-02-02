import 'package:bus_reservation_flutter_starter/models/bus_reservation.dart';
import 'package:bus_reservation_flutter_starter/models/bus_schedule.dart';
import 'package:bus_reservation_flutter_starter/models/customer.dart';
import 'package:bus_reservation_flutter_starter/providers/app_data_provider.dart';
import 'package:bus_reservation_flutter_starter/utils/constants.dart';
import 'package:bus_reservation_flutter_starter/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingConfirmationPage extends StatefulWidget {
  const BookingConfirmationPage({super.key});

  @override
  State<BookingConfirmationPage> createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  late BusSchedule schedule;
  late String departureDate;
  late int totalSeatsBooked = 0;
  late String seatNumbers;
  bool isFirst = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    nameController.text = 'Mr. Test';
    phoneController.text = '0123456789';
    emailController.text = 'test@example.com';
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
      totalSeatsBooked = argList[3];
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      // labelText: 'Name',
                      hintText: 'Enter your name',
                      filled: true,
                      prefixIcon: Icon(Icons.person)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return emptyFieldErrMessage;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      // labelText: 'Name',
                      hintText: 'Enter your phone number',
                      filled: true,
                      prefixIcon: Icon(Icons.phone)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return emptyFieldErrMessage;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      // labelText: 'Name',
                      hintText: 'Enter your email address',
                      filled: true,
                      prefixIcon: Icon(Icons.email)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return emptyFieldErrMessage;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Booking Summary',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer Name: ${nameController.text}'),
                      Text('Phone Number: ${phoneController.text}'),
                      Text('Email Address: ${emailController.text}'),
                      Text('Route: ${schedule.busRoute.routeName}'),
                      Text('Departure Date: $departureDate'),
                      Text('Departure Time: ${schedule.departureTime}'),
                      Text('Total Seats Booked: $totalSeatsBooked'),
                      Text('Seat Numbers: $seatNumbers'),
                      Text('Discount: ${schedule.discount}%'),
                      Text('Processing Fee: ${schedule.processingFee}%'),
                      Text(
                        'Grand Total: $currency${getGrandTotal(schedule.discount, totalSeatsBooked, schedule.ticketPrice, schedule.processingFee)}',
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: _confirmBooking,
                  child: const Text('Confirm Booking'))
            ],
          )),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _confirmBooking() {
    if (_formKey.currentState!.validate()) {
      final customer = Customer(
        customerName: nameController.text,
        mobile: phoneController.text,
        email: emailController.text,
      );

      final reservation = BusReservation(
          customer: customer,
          busSchedule: schedule,
          timestamp: DateTime.now().microsecondsSinceEpoch,
          departureDate: departureDate,
          totalSeatBooked: totalSeatsBooked,
          seatNumbers: seatNumbers,
          reservationStatus: reservationActive,
          totalPrice: getGrandTotal(schedule.discount, totalSeatsBooked,
              schedule.ticketPrice, schedule.processingFee));
      Provider.of<AppDataProvider>(context, listen: false)
          .addReservation(reservation)
          .then((response) {
        if (response.responseStatus == ResponseStatus.SAVED) {
          showMsg(context, response.message);
          Navigator.popUntil(context, ModalRoute.withName(routeNameHome));
        } else {
          showMsg(context, response.message);
        }
      }).catchError((error) {
        showMsg(context, 'Could not complete the booking. Please try again.');
      });
    }
  }
}
