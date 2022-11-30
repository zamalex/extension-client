import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:extension/blocs/auth/auth_bloc.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/configs/routes.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/main.dart';
import 'package:extension/model/constants.dart';
import 'package:extension/model/loginmodel.dart';
import 'package:extension/model/profile_data.dart';
import 'package:extension/utils/form_utils.dart';
import 'package:extension/utils/form_validator.dart';
import 'package:extension/utils/ui.dart';
import 'package:extension/widgets/form_label.dart';
import 'package:extension/widgets/list_title.dart';
import 'package:extension/widgets/modal_bottom_sheet_item.dart';
import 'package:extension/widgets/theme_button.dart';
import 'package:extension/widgets/theme_text_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final GlobalKey<ThemeTextInputState> keyPhoneInput = GlobalKey<ThemeTextInputState>();
  final GlobalKey<ThemeTextInputState> keyMailInput = GlobalKey<ThemeTextInputState>();
  final GlobalKey<ThemeTextInputState> keyAddressInput = GlobalKey<ThemeTextInputState>();
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
  LoginModel loginModel;
  String img = '';
  File _image;
  AuthBloc _authBloc;
  bool loading = false;
  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);

    getUser();

    _textNameController.text = getIt.get<AppGlobals>().user.fullName;
    _textPhoneController.text = getIt.get<AppGlobals>().user.phone;
    _textMailController.text = (getIt.get<AppGlobals>().user.email==null||getIt.get<AppGlobals>().user.email=='null')?'':getIt.get<AppGlobals>().user.email;
    _textAddressController.text =  getIt.get<AppGlobals>().user.address??'';
    _textZIPController.text = '';
    _textCityController.text = '';

    LoginModel().getProfileImage().then((value){
          setState(() {
            img=value;
          });
    });

    super.initState();
  }

  getUser()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final json = jsonDecode(prefs.getString('me')??null);
    final address =await prefs.getString('address')??'';
    if(json!=null){
       loginModel = LoginModel.fromJson(json as Map<String,dynamic>);

      if(loginModel!=null){
        getIt.get<AppGlobals>().user.fullName = loginModel.user.name;
        getIt.get<AppGlobals>().user.token = loginModel.accessToken;
        getIt.get<AppGlobals>().user.id = loginModel.user.id;
        getIt.get<AppGlobals>().user.phone= loginModel.user.phone;
        getIt.get<AppGlobals>().user.email= loginModel.user.email??'';
        getIt.get<AppGlobals>().user.address= loginModel.user.address??'';

        getIt.get<AppGlobals>().ID = loginModel.user.id;
        Globals.TOKEN = loginModel.accessToken;
        print(loginModel.user.name);

      }
    }
  }

  Future<void> _update() async {
    FormUtils.hideKeyboard(context);

    if (keyNameInput.currentState.validate()&&keyMailInput.currentState.validate()&&keyPhoneInput.currentState.validate()) {
      /*_authBloc.add(ProfileUpdatedAuthEvent(
        fullName: _textNameController.text,
        phone: _textPhoneController.text,
        email:_textMailController.text,
        address: _textAddressController.text,
        city: _textCityController.text,
        zip:'',
        image: _image,
      ));*/
      setState(() {
        loading = true;
      });
      if(_image!=null){
        final bytes =
        _image.readAsBytesSync();
        String img64 = base64Encode(bytes);
        print(_image.path.split('/').last);
        await ProfileData().updateImage(_image.path.split('/').last, img64);
      }

      await ProfileData().updateProfile(_textNameController.text,
          _textPhoneController.text,_textMailController.text,_textAddressController.text,_textCityController.text);

      setState(() {
        loading = false;
      });
      
      if(loginModel!=null){
        loginModel.user.email =  _textMailController.text??'';
        loginModel.user.name =  _textNameController.text;
        loginModel.user.phone =  _textPhoneController.text;
        loginModel.user.address =  _textAddressController.text;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        
        prefs.setString('me', jsonEncode(loginModel.toJson()));
        prefs.setString('address', _textAddressController.text);
        getIt.get<AppGlobals>().user.fullName = loginModel.user.name;
        getIt.get<AppGlobals>().user.token = loginModel.accessToken;
        getIt.get<AppGlobals>().user.id = loginModel.user.id;
        getIt.get<AppGlobals>().user.phone= loginModel.user.phone;
        getIt.get<AppGlobals>().user.email= loginModel.user.email??'';
        getIt.get<AppGlobals>().user.address=_textAddressController.text;
      }

      UI.showMessage(
        context,
        title: L10n.of(context).editProfileTitle,
        message: L10n.of(context).editProfileSuccess,
        buttonText: L10n.of(context).commonBtnClose,
        onPressed: () => Navigator.pop(context),
      );
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

    /*if (getIt.get<AppGlobals>().cameras.isNotEmpty) {
      _options.add(ModalBottomSheetItem<PhotoSource>(
        text: L10n.of(context).commonPhotoSources(PhotoSource.camera),
        value: PhotoSource.camera,
      ));
    }*/

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
                            image:img.isNotEmpty?NetworkImage(img): AssetImage('assets/images/onboarding/welcome.png')as ImageProvider,
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
                    key: keyPhoneInput,
                    validator: FormValidator.isRequired(L10n.of(context).formValidatorRequired),
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
                  const FormLabel(text: 'Email'),

                  ThemeTextInput(
                    key: keyMailInput,

                    validator: FormValidator.isRequired(L10n.of(context).formValidatorRequired),
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
                    key: keyAddressInput,

                    validator: FormValidator.isRequired(L10n.of(context).formValidatorRequired),
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
                  /*FormLabel(text: L10n.of(context).editProfileLabelCity),
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
                  ),*/
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
                      showLoading: loading,
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
