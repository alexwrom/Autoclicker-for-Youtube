


  class UserData{
    final bool isActive;
    final int numberOfTrans;
    final int timeStamp;

    const UserData({
    required this.isActive,
    required this.numberOfTrans,
    required this.timeStamp,
  });

     UserData.unknown():
    isActive=false,
    numberOfTrans=0,
    timeStamp=0;
}