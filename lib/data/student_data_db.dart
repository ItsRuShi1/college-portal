import '../models/student_data.dart';
import '../models/timetable_entry.dart';

// --- 1. Diversified Mock Profiles ---

const _profileHighAchiever = StudentData(
  hasFeeAlert: false,
  attendancePercentage: 0.94,
  currentGpa: 9.1,
  creditsCompleted: 92,
  totalCredits: 120,
  nextClass: TimetableEntry(
    course: 'Advanced Signal Processing',
    professor: 'Dr. Helena Vance',
    location: 'Building B, Lab 10',
    startTime: '09:00 AM',
    endTime: '10:30 AM',
  ),
);

const _profileAverage = StudentData(
  hasFeeAlert: true,
  attendancePercentage: 0.82,
  currentGpa: 7.5,
  creditsCompleted: 88,
  totalCredits: 120,
  nextClass: TimetableEntry(
    course: 'Microcontrollers',
    professor: 'Prof. Marcus Thorne',
    location: 'Hall A, Room 302',
    startTime: '11:00 AM',
    endTime: '12:30 PM',
  ),
);

const _profileAtRisk = StudentData(
  hasFeeAlert: true,
  attendancePercentage: 0.68,
  currentGpa: 6.2,
  creditsCompleted: 75,
  totalCredits: 120,
  nextClass: TimetableEntry(
    course: 'Electromagnetic Fields',
    professor: 'Dr. Sarah Jenkins',
    location: 'Lecture Hall 1',
    startTime: '02:00 PM',
    endTime: '03:30 PM',
  ),
);

// --- 2. Updated Student Database Map ---

final Map<String, StudentData> studentDatabase = {
  'EC2221': _profileHighAchiever, // Jordan A. Smith
  'EC2222': _profileAverage,      // Maya R. Patel
  'EC2223': _profileAtRisk,       // Liam O. Bennett
  'EC2224': _profileHighAchiever, // Sophia L. Chen
  'EC2225': _profileAverage,      // Ethan M. Rodriguez
  'EC2226': _profileHighAchiever, // Chloe J. Williams
  'EC2227': _profileAtRisk,       // Noah K. Tanaka
  'EC2228': _profileAverage,      // Ava S. Gupta
  'EC2229': _profileHighAchiever, // Lucas T. Müller
  'EC2230': _profileAtRisk,       // Isabella F. Rossi
  'EC2231': _profileAverage,      // Mason D. Wright
  'EC2232': _profileHighAchiever, // Mia E. Kowalski
  'EC2233': _profileAverage,      // Aiden B. Silva
  'EC2234': _profileAtRisk,       // Emma V. Dubois
  'EC2235': _profileHighAchiever, // James H. Kim
  'EC2236': _profileAverage,      // Olivia G. Martinez
  'EC2237': _profileAtRisk,       // Benjamin C. Lee
  'EC2238': _profileHighAchiever, // Amara N. Okafor
  'EC2239': _profileAverage,      // Samuel J. Thompson
  'EC2240': _profileAtRisk,       // Zoe R. Jensen
};