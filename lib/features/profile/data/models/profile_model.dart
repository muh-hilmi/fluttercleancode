import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  final String firstName;
  final String lastName;
  final String avatar;

  const ProfileModel({
    required super.id,
    required super.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  }) : super(
          fullName: '$firstName $lastName',
          profileImageURL: avatar,
        );

//Map => ProfileModel
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }

//ProfileModel => Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
    };
  }

  //List<Map> => List<ProfileModel>
  static List<ProfileModel> fromJsonList(List json) {
    if (json.isEmpty) return [];

    return json.map((profile) => ProfileModel.fromJson(profile)).toList();
  }
}
