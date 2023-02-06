



import '../../domain/models/user_data.dart';
import '../models/user_data_from_api.dart';

class UserDataMapper{


    static UserData fromApi({required UserDataFromApi userDataFromApi}){
      return UserData(userDataFromApi.isActive, userDataFromApi.numberOfTrans,userDataFromApi.numberOfTransActive, userDataFromApi.timeStampAuth,userDataFromApi.timeStampPurchase);
    }

  }