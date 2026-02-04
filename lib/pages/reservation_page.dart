import 'package:bus_reservation_flutter_starter/customwidgets/reservation_item_body_view.dart';
import 'package:bus_reservation_flutter_starter/customwidgets/reservation_item_header_view.dart';
import 'package:bus_reservation_flutter_starter/models/reservation_expansion_item.dart';
import 'package:bus_reservation_flutter_starter/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  bool isFirst = true;
  List<ReservationExpansionItem> expansionItems = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isFirst) return;
    isFirst = false;

    Provider.of<AppDataProvider>(context, listen: false).getAllReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservations List')),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, _) {
          final items = provider.getExpansionItems();
          final reservations = provider.reservationList;

          return SingleChildScrollView(
            child: ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                provider.toggleExpanded(reservations[index]);
              },
              children: items.map((item) {
                return ExpansionPanel(
                  isExpanded: item.isExpanded,
                  headerBuilder: (context, isExpanded) =>
                      ReservationItemHeaderView(header: item.header),
                  body: ReservationItemBodyView(body: item.body),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
