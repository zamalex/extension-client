import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salon/blocs/booking/booking_bloc.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/data/models/booking_session_model.dart';
import 'package:salon/data/models/timetable_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/model/booking_day_times.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/utils/datetime.dart';
import 'package:salon/widgets/jumbotron.dart';
import 'package:salon/widgets/list_item.dart';
import 'package:salon/widgets/strut_text.dart';
import 'package:salon/widgets/timeline_date.dart';

class BookingStep3 extends StatefulWidget {
  int id;
  BookingStep3(this.id);

  @override
  _BookingStep3State createState() => _BookingStep3State();
}

class _BookingStep3State extends State<BookingStep3> {

  List<Slot> slots = [];

  final ScrollController _controller = ScrollController();
List<int> i=[10,20,30,40];

getSlots(String id,String date){
  BookingDayTimes().getDayTimes(id, date).then((value){
    setState(() {
      slots = value??[];
    });
  });

}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    final now = DateTime.now();
    getSlots(widget.id.toString(), '${now.year}-${now.month}-${now.day}');
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (BuildContext context, BookingState state) {
        final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;

        final DateTime selectedDate = DateTime.now().add(Duration(days: session.selectedDateRange));
        final TimetableModel timetableModel = session.timetables != null
            ? session.timetables.firstWhere((TimetableModel t) {
                return t.date.day == selectedDate.day && t.date.month == selectedDate.month && t.date.year == selectedDate.year;
              }, orElse: () => null)
            : null;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(kPaddingM),
                child: StrutText(
                  L10n.of(context).bookingSubtitleDate,
                  style: Theme.of(context).textTheme.headline5.w600,
                ),
              ),
              Container(
                child: Container(
                  height: kTimelineDateSize,
                  child: ListView.builder(
                    padding: const EdgeInsetsDirectional.only(start: kPaddingM),
                    itemCount: kReservationsDateRange,
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    itemBuilder: (BuildContext context, int index) {
                      return TimelineDate(
                        dateRange: index,
                        isSelected: session.selectedDateRange == index,
                        onTap: () {
                          if (session.selectedDateRange != index) {
                            final now = DateTime.now().add(Duration(days: session.selectedDateRange));
                            getSlots(session.location.id.toString(), '${now.year}-${now.month}-${now.day}');
                            context.read<BookingBloc>().add(DateRangeSetBookingEvent(index));
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kPaddingM),
                child: StrutText(
                  L10n.of(context).bookingSubtitleTime,
                  style: Theme.of(context).textTheme.headline6.w600,
                ),
              ),
              if (timetableModel != null && timetableModel.timestamps.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List<ListItem>.generate(slots.length/*timetableModel.timestamps.length*/, (int index) {
                      final now = DateTime.now().add(Duration(days: session.selectedDateRange));
                      final splitTime= slots[index].time.split(':');
                      return _timetableItem(DateTime(now.year, now.month, now.day, int.tryParse(splitTime[0]), int.tryParse(splitTime[1])).millisecondsSinceEpoch, session.selectedTimestamp);
                    }),
                  ),
                )
              else
                Center(
                  child: Jumbotron(
                    title: session.selectedStaff == null || session.selectedStaff.id == 0
                        ? L10n.of(context).bookingWarningNoSlots
                        : L10n.of(context).bookingWarningStaffUnavailable(session.selectedStaff.name),
                    icon: Icons.access_time,
                    padding: const EdgeInsets.only(top: kPaddingM),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  ListItem _timetableItem(int timestamp, int selectedTimestamp) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return ListItem(
      leading: Padding(
        padding: const EdgeInsets.only(top: kPaddingS / 2),
        child: Radio<int>(
          value: timestamp,
          groupValue: selectedTimestamp,
          onChanged: (int selected) => selectTimestampEvent(timestamp),
        ),
      ),
      title: date.toLocalTimeString,
      onPressed: () => selectTimestampEvent(timestamp),
    );
  }

  void selectTimestampEvent(int timestamp) {
    context.read<BookingBloc>().add(TimestampSelectedBookingEvent(timestamp));
  }
}
