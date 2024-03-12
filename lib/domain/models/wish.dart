import 'package:equatable/equatable.dart';
import 'package:wishes_app/domain/models/user.dart';

class Wish extends Equatable {
  final String id;
  final String name;
  final String? description;
  final int? price;
  final String? link;
  final String? imageLink;
  final bool isArchived;
  final String? reservedById;
  final User user;

  const Wish({
    required this.id,
    required this.name,
    required this.isArchived,
    required this.user,
    this.description,
    this.price,
    this.imageLink,
    this.link,
    this.reservedById,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'is_archived': isArchived,
      'link': link,
      'image': imageLink,
      'reserved_by_id': reservedById,
      'user': user.toJson(),
    };
  }

  factory Wish.fromJson(Map<String, dynamic> map) {
    return Wish(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] != null ? map['description'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
      isArchived: map['is_archived'] != null ? map['is_archived'] as bool : false,
      imageLink: map['image'] != null ? map['image'] as String : null,
      link: map['link'] != null ? map['link'] as String : null,
      reservedById: map['reserved_by_id'] != null ? map['reserved_by_id'] as String : null,
      user: User.fromJson(map['user']),
    );
  }

  factory Wish.empty() => Wish(
        id: '',
        user: User.empty(),
        name: '',
        isArchived: false,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        isArchived,
        link,
        imageLink,
        reservedById,
        user,
      ];
}
