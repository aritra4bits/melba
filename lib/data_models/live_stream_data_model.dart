class LiveStreamData {
  final String channelId;
  final String token;
  final String appId;

  LiveStreamData({this.channelId, this.token, this.appId});

  factory LiveStreamData.fromJson(Map<String, dynamic> json) {
    return LiveStreamData(
      channelId: json['channel_id'],
      token: json['token'],
      appId: json['app_id']
    );
  }
}