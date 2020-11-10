import 'package:flutter/material.dart';
import 'package:melba/constants.dart';

class EventScreen extends StatelessWidget {

  final List<EventItem> events = [
    EventItem(title: 'Durga Pujo 2020', subTitle: 'Virtual Event', days: '23-25', month: 'OCT', eventImage: 'assets/images/event_durga.PNG', eventDescription: 'Melba is glad to offer an opportunity to offer a covid safe virtual  Pushpanjali via Zoom Link on the auspicious pujo days this year. Please keep flowers for offering the pushpanjali ready.'),
    EventItem(title: 'Kali Pujo 2020', subTitle: 'Virtual Event', days: '14', month: 'NOV', eventImage: 'assets/images/event_kali.PNG', eventDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
    EventItem(title: 'Picnic 2020', subTitle: 'Outdoor Event', days: '20', month: 'DEC', eventImage: 'assets/images/event_picnic.PNG', eventDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBackgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Events'),
        ),
        body: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) => _eventBody(events[index]),
        ),
      ),
    );
  }
  Widget _eventBody(EventItem event){
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                child: Image.asset(event.eventImage),
                borderRadius: BorderRadius.circular(15),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      width: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15))
                      ),
                      child: Text(event.days, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      height: 30,
                      width: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))
                      ),
                      child: Text(event.month, style: TextStyle(color: Colors.blue),),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Text(event.title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Text(event.subTitle, style: TextStyle(color: Color(0xff982223), fontSize: 18, fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          Text(event.eventDescription, style: TextStyle(color: Colors.white),),
        ],
      ),
    );
  }
}

class EventItem{
  final String title;
  final String subTitle;
  final String days;
  final String month;
  final String eventImage;
  final String eventDescription;

  EventItem(
      {@required this.title, @required this.subTitle, @required this.days, @required this.month, @required this.eventImage, @required this.eventDescription});

}