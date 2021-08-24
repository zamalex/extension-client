import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon/blocs/appointment/appointment_bloc.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/data/models/appointment_model.dart';
import 'package:salon/data/models/toolbar_option_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/main.dart';
import 'package:salon/model/appointments_data.dart';
import 'package:salon/screens/appointments/widgets/appointments_list_item.dart';
import 'package:salon/screens/appointments/widgets/appointments_toolbar.dart';
import 'package:salon/utils/bottom_bar_items.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/widgets/jumbotron.dart';
import 'package:salon/widgets/loading_overlay.dart';
import 'package:salon/utils/list.dart';
import 'package:salon/widgets/pull_to_refresh.dart';
import 'package:salon/widgets/strut_text.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key key}) : super(key: key);
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final RefreshController _controller = RefreshController(initialRefresh: false);

  ToolbarOptionModel _currentSort;
  ToolbarOptionModel _currentGroup;

  /// Manage state of modal progress HUD widget.
  bool _isLoading = false;
  bool _isInited = false;
  int page=1;
  List<Data> _appointments=[];

  /// Search sort types.
  List<ToolbarOptionModel> searchSortTypes;

  /// Search status types.
  List<ToolbarOptionModel> searchGroupTypes;

  @override
  void initState() {
    super.initState();

    _initGlobals();
    _loadAppointments();
  }

  void _initGlobals() {
    searchSortTypes = <dynamic>[
      <String, dynamic>{
        'code': 'date_desc',
        'label': L10n.current.appointmentsSort('date_desc'),
        'icon': Icons.swap_vert,
      },
      <String, dynamic>{
        'code': 'date_asc',
        'label': L10n.current.appointmentsSort('date_asc'),
        'icon': Icons.swap_vert,
      },
    ].map((dynamic item) => ToolbarOptionModel.fromJson(item as Map<String, dynamic>)).toList();

    searchGroupTypes = <dynamic>[
      <String, dynamic>{
        'code': 'All',
        'label': 'All',
        'icon': Icons.calendar_today,
      },
      <String, dynamic>{
        'code': 'Active',
        'label': 'Active',
        'icon': Icons.calendar_today,
      },
      <String, dynamic>{
        'code': 'Canceled',
        'label': 'Canceled',
        'icon': Icons.calendar_today,
      },
    ].map((dynamic item) => ToolbarOptionModel.fromJson(item as Map<String, dynamic>)).toList();

    _currentSort = searchSortTypes.first;
    _currentGroup = searchGroupTypes.first;
  }

  Future<void> _loadAppointments({int page = 1}) async {
    setState(() => _isLoading = true);

    if(page==1){
      _appointments.clear();
       this.page=1;
    }
    final List<String> _statuses = <String>[];

    String status='all';
    switch (_currentGroup.code) {
      case 'All':
        status = 'all';
        _statuses.add(describeEnum(AppointmentStatus.active));
        break;
      case 'Active':
        status = 'active';

        _statuses.add(describeEnum(AppointmentStatus.completed));
        break;
      default:
        status = 'canceled';

        _statuses.add(describeEnum(AppointmentStatus.canceled));
        //_statuses.add(describeEnum(AppointmentStatus.declined));
        // _statuses.add(describeEnum(AppointmentStatus.failed));
        break;
    }

    BlocProvider.of<AppointmentBloc>(context).add(LoadedAppointmentEvent(
      statuses: _statuses,
      type: 'booking',
      page: page,
      status: status,
      resultsPerPage: kReservationsPerPage,
    ));
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (BuildContext context, AppointmentState state) {
        return BlocListener<AppointmentBloc, AppointmentState>(
          listener: (BuildContext context, AppointmentState state) {
            if (state is LoadSuccessAppointmentState) {
              _controller.refreshCompleted();
              _controller.loadComplete();
              _appointments.addAll(state.appointments);
              setState(() {
                _isLoading = false;
                _isInited = true;
              });
            }
          },
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(L10n.of(context).appointmentsTitle),
            ),
            body: LoadingOverlay(
              isLoading: _isLoading,
              child: Column(
                children: <Widget>[
                  SafeArea(
                    top: false,
                    bottom: false,
                    child: AppointmentsToolbar(
                      currentSort: _currentSort,
                      currentGroup: _currentGroup,
                      searchSortTypes: searchSortTypes,
                      searchGroupTypes: searchGroupTypes,
                      onSortChange: (ToolbarOptionModel newSort) {
                        setState(() => _currentSort = newSort);
                        _loadAppointments();
                      },
                      onGroupChange: (ToolbarOptionModel newgroup) {
                        setState(() => _currentGroup = newgroup);
                        page=1;
                        _loadAppointments(page:1);
                      },
                    ),
                  ),
                  Expanded(child: _buildAppointmentsList()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentsList() {
    if (_appointments.isNotNullOrEmpty) {
      return PullToRefresh(
        enablePullDown: true,
        enablePullUp: true,
        controller: _controller,
        onRefresh:(){
          page=1;
          _loadAppointments(page: 1);
        },
        onLoading: (){
          _loadAppointments(page: ++page);
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: kPaddingS),
          itemCount: _appointments.length,
          itemBuilder: (BuildContext context, int index) {
            return AppointmentsListItem(
              appointment: _appointments[index],
              routeName: Routes.appointment,
              load: (){
                page = 1;
                _loadAppointments(page: 1);
              },
            );
          },
        ),
      );
    }

    if (_isInited) {
      String _title;

      switch (_currentGroup.code) {
        case 'active':
          _title = L10n.of(context).appointmentsWarningUpcomingList;
          break;
        case 'completed':
          _title = L10n.of(context).appointmentsWarningCompletedList;
          break;
        default:
          _title = L10n.of(context).appointmentsWarningOtherList;
      }

      return Padding(
        padding: const EdgeInsets.all(kPaddingM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Jumbotron(
              title: _title,
              icon: Icons.calendar_today,
              padding: const EdgeInsets.all(0),
            ),
            RaisedButton(
              child: StrutText(
                L10n.of(context).appointmentsBtnExplore,
                style: Theme.of(context).textTheme.button.fs16.white.w500,
              ),
              onPressed: () {
                // Tap on BottomNavigationBar's Explore button.
                (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar)
                    .onTap(0);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      );
    }

    return Container();
  }
}
