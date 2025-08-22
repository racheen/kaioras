import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';

class FirebaseBookingsRepository {
  const FirebaseBookingsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<List<Booking>> fetchAllBookings() {
    return Future.value([]);
  }

  Future<void> addBooking(String businessId, Booking newBooking) async {
    final blockId = newBooking.blockId;

    final docRef = _firestore
        .collection('businesses/$businessId/blocks/$blockId/bookings')
        .doc();
    final bookingId = docRef.id;

    newBooking.bookingId = bookingId;
    await docRef.set(newBooking.toJson());
  }

  DocumentReference<Map<String, dynamic>> queryBookingById(
    String businessId,
    String blockId,
    String bookingId,
  ) {
    return _firestore.doc(
      'businesses/$businessId/blocks/$blockId/bookings/$bookingId',
    );
  }

  Future<void> updateBooking(
    String businessId,
    String blockId,
    Booking existingBooking,
  ) async {
    final bookings = queryBookingById(
      businessId,
      blockId,
      existingBooking.bookingId!,
    );

    await bookings.set(existingBooking.toJson());
  }

  Query<Booking> queryBookings(String businessId, String blockId) {
    return _firestore
        .collection('businesses/$businessId/blocks/$blockId/bookings')
        .withConverter(
          fromFirestore: (snapshot, _) =>
              Booking.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (booking, _) {
            return booking.toJson();
          },
        );
  }

  Future<bool> verifyBookingAvailability(
    String businessId,
    String blockId,
    int capacityLimit,
  ) async {
    bool hasAvailability = false;
    final bookings = await queryBookings(
      businessId,
      blockId,
    ).where('status', isEqualTo: BookingStatus.booked.name).get();

    final currentCapacity = bookings.docs
        .map((doc) => doc.data())
        .toList()
        .length;

    if (currentCapacity < capacityLimit) {
      hasAvailability = true;
    }
    return hasAvailability;
  }

  Future<Booking?> verifyExistingBooking({
    required businessId,
    required blockId,
    required uid,
  }) async {
    try {
      final bookings = await queryBookings(
        businessId,
        blockId,
      ).where('uid', isEqualTo: uid).get();

      return bookings.docs.map((doc) => doc.data()).first;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<bool> verifyExistingWaitlisting({
    required businessId,
    required blockId,
    required uid,
  }) async {
    bool hasExistingWaitlist = false;
    final bookings = await queryBookings(businessId, blockId)
        .where('uid', isEqualTo: uid)
        .where('status', isEqualTo: 'waitlisted')
        .get();

    if (bookings.docs.map((doc) => doc.data()).isNotEmpty) {
      hasExistingWaitlist = true;
    }

    return hasExistingWaitlist;
  }

  Query<Booking> queryUserBookings(String uid) {
    return _firestore
        .collection('users/$uid/bookings')
        .withConverter(
          fromFirestore: (snapshot, _) =>
              Booking.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (booking, _) {
            return booking.toJson();
          },
        );
  }

  List<Map<String?, String?>> _convertBookingsToMapList(
    List<Booking> bookings,
  ) {
    List<Map<String?, String?>> list = [];
    for (int i = 0; i < bookings.length; i++) {
      list.add({bookings[i].blockId: bookings[i].status});
    }
    return list;
  }

  Future<List<Map<String?, String?>>> fetchBookings(uid) async {
    final userBookings = await queryUserBookings(uid).get();
    return _convertBookingsToMapList(
      userBookings.docs.map((doc) => doc.data()).toList(),
    );
  }

  Future<List<Booking>> fetchUserBookings(uid) async {
    final userBookings = await queryUserBookings(
      uid,
    ).where('status', isEqualTo: BookingStatus.booked.name).get();
    return userBookings.docs.map((doc) => doc.data()).toList();
  }

  Future<void> setUserBooking(String uid, Booking booking) async {
    final userBookingsRef = _firestore.doc(
      'users/$uid/bookings/${booking.bookingId}',
    );

    await userBookingsRef.set(booking.toJson());
  }
}

final bookingsRepositoryProvider = Provider((Ref ref) {
  return FirebaseBookingsRepository(FirebaseFirestore.instance);
});

final bookingsFutureProvider = FutureProvider.autoDispose
    .family<List<Map<String?, String?>>, String>((ref, uid) {
      final bookingsRepository = ref.watch(bookingsRepositoryProvider);
      return bookingsRepository.fetchBookings(uid);
    });
