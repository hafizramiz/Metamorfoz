// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/constants.dart';

/// Implements a simple user API.
///
/// This API only returns a hardcoded user for demonstration purposes.
///
/// UserApi, kullanıcı ile ilgili işlemleri yöneten bir API sınıfıdır.
/// Bu sınıf, shelf_router paketini kullanarak bir yönlendirici (router) oluşturur.
/// Yönlendirici, gelen HTTP isteklerini dinler ve uygun şekilde yanıt verir.
///
/// `router` getter'ı:
/// - Yeni bir `Router` nesnesi oluşturur.
/// - '/' yoluna (yani /api/user/) gelen GET isteklerini dinler.
/// - Bir istek geldiğinde, `Constants.user` verisini JSON formatına çevirir.
/// - HTTP 200 OK durumu ve JSON içeriği ile bir `Response` nesnesi döndürür.
/// - `Content-Type` başlığı 'application/json' olarak ayarlanır.
///
/// Kısacası, bu API'ye `/api/user/` adresine bir GET isteği yapıldığında,
/// `Constants.user` içinde tanımlı olan sabit kullanıcı bilgilerini JSON olarak döndürür.
class UserApi {
  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      return Response.ok(
        json.encode(Constants.user),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}
