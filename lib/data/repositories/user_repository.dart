import 'package:salon/configs/constants.dart';
import 'package:salon/data/data_provider.dart';
import 'package:salon/data/models/data_response_model.dart';
import 'package:salon/data/models/user_model.dart';
import 'package:salon/model/loginmodel.dart';

class UserRepository {
  const UserRepository({
    this.dataProvider = const DataProvider(),
  });

  final DataProvider dataProvider;

  Future<LoginModel> login({String email, String password})  {
    return LoginModel().loginUser(email, password);
  }

  Future<Map<String,dynamic>> register({String name,String email, String password})  {
    return LoginModel().registerUser(name,email, password);
  }

  Future<UserModel> getProfile() async {
    final DataResponseModel _data = await dataProvider.get('profile');

    return UserModel.fromJson(_data.data);
  }
}
