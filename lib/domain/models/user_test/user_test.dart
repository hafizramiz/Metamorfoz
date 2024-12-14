/// Freezed ile model olusturma nasil yapilir
/// Once https://dartj.web.app/ adresinden freeezed secerek
/// modeli yazidir. Asagidaki cikacak

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_test.freezed.dart';
part 'user_test.g.dart';
@freezed
class UserTest with _$UserTest {
  const factory UserTest({
    int? id,
    String? name,
    String? username,
    String? email,
  }) = _UserTest;

  factory UserTest.fromJson(Map<String, Object?> json) =>
      _$UserTestFromJson(json);
}
/// Daha sonra partlari eklemen gerekiyor.
/// Yukardaki bu iki parti ekle
// part 'user_test.freezed.dart';
// part 'user_test.g.dart';
/// Daha sonra terminalden terminalde
/// flutter packages pub run build_runner build --delete-conflicting-outputs
/// komutunu calistir.