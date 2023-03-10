import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:extension/blocs/booking/booking_bloc.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/data/models/booking_session_model.dart';
import 'package:extension/data/models/timetable_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/model/booking_day_times.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/utils/datetime.dart';
import 'package:extension/widgets/jumbotron.dart';
import 'package:extension/widgets/list_item.dart';
import 'package:extension/widgets/strut_text.dart';
import 'package:extension/widgets/timeline_date.dart';

class BookingStep3 extends StatefulWidget {
  int id;
  BookingStep3(this.id);

  @override
  _BookingStep3State createState() => _BookingStep3State();
}

class _BookingStep3State extends State<BookingStep3> {

  List<Slot> slots;

  final ScrollController _controller = ScrollController();
List<int> i=[10,20,30,40];

getSlots(int day,String id,int salon,String date){
  BookingDayTimes().getDayTimes(day,id, salon,date).then((value){
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
    //getSlots(widget.id.toString(), '${now.year}-${now.month}-${now.day}');
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(

      builder: (BuildContext context, BookingState state) {
        final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session..selectedDateRange;
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
                            final now = DateTime.now().add(Duration(days: index));
                            print(now.toLocalDateString);
                            getSlots(now.weekday,session.selectedStaff.id.toString(), widget.id,'${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}');
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
              if (slots!=null&&/*timetableModel != null && timetableModel.timestamps.isNotEmpty*/slots.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List<ListItem>.generate(slots.length/*timetableModel.timestamps.length*/, (int index) {
                      final now = DateTime.now().add(Duration(days: session.selectedDateRange));
                      var splitTime= slots[index].time.split(':');
                      final am = splitTime[1].contains('AM');
                      splitTime = slots[index].time.replaceAll(' AM', '').replaceAll(' PM', '').split(':');
                      if(am&&splitTime[0]=='12'){
                          splitTime[0]='00';
                      }
                      return _timetableItem(DateTime(now.year, now.month, now.day, int.tryParse(splitTime[0])+(am?0:12), int.tryParse(splitTime[1])).millisecondsSinceEpoch, session.selectedTimestamp);
                    }),
                  ),
                )
              else if(slots!=null&&slots.isEmpty)
                Center(
                  child: Jumbotron(
                    title: session.selectedStaff == null || session.selectedStaff.id == 0
                        ? L10n.of(context).bookingWarningNoSlots
                        : L10n.of(context).bookingWarningStaffUnavailable(session.selectedStaff.name),
                    icon: Icons.access_time,
                    padding: const EdgeInsets.only(top: kPaddingM),
                  ),
                )
              else Container()
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
      title: DateFormat('hh:mm a',Intl.systemLocale).format(date),//date.toLocalTimeString,
      onPressed: () => selectTimestampEvent(timestamp),
    );
  }

  void selectTimestampEvent(int timestamp) {
    context.read<BookingBloc>().add(TimestampSelectedBookingEvent(timestamp));
  }
}
