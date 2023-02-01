


  class UserData{
    final bool isActive;
    final int numberOfTrans;
    final int numberOfTransActive;
    final int timeStamp;

    const UserData(
     this.isActive,
     this.numberOfTrans,
     this.numberOfTransActive,
     this.timeStamp,
  );

     UserData.unknown():
    isActive=false,
    numberOfTrans=0,
     numberOfTransActive=0,
    timeStamp=0;

    UserData copyWith({
    bool? isActive,
    int? numberOfTrans,
      int? numberOfTransActive,
    int? timeStamp,
  }) {
    return UserData(
      isActive ?? this.isActive,
       numberOfTrans ?? this.numberOfTrans,
       numberOfTransActive??this.numberOfTransActive,
       timeStamp ?? this.timeStamp,
    );
  }
}