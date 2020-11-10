class SignUpResponseModel{
  final String result;
  final String emailId;

  SignUpResponseModel({this.result, this.emailId});
  factory SignUpResponseModel.fromJson(Map<String, dynamic> json){
    return SignUpResponseModel(
        result: json['result'],
        emailId: json['email_id']
    );
  }
}