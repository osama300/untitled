import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:webview_flutter/webview_flutter.dart';


class PreviewScreen2 extends StatefulWidget {
  PreviewScreen2({Key? key}) : super(key: key);

  @override
  State<PreviewScreen2> createState() => _PreviewScreen2State();
}

class _PreviewScreen2State extends State<PreviewScreen2> {
  late WebViewController _controller;
  bool isLoad =true;
  List list=[];
  late dom.Document document;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: UI.TextDirection.rtl,
      child: Scaffold(
        body:SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                SizedBox(
                  height:1 ,
                  child:section(),
                ),
                isLoad ?
                Center(child: CircularProgressIndicator())
                    : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, int index) {
                        var name=  document.getElementsByClassName('eyebrow')
                            .elementAt(index).text;
                        return InkWell(
                          onTap: (){
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             PreviewScreen2(list: [id,name,pub,note,date ,url],)
                            //     ));
                          },
                          child: Text(name,)
                        );

                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget section() {
    return  WebView(
      initialUrl: "https://www.foxnews.com/",
      javascriptChannels: <JavascriptChannel>{
        _extractDataJSChannel(),
      },
      onPageFinished: (String url) {

          _controller.runJavascript("(function(){Flutter.postMessage(window.document.body.outerHTML)})();");

      },
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController wv){
        _controller = wv;
      },
    );
  }
  JavascriptChannel _extractDataJSChannel() {
    return JavascriptChannel(
      name: 'Flutter',
      onMessageReceived: (JavascriptMessage message) {
        String pageBody = message.message;
        document =  parser.parse(pageBody);
        list  = document.getElementsByTagName('eyebrow');
        var lis  = document.getElementsByClassName('eyebrow').elementAt(0).text;
        setState(()=> isLoad=false);
        print(list.length);
      },
    );
  }

}
