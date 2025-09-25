// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/assets.dart';
import '../model/booking/booking.dart';

/// Allows the user to save and restore bookings.
///
/// Bookings are stored in memory for demo purposes,
/// so they are lost when the server stops.
///
/// For demo purposes, this API includes a default pre-generated booking.
///
/// The [Booking.id] is also the index in the bookings list.
class BookingApi {
  BookingApi() {
    // Create a default booking
    final destination = Assets.destinations.first;
    final activitiesRef = Assets.activities
        .where((activity) => activity.destinationRef == destination.ref)
        .map((activity) => activity.ref)
        .toList();
    _bookings.add(
      Booking(
        id: _sequentialId++,
        name: '${destination.name}, ${destination.continent}',
        startDate: DateTime(2024, 7, 20),
        endDate: DateTime(2024, 8, 15),
        destinationRef: destination.ref,
        activitiesRef: activitiesRef,
      ),
    );
  }

  // Bookings are kept in memory for demo purposes.
  // To keep things simple, the id is also the index in the list.
  final List<Booking> _bookings = List.empty(growable: true);

  // Used to generate IDs for bookings
  int _sequentialId = 0;

  Router get router {
    final router = Router();

    // Get User bookings
    router.get('/', (Request request) {
      return Response.ok(
        json.encode(_bookings),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // Get a booking by id
    router.get('/<id>', (Request request, String id) {
      final bookingId = int.parse(id);
      final booking =
          _bookings.firstWhereOrNull((booking) => booking.id == bookingId);

      if (booking == null) {
        return Response.notFound('Invalid id');
      }

      return Response.ok(
        json.encode(booking),
        headers: {'Content-Type': 'application/json'},
      );
    });


    /// Http request'lerde created response'i gondermek istiyorsan 201 gonder.
    /// 201 gelen post request'in basariyla olusturuldugunu gosterir.
    // Save a new booking
    /// Buraya request olarak gelen model de Booking modelidir.
    /// Booking modeli aliyor tekrar ayni modeli donuyor.
    /// Id'sini artirip yeni id ile birlikte donuyor.
    /// Kodu 201 olarak doner.
    router.post('/', (Request request) async {
      final body = await request.readAsString();
      final booking = Booking.fromJson(json.decode(body));

      if (booking.id != null) {
        // POST endpoint only allows newly created bookings
        return Response.badRequest(
            body: 'Booking already has id, use PUT instead.');
      }

      // Add ID to new booking
      final bookingWithId = booking.copyWith(id: _sequentialId++);

      // Store booking
      _bookings.add(bookingWithId);

      // Respond with newly created booking
      /// Yeni olusturulan obje tekrar geri dondurulur.
      /// Kodu 201 olarak doner.
      return Response(
        201, // created
        body: json.encode(bookingWithId),
        headers: {'Content-Type': 'application/json'},
      );
    });

    /// Delete yaparken geriye herhangi bir model donulmuyor.
    /// Sadece 204 kodu donuluyor. Eger basarili ise 204 doner
    /// Eger silemezse Invalid id doner. Ilgili id'yi bulamamamis demektir.
/// Delete islemi id uzerinden yapilir. Request (id parametre üzerinden) gerceklestirilir
    ///
    // Delete booking
    router.delete('/<id>', (Request request, String id) async {
      final bookingId = int.parse(id);
      final booking =
          _bookings.firstWhereOrNull((booking) => booking.id == bookingId);
      if (booking == null) {
        return Response.notFound('Invalid id');
      }
      _bookings.remove(booking);
      /// Delete yaparken 204 no content kodu donulur.
      // 204: no content
      return Response(204);
    });

    return router;
  }
}
