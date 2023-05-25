


  class UserData{
    final int numberOfTrans;
    // final int timeStampAuth;
    // final  int timeStampPurchase;

    const UserData(

     this.numberOfTrans,
        // this.timeStampAuth,
        // this.timeStampPurchase
  );

     UserData.unknown():

    numberOfTrans=0;
    // timeStampAuth=0,
    // timeStampPurchase=0;

    UserData copyWith({
    bool? isActive,
    int? numberOfTrans,
      int? numberOfTransActive,
    int? timeStampAuth,
      int? timeStampPurchase
  }) {
    return UserData(
        numberOfTrans ?? this.numberOfTrans,
        // timeStampAuth ?? this.timeStampAuth,
        // timeStampPurchase??this.timeStampPurchase
    );
  }
}