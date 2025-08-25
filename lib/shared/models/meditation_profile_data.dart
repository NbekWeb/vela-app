class MeditationProfileData {
  int? id;
  String? ageRange;
  String? gender;
  List<String>? dream;
  List<String>? goals;
  List<String>? happiness;
  String? name;
  String? description;
  List<String>? ritualType;
  List<String>? tone;
  List<String>? voice;
  List<String>? duration;
  String? file;
  int? planType;
  Map<String, dynamic>? ritual; // Add ritual field
  Map<String, dynamic>? details; // Add details field

  MeditationProfileData({
    this.id,
    this.ageRange,
    this.gender,
    this.dream,
    this.goals,
    this.happiness,
    this.name,
    this.description,
    this.ritualType,
    this.tone,
    this.voice,
    this.duration,
    this.file,
    this.planType,
    this.ritual, // Add ritual field
    this.details, // Add details field
  });

  MeditationProfileData copyWith({
    int? id,
    String? ageRange,
    String? gender,
    List<String>? dream,
    List<String>? goals,
    List<String>? happiness,
    String? name,
    String? description,
    List<String>? ritualType,
    List<String>? tone,
    List<String>? voice,
    List<String>? duration,
    String? file,
    int? planType,
    Map<String, dynamic>? ritual, // Add ritual field
    Map<String, dynamic>? details, // Add details field
  }) {
    return MeditationProfileData(
      id: id ?? this.id,
      ageRange: ageRange ?? this.ageRange,
      gender: gender ?? this.gender,
      dream: dream ?? this.dream,
      goals: goals ?? this.goals,
      happiness: happiness ?? this.happiness,
      name: name ?? this.name,
      description: description ?? this.description,
      ritualType: ritualType ?? this.ritualType,
      tone: tone ?? this.tone,
      voice: voice ?? this.voice,
      duration: duration ?? this.duration,
      file: file ?? this.file,
      planType: planType ?? this.planType,
      ritual: ritual ?? this.ritual, // Add ritual field
      details: details ?? this.details, // Add details field
    );
  }

  factory MeditationProfileData.fromJson(Map<String, dynamic> json) {
    return MeditationProfileData(
      id: json['id'],
      ageRange: json['age_range'],
      gender: json['gender'],
      dream: json['dream'] != null ? List<String>.from(json['dream']) : null,
      goals: json['goals'] != null ? List<String>.from(json['goals']) : null,
      happiness: json['happiness'] != null ? List<String>.from(json['happiness']) : null,
      name: json['name'],
      description: json['description'],
      ritualType: json['ritual_type'] != null 
          ? (json['ritual_type'] is List 
              ? List<String>.from(json['ritual_type']) 
              : [json['ritual_type'].toString()])
          : null,
      tone: json['tone'] != null 
          ? (json['tone'] is List 
              ? List<String>.from(json['tone']) 
              : [json['tone'].toString()])
          : null,
      voice: json['voice'] != null 
          ? (json['voice'] is List 
              ? List<String>.from(json['voice']) 
              : [json['voice'].toString()])
          : null,
      duration: json['duration'] != null 
          ? (json['duration'] is List 
              ? List<String>.from(json['duration']) 
              : [json['duration'].toString()])
          : null,
      file: json['file'],
      planType: json['plan_type'],
      ritual: json['ritual'], // Add ritual field
      details: json['details'], // Add details field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'age_range': ageRange,
      'gender': gender,
      'dream': dream,
      'goals': goals,
      'happiness': happiness,
      'name': name,
      'description': description,
      'ritual_type': ritualType,
      'tone': tone,
      'voice': voice,
      'duration': duration,
      'file': file,
      'plan_type': planType,
      'ritual': ritual, // Add ritual field
      'details': details, // Add details field
    };
  }
} 