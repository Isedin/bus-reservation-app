import 'package:bus_reservation_flutter_starter/customwidgets/reservation_item_body_view.dart';
import 'package:bus_reservation_flutter_starter/customwidgets/reservation_item_header_view.dart';
import 'package:bus_reservation_flutter_starter/customwidgets/search_box.dart';
import 'package:bus_reservation_flutter_starter/models/bus_reservation.dart';
import 'package:bus_reservation_flutter_starter/models/reservation_expansion_item.dart';
import 'package:bus_reservation_flutter_starter/providers/app_data_provider.dart';
import 'package:bus_reservation_flutter_starter/utils/helper_functions.dart';
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
  List<BusReservation>? filteredReservations;
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
      appBar: AppBar(
        title: const Text('Reservations List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<AppDataProvider>(context, listen: false)
                  .getAllReservations();
              setState(() {
                filteredReservations =
                    null; // ako koristiš search filter, resetuj ga
              });
            },
          )
        ],
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, _) {
          final listToShow = filteredReservations ?? provider.reservationList;
          final items = provider.getExpansionItems(listToShow);

          return SingleChildScrollView(
            child: Column(
              children: [
                SearchBox(
                  onSubmit: (value) {
                    if (value.trim().isEmpty) {
                      setState(() => filteredReservations = null);
                      return;
                    }
                    _search(value.trim());
                  },
                ),
                ExpansionPanelList(
                  expansionCallback: (index, isExpanded) {
                    provider.toggleExpanded(listToShow[index]);
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
              ],
            ),
          );
        },
      ),
    );
  }

  void _search(String value) async {
    final data = await Provider.of<AppDataProvider>(context, listen: false)
        .getReservationsByMobile(value);
    if (data.isEmpty) {
      showMsg(context, 'No record found...');
      return;
    }
    setState(() {
      filteredReservations = data;
    });
  }
}
