// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/booking/booking_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../domain/models/booking/booking_summary.dart';
import '../../../domain/models/user/user.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

/// Homeview model icinde birden fazla repository kullanilabilir.
/// Bu ornekte BookingRepository ve UserRepository kullanilmistir.
/// Aralarında  many to many iliski vardır.
/// Reposıtorler vıew model ıcınde private olarak tanımlanır.
/// Diger turlu view'dan direkt repository'e erisim saglanabilir.
/// Bunu istemiyoruz. Cunku view direk repository'e erismemesi gerekir
/// Repository Data Layerdir. Ama view UI Layerdir.
///
/// Kullanici homeview'a geldiginde home view modeli olusturulur.
/// _load metotu isini bitirene kadar UI state bos durumdadir.
/// View bu durumda loading indicator gosterir.
/// _Load metotu isini bitirince eger basarili ise yeni data view modelde olur
/// ve view'a haber verilir. View'da bunu gosterir.Ona gore UI yeniden render edilir.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required BookingRepository bookingRepository,
    required UserRepository userRepository,
  })  : _bookingRepository = bookingRepository,
        _userRepository = userRepository {

    /// Burda Command ChangeNotifier sinifindan extend almis baska bir siniftir,
    /// Basitce ornegi boyledir.Command constractorunda bir class parametersei almasi
    /// zorunlu kilar. Buda variable degil de bir actiondir. Yani bir fonksiyon.
    /// Aldigi fonksiyonu bir String deger aliyor gibi de dusunebiliriz.
    /// execute classin metotudur. action paramaterdir. Ama execute bir class metotudur.
    /// Bunu aldiktan sonra Nasil ki Changenotifieri bir widget agacinda enjekte ederken
    /// ChangeNotifierProvider ile enjekte edip sonra ..init yapip metotdu cagiriyorsak bunu da
    /// ayni sekilde yapabiliriz.
    /// load = Command0(_load)..execute(); Burda yapilan da odur. Aksiyonu ver. Daha sonra execute et
    /// Parametre olarak verdigimiz Ilgili aksiyon execute icinde cagrilir.
    /// class Command extends ChangeNotifier {
    //   Command(this._action);
    // void Function() _action;
    //
    // void execute() {
    //   // run _action
    // }
    //   }

    load = Command0(_load)..execute();
    deleteBooking = Command1(_deleteBooking);
  }

  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;

  /// Loglari yonetmek icin kullanilan bir paket var.logging: ^1.2.0
  /// Bu paket kullanilarak loglama yapilabilir.Once bir nesne olustur. Daha sonra
  final _log = Logger('HomeViewModel');

  /// metotlarini kullan.

  List<BookingSummary> _bookings = [];
  User? _user;

  late Command0 load;
  late Command1<void, int> deleteBooking;

  List<BookingSummary> get bookings => _bookings;

  User? get user => _user;

  /// [_load] methodu ile veriler cekilir.
  /// Bu metot repository katmanina gider ordaki metotu calistirir.
  /// Bu bir metotdur. Bu metot ne donerse Command pattern icinde
  /// bunu elde edecegiz.
  /// _result = await action(); bu satirda action calistirilir.
  Future<Result> _load() async {
    _log.fine('home _load started');

    /// Fine leveldaki loglama icin kullanilir.
    _log.config("config");
    _log.info(":info");
    _log.warning("warning");

    try {
      /// View model Reposirotry katmanina baglanir.
      /// Repository katmani da service cikar ve verileri getirir.
      final result = await _bookingRepository.getBookingsList();
      /// Donen sonuca gore islem yapilir.
      switch (result) {
        case Ok<List<BookingSummary>>():
          _bookings = result.value;
          _log.fine('Loaded bookings');
        case Error<List<BookingSummary>>():
          _log.warning('Failed to load bookings', result.error);
          return result;
      }

      final userResult = await _userRepository.getUser();
      switch (userResult) {
        case Ok<User>():
          _user = userResult.value;
          _log.fine('Loaded user');
        case Error<User>():
          _log.warning('Failed to load user', userResult.error);
      }

      return userResult;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteBooking(int id) async {
    print("_deleteBooking started");
    try {
      final resultDelete = await _bookingRepository.delete(id);
      switch (resultDelete) {
        case Ok<void>():
          _log.fine('Deleted booking $id');
        case Error<void>():
          _log.warning('Failed to delete booking $id', resultDelete.error);
          return resultDelete;
      }

      // After deleting the booking, we need to reload the bookings list.
      // BookingRepository is the source of truth for bookings.
      final resultLoadBookings = await _bookingRepository.getBookingsList();
      switch (resultLoadBookings) {
        case Ok<List<BookingSummary>>():
          _bookings = resultLoadBookings.value;
          _log.fine('Loaded bookings');
        case Error<List<BookingSummary>>():
          _log.warning('Failed to load bookings', resultLoadBookings.error);
          return resultLoadBookings;
      }

      return resultLoadBookings;
    } finally {
      notifyListeners();
    }
  }
}

/// UI State nedir?
/// View modelin view'a gonderdigi data UI State olarak bilinir.
/// Bu data sayesinde view tarafinda UI render edilir.UI state
/// immutable olmalidir. Yani degistirilemez.
