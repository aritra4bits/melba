class FacebookData{
  final String fullPicture;
  final String id;
  final String message;

  FacebookData({this.fullPicture, this.id, this.message});

  factory FacebookData.fromJson(Map<String, dynamic> json){
    return FacebookData(
      fullPicture: json['full_picture'],
      message: json['message'],
      id: json['id'],
    );
  }
}