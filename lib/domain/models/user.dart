import 'package:equatable/equatable.dart';
import 'package:wishes_app/domain/models/follower.dart';

enum Gender {
  male,
  female;

  String toJson() {
    switch (this) {
      case Gender.female:
        return "female";

      default:
        return "male";
    }
  }

  static Gender fromJson(String data) {
    switch (data) {
      case "female":
        return Gender.female;

      default:
        return Gender.male;
    }
  }
}

class User extends Equatable {
  final String id;
  final String displayName;
  final String? photoUrl;
  final Gender gender;
  final String? birthDate;
  final String? phone;
  final String? email;
  final List<Follower> follows;
  final List<Follower> followedBy;

  const User({
    required this.id,
    required this.displayName,
    required this.follows,
    required this.followedBy,
    required this.gender,
    this.birthDate,
    this.photoUrl,
    this.phone,
    this.email,
  });

  factory User.empty() {
    return const User(
      id: '',
      displayName: '',
      follows: [],
      followedBy: [],
      gender: Gender.male,
    );
  }

  bool get isEmpty => id == User.empty().id;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'display_name': displayName,
      'photo_url': photoUrl,
      'phone': phone,
      'email': email,
      'follows': follows.map((x) => x.toJson()).toList(),
      'followed_by': followedBy.map((x) => x.toJson()).toList(),
      'birth_date': birthDate,
      'gender': gender.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      displayName: map['display_name'] as String,
      photoUrl: map['photo_url'] != null ? map['photo_url'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      gender: map['gender'] != null ? Gender.fromJson(map['gender']) : Gender.male,
      birthDate: map['birth_date'] != null ? map['birth_date'] as String : null,
      follows: map['follows'] == null
          ? []
          : List<Follower>.from(
              (map['follows'] as List<dynamic>).map<Follower>(
                (x) => Follower.fromJson(x as Map<String, dynamic>),
              ),
            ),
      followedBy: map['followed_by'] == null
          ? []
          : List<Follower>.from(
              (map['followed_by'] as List<dynamic>).map<Follower>(
                (x) => Follower.fromJson(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        gender,
        birthDate,
        photoUrl,
        phone,
        email,
        follows,
        followedBy,
      ];
}
