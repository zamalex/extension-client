import 'package:extension/blocs/booking/booking_bloc.dart';
import 'package:extension/data/models/location_model.dart';
import 'package:extension/data/models/service_model.dart';
import 'package:extension/data/models/staff_model.dart';
import 'package:extension/data/models/timetable_model.dart';

class BookingSessionModel {
  BookingSessionModel({
    this.booking_id=0,
    this.location,
    this.services,
    this.isPackage=false,
    this.package,
    this.selectedServiceIds,
    this.selectedStaff,
    this.timetables,
    this.totalPrice = 0.0,
    this.totalDuration = 0,
    this.selectedDateRange = -1,
    this.selectedTimestamp = 0,
    this.isSubmitting = false,
    this.notes = '',
    this.apiError = '',
    this.appointmentId = 0,
    this.paymentMethod = PaymentMethod.inStore,
  });

  BookingSessionModel rebuild({
    int booking_id,
    bool isPackage=false,
    LocationModel location,
    List<ServiceModel> services,
    List<TimetableModel> timetables,
    List<int> selectedServiceIds,
    StaffModel selectedStaff,
    double totalPrice,
    int totalDuration,
    ServiceModel package,
    int selectedDateRange,
    int selectedTimestamp,
    bool isSubmitting,
    String licensePlate,
    String contactPhone,
    String notes,
    String apiError,
    int appointmentId,
    PaymentMethod paymentMethod,
  }) {
    return BookingSessionModel(
      isPackage:false,
      package: package,
      booking_id: booking_id??0,
      location: location ?? this.location,
      services: services ?? this.services,
      selectedServiceIds: selectedServiceIds ?? this.selectedServiceIds,
      selectedStaff: selectedStaff ?? this.selectedStaff,
      timetables: timetables ?? this.timetables,
      totalPrice: totalPrice ?? this.totalPrice,
      totalDuration: totalDuration ?? this.totalDuration,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      selectedTimestamp: selectedTimestamp ?? this.selectedTimestamp,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      notes: notes ?? this.notes,
      apiError: apiError ?? '',

      appointmentId: appointmentId ?? this.appointmentId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  final LocationModel location;
   List<ServiceModel> services;
  final List<TimetableModel> timetables;

  bool isPackage = false;

  final List<int> selectedServiceIds;
   StaffModel selectedStaff;
   int selectedDateRange;
  final int selectedTimestamp;
   bool isSubmitting;
  List<int> times = [];
  final String notes;

   double totalPrice;
  final int totalDuration;

   String apiError;
   int appointmentId;

   ServiceModel package;

  final PaymentMethod paymentMethod;
  int booking_id;

  @override
  String toString() {
    return '''BookingSessionModel:
    location: ${location.id}
    selectedServices: $selectedServiceIds
    selectedStaff: $selectedStaff
    totalPrice: $totalPrice
    totalDuration: $totalDuration
    isPackage: $isPackage
    selectedTimestamp: $selectedTimestamp
    appointmentId: $appointmentId
    paymentMethod: $paymentMethod''';
  }
}
