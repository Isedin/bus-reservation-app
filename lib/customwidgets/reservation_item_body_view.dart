import 'package:bus_reservation_flutter_starter/models/reservation_expansion_item.dart';
import 'package:bus_reservation_flutter_starter/utils/constants.dart';
import 'package:flutter/material.dart';

class ReservationItemBodyView extends StatelessWidget {
  final ReservationExpansionBody body;
  const ReservationItemBodyView({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Customer Name: ${body.customer.customerName}'),
          Text('Phone: ${body.customer.mobile}'),
          Text('Email: ${body.customer.email}'),
          Text('Total Seats Booked: ${body.totalSeatBooked}'),
          Text('Seat Numbers: ${body.seatNumbers}'),
          Text('Total Price: ${body.totalPrice}$currency'),
        ],
      ),
    );
  }
}
