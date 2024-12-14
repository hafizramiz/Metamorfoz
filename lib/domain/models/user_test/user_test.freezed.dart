// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserTest _$UserTestFromJson(Map<String, dynamic> json) {
  return _UserTest.fromJson(json);
}

/// @nodoc
mixin _$UserTest {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserTestCopyWith<UserTest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserTestCopyWith<$Res> {
  factory $UserTestCopyWith(UserTest value, $Res Function(UserTest) then) =
      _$UserTestCopyWithImpl<$Res, UserTest>;
  @useResult
  $Res call({int? id, String? name, String? username, String? email});
}

/// @nodoc
class _$UserTestCopyWithImpl<$Res, $Val extends UserTest>
    implements $UserTestCopyWith<$Res> {
  _$UserTestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? username = freezed,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserTestImplCopyWith<$Res>
    implements $UserTestCopyWith<$Res> {
  factory _$$UserTestImplCopyWith(
          _$UserTestImpl value, $Res Function(_$UserTestImpl) then) =
      __$$UserTestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? name, String? username, String? email});
}

/// @nodoc
class __$$UserTestImplCopyWithImpl<$Res>
    extends _$UserTestCopyWithImpl<$Res, _$UserTestImpl>
    implements _$$UserTestImplCopyWith<$Res> {
  __$$UserTestImplCopyWithImpl(
      _$UserTestImpl _value, $Res Function(_$UserTestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? username = freezed,
    Object? email = freezed,
  }) {
    return _then(_$UserTestImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserTestImpl implements _UserTest {
  const _$UserTestImpl({this.id, this.name, this.username, this.email});

  factory _$UserTestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserTestImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? username;
  @override
  final String? email;

  @override
  String toString() {
    return 'UserTest(id: $id, name: $name, username: $username, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserTestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, username, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserTestImplCopyWith<_$UserTestImpl> get copyWith =>
      __$$UserTestImplCopyWithImpl<_$UserTestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserTestImplToJson(
      this,
    );
  }
}

abstract class _UserTest implements UserTest {
  const factory _UserTest(
      {final int? id,
      final String? name,
      final String? username,
      final String? email}) = _$UserTestImpl;

  factory _UserTest.fromJson(Map<String, dynamic> json) =
      _$UserTestImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get username;
  @override
  String? get email;
  @override
  @JsonKey(ignore: true)
  _$$UserTestImplCopyWith<_$UserTestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
