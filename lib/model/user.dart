class UserItem {
  String? name;
  String? userEmail;

  UserItem({this.name, this.userEmail});

  factory UserItem.fromJson(Map<String, dynamic> parsedJson) {
    return UserItem(
      name: parsedJson['name'] ?? "",
      userEmail: parsedJson['userEmail'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "userEmail": userEmail};
  }
}
