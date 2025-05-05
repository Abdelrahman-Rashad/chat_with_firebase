import 'package:equatable/equatable.dart';

class UserFirebase extends Equatable {
  final String uid;
  final String name;
  final String email;
  final List<String> blockedUsers;

  const UserFirebase({
    required this.uid,
    required this.name,
    required this.email,
    this.blockedUsers = const [],
  });

  factory UserFirebase.fromMap(Map<String, dynamic> map) {
    return UserFirebase(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      blockedUsers: List<String>.from(map['blockedUsers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'blockedUsers': blockedUsers,
    };
  }

  UserFirebase copyWith({
    String? uid,
    String? name,
    String? email,
    List<String>? blockedUsers,
  }) {
    return UserFirebase(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }

  bool isBlocked(String userId) => blockedUsers.contains(userId);

  @override
  List<Object?> get props => [uid, name, email, blockedUsers];
}
