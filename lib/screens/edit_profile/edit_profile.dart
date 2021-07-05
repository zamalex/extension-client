import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/blocs/auth/auth_bloc.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/main.dart';
import 'package:salon/utils/form_utils.dart';
import 'package:salon/utils/form_validator.dart';
import 'package:salon/utils/ui.dart';
import 'package:salon/widgets/form_label.dart';
import 'package:salon/widgets/list_title.dart';
import 'package:salon/widgets/modal_bottom_sheet_item.dart';
import 'package:salon/widgets/theme_button.dart';
import 'package:salon/widgets/theme_text_input.dart';

enum PhotoSource { gallery, camera }

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() {
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<ThemeTextInputState> keyNameInput = GlobalKey<ThemeTextInputState>();
  final TextEditingController _textNameController = TextEditingController();
  final TextEditingController _textPhoneController = TextEditingController();
  final TextEditingController _textAddressController = TextEditingController();
  final TextEditingController _textCityController = TextEditingController();
  final TextEditingController _textZIPController = TextEditingController();
  final TextEditingController _textMailController = TextEditingController();
  final FocusNode _focusName = FocusNode();
  final FocusNode _focusPhone = FocusNode();
  final FocusNode _focusAddress = FocusNode();
  final FocusNode _focusCity = FocusNode();
  final FocusNode _focusZIP = FocusNode();
  final FocusNode _focusMail = FocusNode();

  File _image;
  AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);

    _textNameController.text = getIt.get<AppGlobals>().user.fullName;
    _textPhoneController.text = getIt.get<AppGlobals>().user.phone;
    _textAddressController.text = getIt.get<AppGlobals>().user.address;
    _textZIPController.text = getIt.get<AppGlobals>().user.zip;
    _textCityController.text = getIt.get<AppGlobals>().user.city;

    super.initState();
  }

  Future<void> _update() async {
    FormUtils.hideKeyboard(context);

    if (keyNameInput.currentState.validate()) {
      _authBloc.add(ProfileUpdatedAuthEvent(
        fullName: _textNameController.text,
        phone: _textPhoneController.text,
        address: _textAddressController.text,
        city: _textCityController.text,
        zip: _textZIPController.text,
        image: _image,
      ));
    }
  }

  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();
    final PickedFile image = await picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _image = File(image.path));
    }
  }

  void _photoSourceSelection(BuildContext context) {
    final List<ModalBottomSheetItem<PhotoSource>> _options = <ModalBottomSheetItem<PhotoSource>>[];

    _options.add(ModalBottomSheetItem<PhotoSource>(
      text: L10n.of(context).commonPhotoSources(PhotoSource.gallery),
      value: PhotoSource.gallery,
    ));

    if (getIt.get<AppGlobals>().cameras.isNotEmpty) {
      _options.add(ModalBottomSheetItem<PhotoSource>(
        text: L10n.of(context).commonPhotoSources(PhotoSource.camera),
        value: PhotoSource.camera,
      ));
    }

    showModalBottomSheet<PhotoSource>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return ModalBottomSheet(
          options: _options,
          onChange: (dynamic item) async {
            final PhotoSource selectedSource = item as PhotoSource;
            if (selectedSource == PhotoSource.gallery) {
              _getImage();
            } else {
              await Navigator.pushNamed<String>(context, Routes.takePicture).then((String imagePath) {
                if (imagePath != null) {
                  setState(() => _image = File(imagePath));
                }
              });
            }
          },
        );
      },
    );
  }

  Widget _profilePicture() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => _photoSourceSelection(context),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                width: 128,
                height: 128,
                child: _image == null
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(getIt.get<AppGlobals>().user.profilePhoto),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(64),
                        child: Image.file(
                          _image,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(L10n.of(context).editProfileTitle),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: kPaddingM, right: kPaddingM, top: kPaddingM),
                children: <Widget>[
                  _profilePicture(),
                  ListTitle(title: L10n.of(context).editProfileListTitleContact),
                  FormLabel(text: L10n.of(context).editProfileLabelFullname),
                  ThemeTextInput(
                    key: keyNameInput,
                    focusNode: _focusName,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (String text) {
                      FormUtils.fieldFocusChange(
                        context,
                        _focusName,
                        _focusPhone,
                      );
                    },
                    controller: _textNameController,
                    validator: FormValidator.isRequired(L10n.of(context).formValidatorRequired),
                  ),
                  FormLabel(text: L10n.of(context).editProfileLabelPhone),
                  ThemeTextInput(
                    focusNode: _focusPhone,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (String text) {
                      FormUtils.fieldFocusChange(
                        context,
                        _focusPhone,
                        _focusMail,
                      );
                    },
                    controller: _textPhoneController,
                  ),
                  FormLabel(text: L10n.of(context).signInHintEmail),

                  ThemeTextInput(
                    focusNode: _focusMail,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (String text) {
                      FormUtils.fieldFocusChange(
                        context,
                        _focusPhone,
                        _focusMail,
                      );
                    },
                    controller: _textMailController,
                  ),
                  ListTitle(title: L10n.of(context).editProfileListTitleAddress),
                  FormLabel(text: L10n.of(context).editProfileLabelAddress),
                  ThemeTextInput(
                    focusNode: _focusAddress,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (String text) {
                      FormUtils.fieldFocusChange(
                        context,
                        _focusAddress,
                        _focusCity,
                      );
                    },
                    controller: _textAddressController,
                  ),
                  FormLabel(text: L10n.of(context).editProfileLabelCity),
                  ThemeTextInput(
                    focusNode: _focusCity,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (String text) {
                      FormUtils.fieldFocusChange(
                        context,
                        _focusCity,
                        _focusZIP,
                      );
                    },
                    controller: _textCityController,
                  ),
                 /* FormLabel(text: L10n.of(context).editProfileLabelZIP),
                  ThemeTextInput(
                    focusNode: _focusZIP,
                    textInputAction: TextInputAction.next,
                    controller: _textZIPController,
                  ),*/
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingM, vertical: kPaddingS),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (BuildContext context, AuthState apiState) {
                  return BlocListener<AuthBloc, AuthState>(
                    listener: (BuildContext context, AuthState apiListener) {
                      if (apiListener is ProfileUpdateFailureAuthState) {
                        UI.showErrorDialog(context, message: apiListener.message);
                      }
                      if (apiListener is ProfileUpdateSuccessAuthState) {
                        UI.showMessage(
                          context,
                          title: L10n.of(context).editProfileTitle,
                          message: L10n.of(context).editProfileSuccess,
                          buttonText: L10n.of(context).commonBtnClose,
                          onPressed: () => Navigator.pop(context),
                        );
                      }
                    },
                    child: ThemeButton(
                      onPressed: _update,
                      text: L10n.of(context).editProfileBtnUpdate,
                      showLoading: apiState is ProcessInProgressAuthState,
                      disableTouchWhenLoading: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
