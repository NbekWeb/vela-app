class WeeklyLoginStats {
  final String weekStart;
  final String weekEnd;
  final int totalLoginsThisWeek;
  final List<DayStats> days;

  WeeklyLoginStats({
    required this.weekStart,
    required this.weekEnd,
    required this.totalLoginsThisWeek,
    required this.days,
  });

  factory WeeklyLoginStats.fromJson(Map<String, dynamic> json) {
    List<DayStats> daysList = [];
    
    if (json['days'] != null) {
      if (json['days'] is List) {
        // New format: array of day objects
        final daysJson = json['days'] as List;
        daysList = daysJson.map((item) => DayStats.fromJson(item)).toList();
      } else if (json['days'] is Map) {
        // Old format: map with day names as keys
        final daysJson = json['days'] as Map<String, dynamic>;
        daysList = daysJson.values.map((value) => DayStats.fromJson(value)).toList();
      }
    }

    return WeeklyLoginStats(
      weekStart: json['week_start'] ?? '',
      weekEnd: json['week_end'] ?? '',
      totalLoginsThisWeek: json['total_logins_this_week'] ?? 0,
      days: daysList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week_start': weekStart,
      'week_end': weekEnd,
      'total_logins_this_week': totalLoginsThisWeek,
      'days': days.map((day) => day.toJson()).toList(),
    };
  }
}

class DayStats {
  final String name;
  final bool login;

  DayStats({
    required this.name,
    required this.login,
  });

  factory DayStats.fromJson(Map<String, dynamic> json) {
    return DayStats(
      name: json['name'] ?? '',
      login: json['login'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'login': login,
    };
  }
}

class CheckIn {
  final int id;
  final String checkInDate;
  final String checkInChoice;
  final String description;

  CheckIn({
    required this.id,
    required this.checkInDate,
    required this.checkInChoice,
    required this.description,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'] ?? 0,
      checkInDate: json['check_in_date'] ?? '',
      checkInChoice: json['check_in_choice'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'check_in_date': checkInDate,
      'check_in_choice': checkInChoice,
      'description': description,
    };
  }
}

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? avatar;
  final DateTime createdAt;
  final bool? userDeviceActive;
  final WeeklyLoginStats? weeklyLoginStats;
  final List<CheckIn> checkIns;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.avatar,
    required this.createdAt,
    this.userDeviceActive,
    this.weeklyLoginStats,
    this.checkIns = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parse weekly login stats
    WeeklyLoginStats? weeklyStats;
    if (json['weekly_login_stats'] != null) {
      if (json['weekly_login_stats'] is List) {
        // New format: direct array of day objects
        final daysJson = json['weekly_login_stats'] as List;
        final daysList = daysJson.map((item) => DayStats.fromJson(item)).toList();
        weeklyStats = WeeklyLoginStats(
          weekStart: '',
          weekEnd: '',
          totalLoginsThisWeek: daysList.where((day) => day.login).length,
          days: daysList,
        );
      } else {
        // Old format: WeeklyLoginStats object
        weeklyStats = WeeklyLoginStats.fromJson(json['weekly_login_stats']);
      }
    }

    // Parse check-ins
    List<CheckIn> checkInsList = [];
    if (json['check_in'] != null) {
      final checkInsJson = json['check_in'] as List;
      checkInsList = checkInsJson.map((item) => CheckIn.fromJson(item)).toList();
    }

    return UserModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      userDeviceActive: json['user_device_active'],
      weeklyLoginStats: weeklyStats,
      checkIns: checkInsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
      'user_device_active': userDeviceActive,
      'weekly_login_stats': weeklyLoginStats?.toJson(),
      'check_in': checkIns.map((checkIn) => checkIn.toJson()).toList(),
    };
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? avatar,
    DateTime? createdAt,
    bool? userDeviceActive,
    WeeklyLoginStats? weeklyLoginStats,
    List<CheckIn>? checkIns,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      userDeviceActive: userDeviceActive ?? this.userDeviceActive,
      weeklyLoginStats: weeklyLoginStats ?? this.weeklyLoginStats,
      checkIns: checkIns ?? this.checkIns,
    );
  }
} 