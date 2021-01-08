import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OnBoardingPageState();
  }
}

class OnBoardingPageState extends State<OnBoardingPage> {
  int _slideIndex = 0;

  final List<String> images = [
    "assets/images/slide_1.png",
    "assets/images/slide_2.png",
    "assets/images/slide_3.png",
    "assets/images/slide_4.png"
  ];

  final List<String> titles = [
    "Title Slide 1",
    "Title Slide 2",
    "Title Slide 3",
    "Title Slide 4"
  ];

  final List<String> subTitles = [
    "SubTitle Slide 1",
    "SubTitle Slide 2",
    "SubTitle Slide 3",
    "SubTitle Slide 4"
  ];

  final IndexController controller = IndexController();

  @override
  Widget build(BuildContext context) {
    TransformerPageView transformerPageView = TransformerPageView(
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            this._slideIndex = index;
          });
        },
        loop: false,
        controller: controller,
        transformer: new PageTransformerBuilder(
            builder: (Widget child, TransformInfo info) {
          return new Material(
              color: Colors.white,
              elevation: 8.0,
              textStyle: new TextStyle(color: Colors.white),
              borderRadius: new BorderRadius.circular(12.0),
              child: new Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new ParallaxContainer(
                            child: new Text(titles[info.index],
                                style: new TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 34.0,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold,
                                )),
                            position: info.position,
                            opacityFactor: .8,
                            translationFactor: 400.0,
                          ),
                          SizedBox(
                            height: 45.0,
                          ),
                          new ParallaxContainer(
                            child: new Image.asset(
                              images[info.index],
                              fit: BoxFit.contain,
                              height: 350,
                            ),
                            position: info.position,
                            translationFactor: 400.0,
                          ),
                          SizedBox(
                            height: 45.0,
                          ),
                          new ParallaxContainer(
                            child: new Text(
                              subTitles[info.index],
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 28.0,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold),
                            ),
                            position: info.position,
                            translationFactor: 300.0,
                          ),
                          SizedBox(
                            height: 55.0,
                          ),
                        ],
                      ))));
        }),
        itemCount: 4);

    return Scaffold(
      backgroundColor: Colors.white,
      body: transformerPageView,
    );
  }
}
