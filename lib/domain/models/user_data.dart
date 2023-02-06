


  class UserData{
    final bool isActive;
    final int numberOfTrans;
    final int numberOfTransActive;
    final int timeStampAuth;
    final  int timeStampPurchase;

    const UserData(
     this.isActive,
     this.numberOfTrans,
     this.numberOfTransActive,
     this.timeStampAuth,
        this.timeStampPurchase
  );

     UserData.unknown():
    isActive=false,
    numberOfTrans=0,
     numberOfTransActive=0,
    timeStampAuth=0,
     timeStampPurchase=0;

    UserData copyWith({
    bool? isActive,
    int? numberOfTrans,
      int? numberOfTransActive,
    int? timeStampAuth,
      int? timeStampPurchase
  }) {
    return UserData(
      isActive ?? this.isActive,
       numberOfTrans ?? this.numberOfTrans,
       numberOfTransActive??this.numberOfTransActive,
        timeStampAuth ?? this.timeStampAuth,
        timeStampPurchase??this.timeStampPurchase
    );
  }
}