import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extension/blocs/booking/booking_bloc.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/data/models/booking_session_model.dart';
import 'package:extension/data/models/service_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/screens/booking/widgets/service_header_delegate.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/jumbotron.dart';
import 'package:extension/widgets/list_item.dart';
import 'package:extension/widgets/strut_text.dart';
import 'package:sprintf/sprintf.dart';

class BookingStep1 extends StatefulWidget {
  const BookingStep1({
    Key key,
    this.preselectedService,
  }) : super(key: key);

  final ServiceModel preselectedService;


  @override
  _BookingStep1State createState() => _BookingStep1State();
}

class _BookingStep1State extends State<BookingStep1> {
  @override
  void initState() {
    super.initState();
    if (widget.preselectedService != null) {
      context.read<BookingBloc>().add(ServiceSelectedBookingEvent(service: widget.preselectedService));
    }
  }

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: ServiceHeaderDelegate(
        minHeight: kPaddingM * 3,
        maxHeight: kPaddingM * 4,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsetsDirectional.only(start: kPaddingM),
                child: StrutText(
                  headerText,
                  style: Theme.of(context).textTheme.headline5.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (BuildContext context, BookingState state) {
        final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;

        if (session.location.serviceGroups.isEmpty) {
          return Container(
            alignment: AlignmentDirectional.center,
            child: Jumbotron(
              title: L10n.of(context).bookingWarningNoServices,
              icon: Icons.report,
            ),
          );
        }

        final List<Widget> _slivers = <Widget>[];

        for (int i = 0; i < session.location.serviceGroups.length; i++) {
          _slivers.add(makeHeader(session.location.serviceGroups[i].name));
          _slivers.add(SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List<Widget>.generate(session.location.serviceGroups[i].services.length, (int index) {
                      return _serviceItem(session.location.serviceGroups[i].services[index], session);
                    }),
                  ),
                ),
              ],
            ),
          ));
        }

        return CustomScrollView(slivers: _slivers);
      },
    );
  }

  Widget _serviceItem(ServiceModel serviceModel, BookingSessionModel session) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          width: 50,
            height: 50,
            image: serviceModel.image=='assets/images/onboarding/welcome.jpg'?AssetImage(
              'assets/images/onboarding/welcome.jpg',) as ImageProvider:NetworkImage(
                serviceModel.image),
            fit: BoxFit.cover),
      ),

      title: Text(

        serviceModel.name,
        style: TextStyle(fontSize: 20, color: Colors.black,),
        //overflow: TextOverflow.ellipsis,
        //maxLines: 1,
      ),


      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              children:[
                StrutText(

                  L10n.of(context).commonCurrencyFormat(sprintf('%.2f', <double>[serviceModel.price])),
                  style: Theme.of(context).textTheme.subtitle1.fs18.w500.black.copyWith(fontSize: 12),
                ),
                Text(!serviceModel.has_discount?'':serviceModel.base_price.toStringAsFixed(2),style:TextStyle(decoration: TextDecoration.lineThrough,fontSize: 12,color: Colors.red),),
              ]
          ),

          Text(L10n.of(context).commonDurationFormat(serviceModel.duration.toString()), style: TextStyle(color:kPrimaryColor,fontSize: 12),)


        ],
      ),
      trailing: Checkbox(
        value: session.selectedServiceIds.contains(serviceModel.id),
        onChanged: (bool isChecked) {
          setState(() {
            if (isChecked) {
              context.read<BookingBloc>().add(ServiceSelectedBookingEvent(service: serviceModel));
            } else {
              context.read<BookingBloc>().add(ServiceUnselectedBookingEvent(service: serviceModel));
            }
          });
        },
      ),
      onTap: (){
        setState(() {
          if (session.selectedServiceIds.contains(serviceModel.id)) {
            context.read<BookingBloc>().add(ServiceUnselectedBookingEvent(service: serviceModel));
          } else {
            context.read<BookingBloc>().add(ServiceSelectedBookingEvent(service: serviceModel));
          }
        });
      },
    );
    /*return ListItem(
      leading: Checkbox(
        value: session.selectedServiceIds.contains(serviceModel.id),
        onChanged: (bool isChecked) {
          setState(() {
            if (isChecked) {
              context.read<BookingBloc>().add(ServiceSelectedBookingEvent(service: serviceModel));
            } else {
              context.read<BookingBloc>().add(ServiceUnselectedBookingEvent(service: serviceModel));
            }
          });
        },
      ),
      title: serviceModel.name,
      titleTextStyle: Theme.of(context).textTheme.subtitle1.fs18.w500,
      subtitle: serviceModel.description,
      subtitleTextStyle: Theme.of(context).textTheme.bodyText1.w300.copyWith(color: Theme.of(context).hintColor),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          StrutText(
            L10n.of(context).commonCurrencyFormat(sprintf('%.2f', <double>[serviceModel.price])),
            style: Theme.of(context).textTheme.subtitle1.fs18.w500,
          ),
          Text(!serviceModel.has_discount?'':serviceModel.base_price.toStringAsFixed(2),style:TextStyle(decoration: TextDecoration.lineThrough,fontSize: 12,color: Colors.red),),
          StrutText(
            L10n.of(context).commonDurationFormat(serviceModel.duration.toString()),
            style: Theme.of(context).textTheme.bodyText1.w300.copyWith(color: Theme.of(context).hintColor),
          ),
        ],
      ),
      onPressed: () {
        setState(() {
          if (session.selectedServiceIds.contains(serviceModel.id)) {
            context.read<BookingBloc>().add(ServiceUnselectedBookingEvent(service: serviceModel));
          } else {
            context.read<BookingBloc>().add(ServiceSelectedBookingEvent(service: serviceModel));
          }
        });
      },
    );*/

  }
}
