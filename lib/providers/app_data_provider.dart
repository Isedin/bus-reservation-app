import 'package:bus_reservation_flutter_starter/datasource/data_source.dart';
import 'package:bus_reservation_flutter_starter/datasource/dummy_data_source.dart';
import 'package:bus_reservation_flutter_starter/models/bus_reservation.dart';
import 'package:bus_reservation_flutter_starter/models/bus_route.dart';
import 'package:bus_reservation_flutter_starter/models/bus_schedule.dart';
import 'package:flutter/material.dart';

class AppDataProvider extends ChangeNotifier {
  List<BusSchedule> _scheduleList = [];
  List<BusSchedule> get scheduleList => _scheduleList;
  final DataSource _dataSource = DummyDataSource();

  Future<BusRoute?> getRouteByCityFromAndCityTo(
      String cityFrom, String cityTo) async {
    return _dataSource.getRouteByCityFromAndCityTo(cityFrom, cityTo);
  }

  Future<List<BusSchedule>> getSchedulesByRouteName(String routeName) async {
    return _dataSource.getSchedulesByRouteName(routeName);
  }

  Future<List<BusReservation>> getReservationsByScheduleAndDepartureDate(
      int scheduleId, String departureDate) {
    return _dataSource.getReservationsByScheduleAndDepartureDate(
        scheduleId, departureDate);
  }
}
