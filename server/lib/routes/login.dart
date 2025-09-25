// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/constants.dart';
import '../model/login_request/login_request.dart';
import '../model/login_response/login_response.dart';

/// Implements a simple login API.
///
/// This is provided as an example for Flutter architectural purposes only
/// and shouldn't be used as example on how to implement authentication
/// in production.
///
/// This API only accepts a fixed email and password for demonstration purposes,
/// then returns a hardcoded token and a user id.
///
/// This token does not expire and is not secure.
class LoginApi {
  Router get router {
    final router = Router();

    router.post('/', (Request request) async {
      final body = await request.readAsString();
      final loginRequest = LoginRequest.fromJson(json.decode(body));
/// Burda login basarili olursa bir kullanici Id ve token donduruluyor.
/// Bizim ornegimizde telefon numarasi donuyor. Biz bunu id ile degistirsek iyi olur
/// LoginResponseModel donuyoruz. 
      if (loginRequest.email == Constants.email &&
          loginRequest.password == Constants.password) {
        return Response.ok(
          json.encode(
            LoginResponse(
              token: Constants.token,
              userId: Constants.userId,
            ),
          ),
          /// Burdaki header icerigin json oldugunu belirtiyor.
          /// Bu header client tarafinda kullaniliyor aslinda. Sen header'a bakip
          /// aha bana gelen data json formatinda diyorsun ve json parse yontemi
          /// kullaniyorsun. Client gelen verinin ne oldugu burdan biliyor. Gelen veri
          /// bos bir text'de olabilir. Onun icin ayrica bakmak gerekiyor 
          /// o zaman nasil caliyiro diye
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.unauthorized('Invalid credentials');
    });

    return router;
  }
}





///
/// `router` getter'ı:
/// 1. Gelen isteğin gövdesini (body) okur ve JSON formatından `LoginRequest` nesnesine dönüştürür.
/// 2. Gelen e-posta ve şifrenin `Constants` içinde tanımlı olan sabit değerlerle eşleşip eşleşmediğini kontrol eder.
/// 3. Bilgiler doğruysa:
///    - `LoginResponse` nesnesi oluşturur (sabit bir token ve kullanıcı ID'si ile).
///    - Bu nesneyi JSON formatına çevirir.
///    - HTTP 200 OK durumu ile birlikte bu JSON verisini yanıt olarak döndürür.
/// 4. Bilgiler yanlışsa, HTTP 401 Unauthorized (Yetkisiz) durumu ile "Invalid credentials" mesajını döndürür.
///
/// `headers: {'Content-Type': 'application/json'}` kısmının eklenme sebebi:
/// Bu başlık (header), sunucunun istemciye (yani Flutter uygulamasına) gönderdiği yanıtın
/// gövdesinin (body) formatının ne olduğunu bildirir.
/// `'Content-Type': 'application/json'` ifadesi, "Bu yanıtın içeriği JSON formatındadır" anlamına gelir.
/// Bu sayede istemci, gelen veriyi nasıl işleyeceğini (parse edeceğini) bilir.
/// Eğer bu başlık eklenmezse, istemci gelen verinin düz bir metin mi, JSON mu, yoksa başka bir formatta mı
/// olduğunu anlayamaz ve veriyi doğru şekilde işleyemez. Bu, modern web API'lerinde standart bir uygulamadır.
 

 /// Header nedir? 
//  headers: {'Content-Type': 'application/json'} ifadesi, bir HTTP yanıtının (response) başlık (header) bölümünde yer alan bir
//   bilgidir ve sunucunun, istemciye (örneğin Flutter uygulamanıza) gönderdiği verinin doğası hakkında kritik bir ipucu verir.
// Bunu bir postane analojisiyle düşünebilirsiniz:

// Yanıtın Gövdesi (Response Body): Bu, gönderdiğiniz paketin içeriğidir. Bizim durumumuzda bu içerik, json.encode(...) ile oluşturulan
//  JSON verisidir (örneğin, {"token":"...","userId":"..."}).
// Content-Type bu etiketin en önemli kısımlarından biridir.

// Content-Type: "İçerik Türü" anlamına gelir. Bu etiket, paketin (yanıtın) içinde ne tür bir veri olduğunu söyler.
// 'application/json': Bu da içeriğin türünün JSON formatında olduğunu belirtir
// Neden Bu Kadar Önemli?

// İstemci (Flutter uygulamanız), sunucudan bir yanıt aldığında, ilk olarak bu "etikete" yani başlıklara bakar. 
//Content-Type: application/json etiketini gördüğünde anlar ki:

// "Tamam, bu paketin içindeki veri JSON formatında. Onu okumak için bir JSON çözücü (decoder) kullanmalıyım."

// Eğer bu başlığı göndermezseniz, istemci gelen verinin ne olduğunu bilemez. Varsayılan olarak onu düz bir metin (text/plain) 
//olarak kabul edebilir. Bu durumda, JSON olarak biçimlendirilmiş metni doğru bir şekilde nesnelere (örneğin Dart'taki bir Map'e) 
//dönüştüremez ve uygulamanızda hata alırsınız.

// Peki login api'ya geri donelim. Login basarili olursa LoginResponse model donuyor. 
//Client'ta headers: {'Content-Type': 'application/json'}, kismina bakip bunun
// json oldugunu anlayip ona gore bir json parsing yapabilir. Eger isterse.
// Simdi gelelim client tarafina client donen veri ile ne yapacak?
// Evet, kesinlikle doğru bir özet. İstemci, Content-Type başlığına bakarak veya (daha yaygın olarak) sunucunun 
// JSON göndereceğine güvenerek veriyi ayrıştırır.

// Şimdi en önemli kısma geldik: "İstemci bu token ile ne yapacak?"

// Sorunuzun cevabı kesinlikle evet. O token, gelecekteki tüm kimlik doğrulaması gerektiren istekler için bir anahtar görevi görür.

// İşte süreç adım adım nasıl işler:

// 1. Token'ı Güvenli Bir Yere Kaydetme: Kullanıcı başarıyla giriş yaptığında, istemci (Flutter uygulaması) 
// sunucudan gelen LoginResponse içindeki token'ı alır. Bu token, kullanıcının kimliğini temsil eden dijital bir
// imzadır. İstemci, bu token'ı uygulamanın yerel depolama alanına kaydeder. Genellikle bu işlem için flutter_secure_storage
//  gibi şifrelenmiş ve güvenli bir depolama paketi tercih edilir.
// 2.Sonraki İsteklerde Token'ı Kullanma: Kullanıcı artık giriş yapmış durumdadır. Uygulama içindeyken, kendi rezervasyonlarını 
// görmek (GET), yeni bir rezervasyon oluşturmak (POST), profilini güncellemek (PUT) veya bir veriyi silmek (DELETE) gibi işlemler 
// yapmak isteyebilir. Bu işlemler "korumalı" (protected) olarak adlandırılır, çünkü sadece kimliği doğrulanmış kullanıcılar 
// tarafından yapılabilmelidir.
// 3. İsteklere Authorization Başlığı Ekleme: İstemci, bu korumalı işlemler için sunucuya bir istek gönderirken,
// aldığı token'ı her isteğin HTTP isteğinin başlık (header) bölümüne Authorization başlığını ekler. 
//Bu başlık genellikle şu formatta olur:
// GET /api/bookings/my-bookings
// Host: your-api-server.com
// Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
//  (burası giriş yapıldığında alınan uzun token)
// 4. Sunucu Tarafında Doğrulama: Sunucu, /api/bookings/my-bookings gibi korumalı bir adrese istek aldığında,
// ilk olarak isteğin Authorization başlığını kontrol eder.

// Başlık yoksa veya geçersizse, sunucu isteği hemen reddeder ve genellikle 401 Unauthorized (Yetkisiz) veya 403 Forbidden (Yasak) hatası döndürür.
// Başlık varsa, sunucu token'ı alır, geçerliliğini (imzasını, süresinin dolup dolmadığını vb.) kontrol eder. Token geçerliyse, sunucu isteği kimin 
// yaptığını anlar ve işleme devam eder.