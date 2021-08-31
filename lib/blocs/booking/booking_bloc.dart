import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/blocs/auth/auth_bloc.dart';
import 'package:salon/blocs/base_bloc.dart';
import 'package:salon/data/models/booking_session_model.dart';
import 'package:salon/data/models/location_model.dart';
import 'package:salon/data/models/service_model.dart';
import 'package:salon/data/models/staff_model.dart';
import 'package:salon/data/models/timetable_model.dart';
import 'package:salon/data/repositories/appointment_repository.dart';
import 'package:salon/data/repositories/location_repository.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/model/confirm_order.dart';

part 'booking_event.dart';
part 'booking_state.dart';

enum PaymentMethod { cc, inStore }

class BookingBloc extends BaseBloc<BookingEvent, BookingState> {
  BookingBloc({@required this.authBloc}) : super(InitialBookingState());

  final AuthBloc authBloc;

  @override
  Stream<BookingState> mapEventToState(BookingEvent event) async* {
    if (event is LocationLoadedBookingEvent) {
      yield* _mapLoadLocationBookingEventToState(event);
    } else if (event is ServiceSelectedBookingEvent) {
      yield* _mapSelectServiceBookingEventToState(event);
    } else if (event is ServiceUnselectedBookingEvent) {
      yield* _mapUnselectServiceBookingEventToState(event);
    } else if (event is StaffSelectedBookingEvent) {
      yield* _mapSelectStaffBookingEventToState(event);
    } else if (event is TimetablesRequestedBookingEvent) {
      yield* _mapGetTimetablesBookingEventToState(event);
    } else if (event is DateRangeSetBookingEvent) {
      yield* _mapSetDateRangeBookingEventToState(event);
    } else if (event is TimestampSelectedBookingEvent) {
      yield* _mapSelectTimestampBookingEventToState(event);
    } else if (event is PaymentMethodSelectedBookingEvent) {
      yield* _mapSelectPaymentMethodBookingEventToState(event);
    } else if (event is NotesUpdatedBookingEvent) {
      yield* _mapUpdateNotesdBookingEventToState(event);
    } else if (event is SubmittedBookingEvent) {
      yield* _mapSubmitBookingEventToState(event.context);
    }
  }

  Stream<BookingState> _mapLoadLocationBookingEventToState(LocationLoadedBookingEvent event) async* {
    final LocationModel _location = await const LocationRepository().getLocation(id: event.locationId);

    if (_location == null) {
      yield LoadFailureBookingState();
    } else {
      yield SessionRefreshSuccessBookingState(BookingSessionModel(
        location: _location,
        selectedServiceIds: <int>[],
        selectedStaff: null,
        appointmentId: 0,
      ));
    }
  }

  Stream<BookingState> _mapSelectServiceBookingEventToState(ServiceSelectedBookingEvent event) async* {
    if (state is SessionRefreshSuccessBookingState) {
      final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;

      session.selectedServiceIds.add(event.service.id);

      final int totalDuration = session.totalDuration + event.service.duration;
      final BookingSessionModel newSession = session.rebuild(
        selectedServiceIds: session.selectedServiceIds,
        totalPrice: session.totalPrice + event.service.price,
        totalDuration: totalDuration,
      );

      yield SessionRefreshSuccessBookingState(newSession);

      add(TimetablesRequestedBookingEvent(
        locationId: session.location.id,
        duration: totalDuration,
      ));
    }
  }

  Stream<BookingState> _mapUnselectServiceBookingEventToState(ServiceUnselectedBookingEvent event) async* {
    if (state is SessionRefreshSuccessBookingState) {
      final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;
      session.selectedServiceIds.remove(event.service.id);

      final int totalDuration = session.totalDuration - event.service.duration;
      final BookingSessionModel newSession = session.rebuild(
        selectedServiceIds: session.selectedServiceIds,
        totalPrice: session.totalPrice - event.service.price,
        totalDuration: totalDuration,
      );

      yield SessionRefreshSuccessBookingState(newSession);

      add(TimetablesRequestedBookingEvent(
        locationId: session.location.id,
        duration: totalDuration,
      ));
    }
  }

  Stream<BookingState> _mapSelectStaffBookingEventToState(StaffSelectedBookingEvent event) async* {
    if (state is SessionRefreshSuccessBookingState) {
      final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;

      final BookingSessionModel newSession = session.rebuild(selectedStaff: event.staff);

      yield StaffSelectionSuccessBookingState();
      yield SessionRefreshSuccessBookingState(newSession);
    }
  }

  Stream<BookingState> _mapGetTimetablesBookingEventToState(TimetablesRequestedBookingEvent event) async* {
    if (state is SessionRefreshSuccessBookingState) {
      final List<TimetableModel> _timetables = await const AppointmentRepository().getTimetable(
        locationId: event.locationId,
        duration: event.duration,
      );
      final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;
      final BookingSessionModel newSession = session.rebuild(timetables: _timetables);

      yield SessionRefreshSuccessBookingState(newSession);
    }
  }

  Stream<BookingState> _mapSetDateRangeBookingEventToState(DateRangeSetBookingEvent event) async* {
    if (state is SessionRefreshSuccessBookingState) {
      final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;
      if (session.selectedDateRange != event.dateRange) {
        final BookingSessionModel newSession = session.rebuild(
          selectedDateRange: event.dateRange,
          selectedTimestamp: 0,
        );

        yield SessionRefreshSuccessBookingState(newSession);
      }
    }
  }

  Stream<BookingState> _mapSelectTimestampBookingEventToState(TimestampSelectedBookingEvent event) async* {
    if (state is SessionRefreshSuccessBookingState) {
      final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;
      if (session.selectedTimestamp != event.timestamp) {
        final BookingSessionModel newSession = session.rebuild(selectedTimestamp: event.timestamp);

        yield SessionRefreshSuccessBookingState(newSession);
      }
    }
  }

  Stream<BookingState> _mapSelectPaymentMethodBookingEventToState(PaymentMethodSelectedBookingEvent event) async* {
    if (state is SessionRefreshSuccessBookingState) {
      final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;
      if (session.paymentMethod != event.paymentMethod) {
        final BookingSessionModel newSession = session.rebuild(paymentMethod: event.paymentMethod);

        yield SessionRefreshSuccessBookingState(newSession);
      }
    }
  }

  Stream<BookingState> _mapUpdateNotesdBookingEventToState(NotesUpdatedBookingEvent event) async* {
    if (state is SessionRefreshSuccessBookingState) {
      final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;
      final BookingSessionModel newSession = session.rebuild(notes: event.notes);

      yield SessionRefreshSuccessBookingState(newSession);
    }
  }

  Stream<BookingState> _mapSubmitBookingEventToState(BuildContext context) async* {
    if (state is SessionRefreshSuccessBookingState) {
      final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;

      yield SessionRefreshSuccessBookingState(session.rebuild(isSubmitting: true));

      session.selectedServiceIds.forEach((element) {print('id id ${element.toString()}');});
      print('staff id ${session.selectedStaff.id} and name ${session.selectedStaff.name}');
      final DateTime now = DateTime.fromMillisecondsSinceEpoch(session.selectedTimestamp);
      print('date  ${now.year}-${now.month}-${now.day}');
      print('time is ${now.hour}:${now.minute}');
      bool points =Provider.of<CartProvider>(context,listen: false).payWithBalance ;//session.paymentMethod.index==0?true:false;

        var map = {
        'booked_shift_id':1.toString(),
        'shop_id':session.location.serviceGroups.first.services.first.shop_id.toString(),
        'seller_id':session.location.serviceGroups.first.services.first.seller_id.toString(),
        'services_ids':session.selectedServiceIds,
        if(session.selectedStaff.id!=0)'staff_id':session.selectedStaff.id.toString(),
        'date':'${now.year}-${now.month}-${now.day}',
        'time':'${now.hour}:${now.minute}',
        'payment_type':'cash_on_delivery',
        'pay_with_points':points

      };

        print(map.toString());
      // Wait for some random time. Simulate net activity ;)
      var result ={};
      await ConfirmOrder().confirmBooking(map,context).then((value){
         result  = value;
      });


      if(result['result']as bool){
        yield SessionRefreshSuccessBookingState(session.rebuild(
          isSubmitting: false,
          appointmentId: 1,

        ),);
      }else{
        yield SessionRefreshSuccessBookingState(session.rebuild(
          isSubmitting: false,
          apiError:result['message'].toString(),
          appointmentId: -1,
        ),message:result['message'].toString());
      }

    }
  }
}
