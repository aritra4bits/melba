import 'package:flutter/material.dart';

import 'package:melba/constants.dart';
import 'package:melba/widgets/app_buttons.dart';
import 'package:melba/widgets/star_rating.dart';

class FeedbackScreen extends StatefulWidget {

  @override
  FeedbackScreenState createState() => FeedbackScreenState();
}

class FeedbackScreenState extends State<FeedbackScreen> {
  String selectedEvent;
  List<String> events = ['Durga Puja', 'Kali Puja'];
  List<String> particulars = ['FOOD', 'DECORATIONS', 'LIGHT-N-SOUND', 'PUJA CEREMONY', 'OVERALL EVENT MGMT.'];
  static List<int> ratings = [];
  String feedback;
  @override
  void initState() {
    super.initState();
    for(int i = 0; i < particulars.length; i++){
      ratings.insert(i, 0);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBackgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Feedback'),
        ),
        body: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              child: DropdownButton(
                dropdownColor: Color(0xfff1df39),
                iconEnabledColor: Color(0xffb1232f),
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xffb1232f),
                ),
                underline: SizedBox(),
                hint: Text(
                  'Select event',
                  style: TextStyle(color: Color(0xffb1232f)),
                  maxLines: 1,
                ),
                value: selectedEvent,
                onChanged: (value) {
                  setState(() {
                    selectedEvent = value;
                  });
                },
                items: events.map((quantity) {
                  return DropdownMenuItem<dynamic>(
                    value: quantity,
                    child: Row(
                      children: <Widget>[
                        Text(
                          quantity,
                          style: TextStyle(color: Color(0xffb1232f)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20,),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: particulars.length,
              itemBuilder: (context, index) {
                return Rating(particular: particulars[index], index: index);
              },
            ),
            SizedBox(height: 20,),
            Container(
              alignment: Alignment.center,
              child: Container(
                width: 250,
                constraints: BoxConstraints(
                  maxHeight: 150,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  cursorColor: Colors.blue,
                  cursorHeight: 22,
                  decoration: textFieldDecoration.copyWith(hintText: 'Your review'),
                  validator: (value) {
                    if(value.isEmpty || value.length < 2){
                      return 'Please tell us about your experience';
                    }
                    feedback = value;
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: 20,),
            AppButton(
              label: 'Submit',
              onPressed: (){},
            ),
          ],
        ),
      ),
    );
  }
}

class Rating extends StatelessWidget {
  final String particular;
  final int index;
  const Rating({Key key, this.particular, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(particular, style: TextStyle(color: Color(0xffb1232f))),
        StatefulBuilder(
          builder: (context, setState) {
            return StarRating(
              onChanged: (rating){
                setState(() {
                  FeedbackScreenState.ratings.insert(index, rating);
                });
              },
              value: FeedbackScreenState.ratings[index],
            );
          }
        ),
      ],
    );
  }
}
