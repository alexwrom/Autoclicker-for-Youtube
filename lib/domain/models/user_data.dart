


  class UserData{
    final bool isActive;
    final int numberOfTrans;
    final int numberOfTransActive;
    final int timeStamp;
    final bool isSubscribe;

    const UserData(
     this.isActive,
     this.numberOfTrans,
     this.numberOfTransActive,
     this.timeStamp,
        this.isSubscribe
  );

     UserData.unknown():
    isActive=false,
    numberOfTrans=0,
     numberOfTransActive=0,
    timeStamp=0,
     isSubscribe=false;

    UserData copyWith({
    bool? isActive,
    int? numberOfTrans,
      int? numberOfTransActive,
    int? timeStamp,
      bool? isSubscribe
  }) {
    return UserData(
      isActive ?? this.isActive,
       numberOfTrans ?? this.numberOfTrans,
       numberOfTransActive??this.numberOfTransActive,
       timeStamp ?? this.timeStamp,
      isSubscribe??this.isSubscribe
    );
  }
}