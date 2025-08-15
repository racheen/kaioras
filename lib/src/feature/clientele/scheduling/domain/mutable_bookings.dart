import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';

extension MutableBookings on List<Booking> {
  List<Booking> filter(String status) {
    return where((booking) => booking.status == status).toList();
  }

  bool exists(String uid) {
    for (Booking booking in this) {
      if (booking.user.uid == uid) {
        return true;
      }
    }
    return false;
  }

  bool hasBooked(String uid) {
    final filteredList = where(
      (booking) => booking.status == BookingStatus.booked.name,
    ).toList();
    return filteredList.exists(uid);
  }

  bool hasCancelled(String uid) {
    final filteredList = where(
      (booking) => booking.status == BookingStatus.cancelled.name,
    ).toList();
    return filteredList.exists(uid);
  }

  bool hasWaitlisted(String uid) {
    final filteredList = where(
      (booking) => booking.status == BookingStatus.waitlisted.name,
    ).toList();
    return filteredList.exists(uid);
  }

  bool hasAttended(String uid) {
    final filteredList = where(
      (booking) => booking.status == BookingStatus.attended.name,
    ).toList();
    return filteredList.exists(uid);
  }
}
