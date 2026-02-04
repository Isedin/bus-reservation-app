import 'package:bus_reservation_flutter_starter/utils/colors.dart';
import 'package:bus_reservation_flutter_starter/utils/constants.dart';
import 'package:flutter/material.dart';

class SeatPlanView extends StatelessWidget {
  final int totalSeats;
  final String bookedSeatsNumbers;
  final List<String> selectedSeats;
  final int totalSeatBooked;
  final bool isBusinessClass;
  final Function(bool, String) onSeatSelected;
  const SeatPlanView(
      {super.key,
      required this.totalSeats,
      required this.bookedSeatsNumbers,
      required this.totalSeatBooked,
      required this.isBusinessClass,
      required this.onSeatSelected,
      required this.selectedSeats});

  @override
  Widget build(BuildContext context) {
    final numberOfRows =
        (isBusinessClass ? totalSeats / 3 : totalSeats / 4).toInt();
    final numberOfColumns = isBusinessClass ? 3 : 4;
    List<List<String>> seatArrangement = [];
    for (int i = 0; i < numberOfRows; i++) {
      List<String> columns = [];
      for (int j = 0; j < numberOfColumns; j++) {
        columns.add('${seatLabelList[i]}${j + 1}');
      }
      seatArrangement.add(columns);
    }
    final List<String> bookedSeatsList = bookedSeatsNumbers.isEmpty
        ? []
        : bookedSeatsNumbers.split(',').map((e) => e.trim()).toList();
    final Set<String> selectedSet = selectedSeats.map((e) => e.trim()).toSet();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'FRONT',
            style: TextStyle(
              fontSize: 30,
              color: Colors.grey,
            ),
          ),
          const Divider(
            height: 2,
            color: Colors.black,
          ),
          Column(
            children: [
              for (int i = 0; i < seatArrangement.length; i++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int j = 0; j < seatArrangement[i].length; j++)
                      Row(
                        children: [
                          Seat(
                              label: seatArrangement[i][j],
                              isBooked: bookedSeatsList
                                  .contains(seatArrangement[i][j]),
                              isSelected:
                                  selectedSet.contains(seatArrangement[i][j]),
                              onSelect: (selected) {
                                onSeatSelected(selected, seatArrangement[i][j]);
                              }),
                          if (isBusinessClass && j == 0)
                            const SizedBox(
                              width: 24,
                            ),
                          if (!isBusinessClass && j == 1)
                            const SizedBox(
                              width: 24,
                            ),
                        ],
                      )
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }
}

class Seat extends StatelessWidget {
  final String label;
  final bool isBooked;
  final bool isSelected;
  final Function(bool) onSelect;

  const Seat({
    super.key,
    required this.label,
    required this.isBooked,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isBooked
          ? null
          : () {
              onSelect(!isSelected);
            },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isBooked
                ? seatBookedColor // booked seat
                : (isSelected
                    ? seatSelectedColor // selected seat
                    : seatAvailableColor), // available seat
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: isBooked
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
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
