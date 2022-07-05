import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salon/blocs/booking/booking_bloc.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/data/models/booking_session_model.dart';
import 'package:salon/data/models/staff_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/widgets/arrow_right_icon.dart';
import 'package:salon/widgets/initials_circle_avatar.dart';
import 'package:salon/widgets/list_item.dart';
import 'package:salon/utils/string.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/widgets/strut_text.dart';

class BookingStep2 extends StatefulWidget {

  List<StaffModel> staff=[];

  BookingStep2(this.staff);

  @override
  _BookingStep2State createState() => _BookingStep2State();
}

class _BookingStep2State extends State<BookingStep2> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (BuildContext context, BookingState state) {
        final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;

        final List<ListItem> _listItems = <ListItem>[];
        session.location.staff = widget.staff;
        _listItems.add(_staffItem(
            StaffModel.fromJson(<String, dynamic>{
              'id': 0,
              'name': L10n.of(context).bookingStaffNoPreferenceName,
              'description': L10n.of(context).bookingStaffNoPreferenceDescription,
              'profile_photo': 'np.png',
            }),
            session));
        for (int i = 0; i < widget.staff.length; i++) {
          _listItems.add(_staffItem(widget.staff[i], session));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _listItems,
            ),
          ),
        );
      },
    );
  }

  ListItem _staffItem(StaffModel staffModel, BookingSessionModel session) {
    return ListItem(
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: kPaddingS),
        child: staffModel.profilePhoto.isEmpty
            ? InitialsCircleAvatar(initials: staffModel.name.initials)
            : CircleAvatar(
                radius: kCircleAvatarSizeRadiusSmall,
                backgroundImage: staffModel.profilePhoto.contains('assets')?AssetImage(staffModel.profilePhoto) as ImageProvider:NetworkImage(staffModel.profilePhoto),
              ),
      ),
      title: staffModel.name,
      titleTextStyle: Theme.of(context).textTheme.subtitle1.fs18.w500,
      trailing: Row(
        children: <Widget>[
          if (staffModel.rate > 0)
            StrutText(
              staffModel.rate.toString(),
              style: Theme.of(context).textTheme.subtitle1.fs18.bold,
            ),
          if (staffModel.rate == -1)
            const Icon(
              Icons.star,
              size: 20,
              color: kPrimaryColor,
            ),
          const ArrowRightIcon(),
        ],
      ),
      subtitle: staffModel.description,
      subtitleTextStyle: Theme.of(context).textTheme.bodyText1.w300.copyWith(color: Theme.of(context).hintColor),
      onPressed: () {
        setState(() => context.read<BookingBloc>().add(StaffSelectedBookingEvent(staff: staffModel)));
      },
    );
  }
}
