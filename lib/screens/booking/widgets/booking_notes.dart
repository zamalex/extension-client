import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extension/blocs/booking/booking_bloc.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/utils/form_utils.dart';
import 'package:extension/widgets/form_label.dart';
import 'package:extension/widgets/theme_button.dart';
import 'package:extension/widgets/theme_text_input.dart';

class BookingNotes extends StatefulWidget {
  const BookingNotes({
    Key key,
    this.notes,
    this.setNotes,
    @required this.appointment
  }) : super(key: key);

  final String notes;
  final int appointment;
 final Function setNotes;

  @override
  _BookingNotesState createState() => _BookingNotesState();
}

class _BookingNotesState extends State<BookingNotes> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

  void updateNotes() {
    FormUtils.hideKeyboard(context);

    if(widget.appointment!=0)
    BlocProvider.of<BookingBloc>(context).add(NotesUpdatedBookingEvent(textEditingController.text,widget.appointment));
    else{
      BlocProvider.of<BookingBloc>(context).notes=textEditingController.text;
    }
    widget.setNotes(textEditingController.text);
    Navigator.pop(context, textEditingController.text);
  }

  @override
  void initState() {
    super.initState();

    textEditingController.text = widget.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(L10n.of(context).bookingAddNotes),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: kPaddingM, right: kPaddingM, top: kPaddingM),
                children: <Widget>[
                  FormLabel(text: L10n.of(context).bookingNoteslabel),
                  ThemeTextInput(
                    focusNode: focusNode,
                    textInputAction: TextInputAction.next,
                    maxLines: 5,
                    onSubmitted: (String text) => updateNotes(),
                    controller: textEditingController,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingM, vertical: kPaddingS),
              child: ThemeButton(
                onPressed: updateNotes,
                text: L10n.of(context).commonBtnApply,
                disableTouchWhenLoading: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
