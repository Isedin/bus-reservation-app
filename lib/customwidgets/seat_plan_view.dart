import 'package:bus_reservation_flutter_starter/utils/colors.dart';
import 'package:flutter/material.dart';

class SeatPlanView extends StatelessWidget {
  const SeatPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Seat extends StatefulWidget {
  final String label;
  final bool isBooked;
  final Function(bool) onSelect;
  const Seat(
      {super.key,
      required this.label,
      required this.isBooked,
      required this.onSelect});

  @override
  State<Seat> createState() => _SeatState();
}

class _SeatState extends State<Seat> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: widget.isBooked
                ? seatBookedColor
                : (selected ? seatSelectedColor : seatAvailableColor),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: widget.isBooked
                ? null
                : [
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.grey.shade400,
                      offset: const Offset(4, 4),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ]),
        child: Text(widget.label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ),
    );
  }
}
