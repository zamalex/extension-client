import 'package:flutter/material.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/data/models/business_hours_model.dart';
import 'package:extension/data/models/location_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/utils/async.dart';
import 'package:extension/utils/datetime.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/utils/ui.dart';
import 'package:extension/utils/string.dart';
import 'package:extension/screens/location/widgets/location_contact_info.dart';
import 'package:extension/widgets/strut_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sprintf/sprintf.dart';
import 'package:intl/intl.dart';

class LocationInfo extends StatefulWidget {
  const LocationInfo({Key key, this.location}) : super(key: key);

  final LocationModel location;

  @override
  _LocationInfoState createState() => _LocationInfoState();
}

class _LocationInfoState extends State<LocationInfo> with TickerProviderStateMixin<LocationInfo> {
  AnimationController _controller;
  bool _isBusinessHoursExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    if (widget.location == null) {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).dividerColor,
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 26,
                width: 100,
                color: kWhite,
              ),
              Container(
                height: 22,
                color: kWhite,
                margin: const EdgeInsets.only(top: kPaddingS),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(4, (int index) {
                  return Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: kPaddingM),
                        height: 32,
                        width: 32,
                        color: kWhite,
                      ),
                      const Padding(padding: EdgeInsets.only(left: kPaddingM)),
                      Container(
                        margin: const EdgeInsets.only(top: kPaddingM),
                        height: 32,
                        width: 200,
                        color: kWhite,
                      )
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      );
    }

    /// Today.
    final DateTime now = DateTime.now();

    /// Business hours for today.
    final BusinessHoursModel businessHoursForToday = widget.location.getBusinessHoursFor(weekday: now.weekday);

    /// Is location closed for today?
    bool isClosed = true;

    if (businessHoursForToday != null) {
      /// Start time for today.
      final DateTime startTime = DateTime.tryParse(DateFormat('yyyy-MM-dd', 'en').format(now) + ' ' + businessHoursForToday.startTime);

      /// End time for today.
      final DateTime endTime = DateTime.tryParse(DateFormat('yyyy-MM-dd', 'en').format(now) + ' ' + businessHoursForToday.endTime);

     /* if (startTime.millisecondsSinceEpoch <= now.millisecondsSinceEpoch && endTime.millisecondsSinceEpoch > now.millisecondsSinceEpoch) {

        setState(() {
          isClosed = false;
        });
      }*/
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          LocationContactInfo(
            icon: Icons.access_time,
            label: L10n.of(context).locationLabelWorkingHours,
            text: /*isClosed
                ? L10n.of(context).locationCurrentlyClosed
                :*/ businessHoursForToday==null?L10n.of(context).locationCurrentlyClosed:sprintf('%s - %s', <String>[businessHoursForToday.startTime, businessHoursForToday.endTime]),
            onTap: () {
              setState(() => _isBusinessHoursExpanded = !_isBusinessHoursExpanded);
            },
            trailing: Container(
              padding: const EdgeInsetsDirectional.only(start: kPaddingS),
              child: Icon(
                _isBusinessHoursExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: kBlack,
              ),
            ),
          ),
          AnimatedSize(
            vsync: this,
            duration: const Duration(milliseconds: 250),
            child: ConstrainedBox(
              constraints: _isBusinessHoursExpanded ? const BoxConstraints() : const BoxConstraints(maxHeight: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(7, (int index) {

                  final BusinessHoursModel businessHour = widget.location.getBusinessHoursFor(weekday: index + 1);
                  final String hours =
                    //  businessHour != null ? sprintf('%s - %s', <String>[DateFormat('hh:mm a',Intl.systemLocale).format(DateTime(now.year, now.month, now.day, int.tryParse(businessHour.startTime.split(':')[0]), int.tryParse(businessHour.startTime.split(':')[1]))), DateFormat('hh:mm a',Intl.systemLocale).format(DateTime(now.year, now.month, now.day, int.tryParse(businessHour.endTime.split(':')[0]), int.tryParse(businessHour.endTime.split(':')[1])))]) : L10n.of(context).locationClosed;
                      businessHour != null ? sprintf('%s - %s', <String>[businessHour.startTime,businessHour.endTime]) : L10n.of(context).locationClosed;
                  return Container(
                    decoration: index == 6
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 1,
                              ),
                            ),
                          )
                        : const BoxDecoration(),
                    padding: index == 0
                        ? const EdgeInsetsDirectional.only(top: kPaddingM, start: kPaddingS, end: kPaddingS, bottom: kPaddingS)
                        : const EdgeInsets.all(kPaddingS),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        StrutText(
                          L10n.of(context).commonWeekdayLong(DOW.values[index]),
                          style: now.weekday == (index + 1) ? Theme.of(context).textTheme.bodyText2.w500.black : Theme.of(context).textTheme.bodyText2.w300.black,
                        ),
                        StrutText(
                          hours,
                          style: now.weekday == (index + 1) ? Theme.of(context).textTheme.bodyText2.w500.black : Theme.of(context).textTheme.bodyText2.w300.black,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          LocationContactInfo(
            icon: Icons.phone,
            label: L10n.of(context).locationLabelPhone,
            text: widget.location.phone,
            onTap: () {
              UI.confirmationDialogBox(
                context,
                message: L10n.of(context).locationCallConfirmation(widget.location.phone),
                onConfirmation: (){
                  if(widget.location.phone.isNotNullOrEmpty||widget.location.phone!='')
                  Async.launchUrl('tel://${widget.location.phone}');},
              );
            },
          ),

        ],
      ),
    );
  }
}
