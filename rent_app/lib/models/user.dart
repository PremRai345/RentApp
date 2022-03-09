class User {
  late String uuid;
  late String? name;
  late String? email;
  late String? image;
  late String? photoUrl;
  late String? address;
  late int? age;

  User({
    required this.uuid,
    required this.name,
    required this.email,
    required this.address,
    required this.image,
    required this.photoUrl,
    required this.age,
  });

  User.fromJson(Map obj) {
    uuid = obj["uuid"];
    name = obj["name"];
    email = obj["email"];
    image = obj["image"];
    photoUrl = obj["photoUrl"];
    address = obj["address"];
    age = obj["age"];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["uuid"] = uuid;
    map["name"] = name;
    map["email"] = email;
    map["image"] = image;
    map["address"] = address;
    map["age"] = age;

    return map;
  }
}
