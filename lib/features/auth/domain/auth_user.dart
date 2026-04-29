/// AuthUser — Domain model for authenticated user
class AuthUser {
  final String id;
  final String? phone;
  final String? email;
  final String name;
  final String? school;
  final String? state;
  final String? examTarget;
  final DateTime? examDate;
  final String subscriptionStatus; // FREE | PREMIUM | FAMILY | INSTITUTION
  final int xpTotal;
  final int streakCurrent;
  final String languagePref; // ENGLISH | PIDGIN | BOTH
  final String? avatarUrl;

  const AuthUser({
    required this.id,
    this.phone,
    this.email,
    required this.name,
    this.school,
    this.state,
    this.examTarget,
    this.examDate,
    required this.subscriptionStatus,
    required this.xpTotal,
    required this.streakCurrent,
    required this.languagePref,
    this.avatarUrl,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String,
      school: json['school'] as String?,
      state: json['state'] as String?,
      examTarget: json['examTarget'] as String?,
      examDate: json['examDate'] != null
          ? DateTime.parse(json['examDate'] as String)
          : null,
      subscriptionStatus: json['subscriptionStatus'] as String? ?? 'FREE',
      xpTotal: json['xpTotal'] as int? ?? 0,
      streakCurrent: json['streakCurrent'] as int? ?? 0,
      languagePref: json['languagePref'] as String? ?? 'ENGLISH',
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'name': name,
      'school': school,
      'state': state,
      'examTarget': examTarget,
      'examDate': examDate?.toIso8601String(),
      'subscriptionStatus': subscriptionStatus,
      'xpTotal': xpTotal,
      'streakCurrent': streakCurrent,
      'languagePref': languagePref,
      'avatarUrl': avatarUrl,
    };
  }

  AuthUser copyWith({
    String? id,
    String? phone,
    String? email,
    String? name,
    String? school,
    String? state,
    String? examTarget,
    DateTime? examDate,
    String? subscriptionStatus,
    int? xpTotal,
    int? streakCurrent,
    String? languagePref,
    String? avatarUrl,
  }) {
    return AuthUser(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      name: name ?? this.name,
      school: school ?? this.school,
      state: state ?? this.state,
      examTarget: examTarget ?? this.examTarget,
      examDate: examDate ?? this.examDate,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      xpTotal: xpTotal ?? this.xpTotal,
      streakCurrent: streakCurrent ?? this.streakCurrent,
      languagePref: languagePref ?? this.languagePref,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  bool get isPremium => subscriptionStatus != 'FREE';
  bool get hasExamDate => examDate != null;
  
  int get daysUntilExam {
    if (examDate == null) return 0;
    return examDate!.difference(DateTime.now()).inDays;
  }
}
