


  class UserData{
    final int numberOfTrans;
    final int isBlock;
    final int isTakeBonus;
    final List<dynamic> channels;


    const UserData(
        this.numberOfTrans,
      this.isBlock,
        this.isTakeBonus,
        this.channels

  );

     UserData.unknown():
           numberOfTrans=0,
     isTakeBonus=0,
    isBlock=0,
    channels = [];


    UserData copyWith({
    bool? isActive,
    int? numberOfTrans,
      int? numberOfTransActive,
    int? timeStampAuth,
      int? timeStampPurchase,
      int? isBlock,
      int? isTakeBonus,
      List<dynamic>? channels
  }) {
    return UserData(
        numberOfTrans ?? this.numberOfTrans,
        isBlock??this.isBlock,
        isTakeBonus??this.isTakeBonus,
        channels??this.channels);

  }
}