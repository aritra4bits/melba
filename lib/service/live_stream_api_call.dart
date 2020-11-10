import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:melba/data_models/live_stream_data_model.dart';

class LiveStreamAccessToken{
  String _appId = '';
  String _token = '';
  String _channel = '';
  String get appId{
    return _appId;
  }
  String get token{
    return _token;
  }
  String get channel{
    return _channel;
  }
  Future<LiveStreamData> getLiveStreamTokens() async {
    final http.Response response = await http.post(
      'https://us-central1-melba-flutter.cloudfunctions.net/app/getStreamToken',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email_id': 'admin@melba.au.org',
      }),
    );
    print('Live Stream Response code = ${response.statusCode}');
    print('Live Stream Response = ${response.body}');
    if (response.statusCode == 200) {
      LiveStreamData liveStreamData = LiveStreamData.fromJson(jsonDecode(response.body));
      _token = liveStreamData.token;
      _appId = liveStreamData.appId;
      _channel = liveStreamData.channelId;
      return liveStreamData;
    } else {
      throw Exception('Failed to get Stream Tokens.');
    }
  }

}

const String APP_ID  = "888f844b7f0a488993c4df4c739686ed";//"af233ac6b94f4c63b562962e8186e9df";
const String TOKEN   = "006888f844b7f0a488993c4df4c739686edIADBo6nFGsTUc+DvFsos6t3mJLY81R5eawDULZ/3PS3Ud5wPuMIAAAAAEABqf2Zw63elXwEAAQDqd6Vf";//"""006af233ac6b94f4c63b562962e8186e9dfIACnhhxLx8TaYObnY+IWhu7spd61Si1C/Cf0ubUX0zxZzjO8qkEAAAAAEAAT20h7kBSlXwEAAQCOFKVf";
const String CHANNEL = "melba-live";