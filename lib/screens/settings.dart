import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:salon/blocs/application/application_bloc.dart';
import 'package:salon/blocs/theme/theme_bloc.dart';
import 'package:salon/configs/app_theme.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/main.dart';
import 'package:salon/screens/policy/policy.dart';
import 'package:salon/utils/async.dart';
import 'package:salon/utils/ui.dart';
import 'package:salon/widgets/arrow_right_icon.dart';
import 'package:salon/widgets/list_item.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/widgets/list_title.dart';
import 'package:salon/widgets/picker.dart';
import 'package:salon/widgets/strut_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(L10n.of(context).settingsTitle),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
              child: Column(
                children: <Widget>[
                  ListTitle(title: L10n.of(context).settingsListTitleInterface),
                  ListItem(
                    title: L10n.of(context).settingsListLanguage,
                    onPressed: () => _showLanguagePicker(context),
                    trailing: Row(
                      children: <Widget>[
                        StrutText(
                          L10n.of(context).commonLocales(getIt.get<AppGlobals>().selectedLocale.toString()),
                          style: Theme.of(context).textTheme.bodyText1.bold,
                        ),
                        const ArrowRightIcon(),
                      ],
                    ),
                  ),
                 /* ListItem(
                    title: L10n.of(context).settingsListDarkMode,
                    onPressed: () => _showDarkModePicker(context),
                    trailing: Row(
                      children: <Widget>[
                        StrutText(
                          L10n.of(context).commonDarkMode(getIt.get<AppGlobals>().darkThemeOption.toString()),
                          style: Theme.of(context).textTheme.bodyText1.bold,
                        ),
                        const ArrowRightIcon(),
                      ],
                    ),
                  )*/
                  ListTitle(title: L10n.of(context).settingsListTitleSupport),
                  ListItem(
                    title: L10n.of(context).settingsListTerms,
                    trailing: const ArrowRightIcon(),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder:(m)=>PolicyScreen('support',getIt.get<AppGlobals>().isRTL?'الشروط والأحكام':'terms and conditions'))),
                  ),
                  ListItem(
                    title: L10n.of(context).settingsListPrivacy,
                    trailing: const ArrowRightIcon(),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder:(m)=>PolicyScreen('return',getIt.get<AppGlobals>().isRTL?'سياسة الخصوصية':'privacy policy'))),

                    // onPressed: () => Async.launchUrl(kPrivacyPolicyURL),
                  ),
                  /*Padding(
                    padding: const EdgeInsets.symmetric(vertical: kPaddingL),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            UI.confirmationDialogBox(
                              context,
                              message: L10n.of(context).settingsHomepageConfirmation,
                              onConfirmation: () => Async.launchUrl(kHomepageURL),
                            );
                          },
                          child: Container(
                            height: 80,
                            child: const Image(image: AssetImage(AssetsImages.icon)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: kPaddingS),
                          child: StrutText(
                            kAppName,
                            style: Theme.of(context).textTheme.headline6.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: kPaddingS),
                          child: StrutText(
                            'v$_version+$_buildNumber',
                            style: Theme.of(context).textTheme.bodyText2.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: kPaddingS, bottom: kPaddingS),
                          child: StrutText(
                            L10n.of(context).settingsCopyright,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final List<PickerItem<Locale>> _pickerItems = <PickerItem<Locale>>[];
    final List<PickerItem<Locale>> _selectedItems = <PickerItem<Locale>>[];

    for (final Locale _l in L10n.delegate.supportedLocales) {
      _pickerItems.add(PickerItem<Locale>(
        text: L10n.of(context).commonLocales(_l.toString()),
        value: _l,
      ));
    }

    _selectedItems.add(PickerItem<Locale>(
      text: L10n.of(context).commonLocales(getIt.get<AppGlobals>().selectedLocale.toString()),
      value: getIt.get<AppGlobals>().selectedLocale,
    ));

    final dynamic selectedLanguage = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: <String, dynamic>{
        'title': L10n.of(context).pickerTitleLanguages,
        'items': _pickerItems,
        'itemsSelected': _selectedItems,
      },
    );

    if (selectedLanguage != null) {
      BlocProvider.of<ApplicationBloc>(context).add(ChangeRequestedLanguageApplicationEvent(selectedLanguage as Locale));
    }
  }

  Future<void> _showDarkModePicker(BuildContext context) async {
    final List<PickerItem<DarkOption>> _pickerItems = <PickerItem<DarkOption>>[];
    final List<PickerItem<DarkOption>> _selectedItems = <PickerItem<DarkOption>>[];

    for (final DarkOption option in DarkOption.values) {
      _pickerItems.add(PickerItem<DarkOption>(
        text: L10n.of(context).commonDarkMode(option.toString()),
        value: option,
      ));
    }

    _selectedItems.add(PickerItem<DarkOption>(
      text: L10n.of(context).commonDarkMode(getIt.get<AppGlobals>().darkThemeOption),
      value: getIt.get<AppGlobals>().darkThemeOption,
    ));

    final dynamic selectedDarkMode = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: <String, dynamic>{
        'title': L10n.of(context).settingsListDarkMode,
        'items': _pickerItems,
        'itemsSelected': _selectedItems,
      },
    );

    if (selectedDarkMode != null) {
      BlocProvider.of<ThemeBloc>(context).add(ChangeRequestedThemeEvent(darkOption: selectedDarkMode as DarkOption));
    }
  }
}
