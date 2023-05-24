class Lists {
  final String name;
  final String userId;

  Lists({
    required this.name,
    required this.userId,
  }) {}

  factory Lists.fromMap(Map<String, dynamic> json) => Lists(
        name: json["name"],
        userId: json["userId"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "userId": userId,
      };
}
