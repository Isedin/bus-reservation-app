import 'package:bus_reservation_flutter_starter/providers/app_data_provider.dart';
import 'package:bus_reservation_flutter_starter/utils/constants.dart';
import 'package:bus_reservation_flutter_starter/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? fromCity;
  String? toCity;
  DateTime? departureDate;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0),
              children: [
                DropdownButtonFormField<String>(
                    initialValue: fromCity,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return emptyFieldErrMessage;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(color: Colors.white)),
                    hint: const Text('Select Departure City'),
                    isExpanded: true,
                    items: cities
                        .map((city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        fromCity = value;
                      });
                    }),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                    initialValue: toCity,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return emptyFieldErrMessage;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(color: Colors.white)),
                    hint: const Text('Select Arrival City'),
                    isExpanded: true,
                    items: cities
                        .map((city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        toCity = value;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: _selectDate,
                          child: const Text('Select Departure Date')),
                      Text(departureDate == null
                          ? 'No date selected'
                          : getFormattedDate(departureDate!,
                              pattern: 'EEE MMM dd, yyyy')),
                    ],
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: _search, child: const Text('Search Buses')),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          departureDate = selectedDate;
        });
      }
    });
  }

  void _search() {
    if (departureDate == null) {
      showMsg(context, emptyDateErrMessage);
      return;
    }
    if (_formKey.currentState!.validate()) {
      Provider.of<AppDataProvider>(context, listen: false)
          .getRouteByCityFromAndCityTo(fromCity!, toCity!)
          .then((route) {
        if (route == null) {
          showMsg(context, 'No route found');
          return;
        }
        Navigator.pushNamed(context, routeNameSearchResultPage,
            arguments: [route, getFormattedDate(departureDate!)]);
      });
    }
  }
}
