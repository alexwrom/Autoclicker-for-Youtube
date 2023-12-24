


  class UserData{
    final int numberOfTrans;
    final int isBlock;
    final int isTakeBonus;
    final bool init;
    final List<dynamic> channels;


    const UserData(
        this.init,
        this.numberOfTrans,
      this.isBlock,
        this.isTakeBonus,
        this.channels

  );

     UserData.unknown():
         init = false,
           numberOfTrans=0,
     isTakeBonus=0,
    isBlock=0,
    channels = [];


    UserData copyWith({
      bool? init,
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
      init??this.init,
        numberOfTrans ?? this.numberOfTrans,
        isBlock??this.isBlock,
        isTakeBonus??this.isTakeBonus,
        channels??this.channels);

  }
}