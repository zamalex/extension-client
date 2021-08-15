import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/utils/form_utils.dart';
import 'package:salon/widgets/form_label.dart';
import 'package:salon/widgets/theme_button.dart';
import 'package:salon/widgets/theme_text_input.dart';
import 'package:salon/generated/l10n.dart';

class ChangeAddress extends StatefulWidget {
  const ChangeAddress({
    Key key,
    this.notes,
  }) : super(key: key);

  final String notes;

  @override
  _ChangeAddressState createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

  void updateNotes() {
    FormUtils.hideKeyboard(context);
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
        title:  Text(L10n.of(context).changeaddress),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: kPaddingM, right: kPaddingM, top: kPaddingM),
                children: <Widget>[
                   FormLabel(text: L10n.of(context).changeaddress),
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
