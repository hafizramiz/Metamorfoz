// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import '../../../utils/result.dart';
import 'model/login_request/login_request.dart';
import 'model/login_response/login_response.dart';

// Peki login api'ya geri donelim. Login basarili olursa LoginResponse model donuyor. 
//Client'ta headers: {'Content-Type': 'application/json'}, kismina bakip bunun
// json oldugunu anlayip ona gore bir json parsing yapabilir. Eger isterse.
// Simdi gelelim client tarafina client donen veri ile ne yapacak?







class AuthApiClient {
  AuthApiClient({
    String? host,
    int? port,
    HttpClient Function()? clientFactory,
  })  : _host = host ?? 'localhost',
        _port = port ?? 8080,
        _clientFactory = clientFactory ?? (() => HttpClient());

  final String _host;
  final int _port;
  final HttpClient Function() _clientFactory;


  /// Burda iki farkli model kullanilir. Request ve Response.
  /// Request atarken credetial bilgileri gonderilir.
  /// Response olarak da token dondurulur.
/// Burda bir create islemi olmadigi icin status code 200 doner.
  /// Eger bir Create yapsaydi 201 donecekti.
  /// Simdi client burda istek atar. Bunun icin LoginRequest modeli kullanir
  /// ve bu modelde email ve password bilgileri bulunur. Yani credential bilgileri.
  Future<Result<LoginResponse>> login(LoginRequest loginRequest) async {
    final client = _clientFactory();
    try {
      print("object");
      /// Burda istek login endpointine atilir.
      /// Istek atarken post metodu kullanilir cunku credential bilgileri gonderilir
      final request = await client.post(_host, _port, '/login');
      request.write(jsonEncode(loginRequest));
      final response = await request.close();

/// Burda donen sonuca gore islem yapilir.
// AuthApiClient dosyanızdaki kod, sunucudan gelen Content-Type başlığına
//  dolaylı olarak güvenir. Kodunuzda if (response.headers['Content-Type'] == 'application/json') 
//  gibi doğrudan bir kontrol yapılmıyor. Ancak bu, başlığın önemsiz olduğu anlamına gelmez.
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        return Result.ok(LoginResponse.fromJson(jsonDecode(stringData)));
      } else {
        return const Result.error(HttpException("Login error"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }








}



// AuthApiClient dosyanızdaki kod, sunucudan gelen Content-Type başlığına dolaylı olarak güvenir. 
//Kodunuzda if (response.headers['Content-Type'] == 'application/json') gibi doğrudan bir kontrol yapılmıyor.
// Ancak bu, başlığın önemsiz olduğu anlamına gelmez.

// İşte süreç nasıl işliyor:

// Güven Varsayımı: İstemci (Flutter uygulaması), sunucunun API sözleşmesine uyacağını varsayar. Yani,
// başarılı bir giriş (200 OK) yanıtının gövdesinin (body) JSON formatında olacağına güvenir.
// Doğrudan Çözümleme: Kodunuz, yanıt geldikten sonra jsonDecode(response.body) satırını çalıştırır.
// Bu satır, gelen metni (body) doğrudan JSON olarak ayrıştırmaya çalışır.
// Dolaylı Kontrol:
// Eğer sunucu sözünü tutup Content-Type: application/json başlığıyla birlikte geçerli bir
// JSON metni gönderirse, jsonDecode işlemi başarılı olur.
// Eğer sunucu bir hata nedeniyle JSON yerine bir HTML hata sayfası veya düz metin gönderirse, 
//jsonDecode işlemi bir FormatException fırlatır ve kodunuz hata verir. Bu durum, try-catch bloğu tarafından yakalanır.
/// / ...existing code...
//   Future<LoginResponse> login({
//     required String email,
//     required String password,
//   }) async {
//     final loginRequest = LoginRequest(email: email, password: password);
//     final response = await _httpClient.post(
//       Uri.parse('${Constants.baseUrl}/login/'),
//       body: jsonEncode(loginRequest.toJson()),
//     );

//     if (response.statusCode == 200) {
//       // BU NOKTADA, sunucudan gelen 'Content-Type' başlığına dolaylı olarak güveniriz.
//       // Gelen yanıtın (response.body) JSON formatında olduğunu varsayarak
//       // doğrudan 'jsonDecode' fonksiyonunu çağırırız.
//       //
//       // Eğer sunucu, sözleşmeye aykırı olarak JSON yerine başka bir format
//       // (örn: bir hata durumunda HTML sayfası) gönderirse, aşağıdaki satır
//       // bir 'FormatException' fırlatır ve kod 'catch' bloğuna düşer.
//       // Yani header'ı bir 'if' ile kontrol etmesek de, bu satır onun görevini
//       // dolaylı yoldan yapmış olur.
//       final json = jsonDecode(response.body) as Map<String, dynamic>;
//       return LoginResponse.fromJson(json);
//     } else {
//       throw Exception('Failed to login');
//     }
//   }
// }