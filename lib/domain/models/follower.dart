import 'package:equatable/equatable.dart';

class Follower extends Equatable {
  final String id;
  final String displayName;
  final String? photoUrl;

  const Follower({
    required this.id,
    required this.displayName,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'display_name': displayName,
      'photo_url': photoUrl,
    };
  }

  factory Follower.fromJson(Map<String, dynamic> map) {
    return Follower(
      id: map['id'] as String,
      displayName: map['display_name'] as String,
      photoUrl: map['photo_url'] != null ? map['photo_url'] as String : null,
    );
  }

  @override
  List<Object?> get props => [id, displayName, photoUrl];
}
