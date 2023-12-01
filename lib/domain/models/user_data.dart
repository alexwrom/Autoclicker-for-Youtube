


  class UserData{
    final int numberOfTrans;
    final int isBlock;
    final int isTakeBonus;


    const UserData(
        this.numberOfTrans,
      this.isBlock,
        this.isTakeBonus

  );

     UserData.unknown():
           numberOfTrans=0,
     isTakeBonus=0,
    isBlock=0;


    UserData copyWith({
    bool? isActive,
    int? numberOfTrans,
      int? numberOfTransActive,
    int? timeStampAuth,
      int? timeStampPurchase,
      int? isBlock,
      int? isTakeBonus
  }) {
    return UserData(
        numberOfTrans ?? this.numberOfTrans,
        isBlock??this.isBlock,
        isTakeBonus??this.isTakeBonus);

  }
}