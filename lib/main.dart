import 'package:flutter/material.dart';
import 'package:flutter_buscadorweb/Widgets/boton.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as web;

void main() => runApp(MaterialApp(
      title: 'Buscador Web en Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
    ));

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController webController;
  final TextEditingController txtMain = TextEditingController();
  bool showLoading = false;

  void cargar(bool booleano) {
    setState(() {
      showLoading = booleano;
    });
  }

  Future<void> cargarurl() async {
    String url = txtMain.text;
    url = "https://" + url;
    cargar(true);
    webController.loadUrl(url).then((onValue) {}).catchError((err) {
      cargar(false);
    });
    try {
      web.Response res = await web.get(Uri.parse(url));

      if (res.statusCode == 200) {
        webController.loadUrl(url);
      }
    } catch (err) {
      webController.loadUrl("https://duckduckgo.com/?q="
          "$url");
    }
  }

  Future<void> back() async {
    webController.goBack();
  }

  Future<void> forward() async {
    webController.goForward();
  }

  Future<void> reload() async {
    webController.clearCache();
  }

  void cargarHome() {
    webController.loadUrl("https://duckduckgo.com/");
    txtMain.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Flexible(
                              flex: 2,
                              child: Text(
                                "https://",
                                style: TextStyle(fontSize: 18),
                              )),
                          Flexible(
                            flex: 3,
                            child: TextField(
                              autocorrect: false,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.black87,
                                      width: 3),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.black38,
                                      width: 3),
                                ),
                              ),
                              controller: txtMain,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Center(
                              child: Boton(
                                  funcion: cargarurl,
                                  icon: Icons.search_rounded,
                                  iconSize: 27.0),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Center(
                              child: Boton(
                                  funcion: cargarHome,
                                  icon: Icons.home,
                                  iconSize: 27.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                    flex: 9,
                    child: Stack(
                      children: <Widget>[
                        WebView(
                          initialUrl: 'https://duckduckgo.com/',
                          onPageFinished: (data) {
                            cargar(false);
                          },
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (webViewController) {
                            webController = webViewController;
                          },
                        ),
                        (showLoading)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Center()
                      ],
                    )),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
                margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Boton(
                          funcion: back,
                          icon: Icons.arrow_back_ios_rounded,
                          iconSize: 27.0),
                      Boton(
                          funcion: forward,
                          icon: Icons.arrow_forward_ios_rounded,
                          iconSize: 27.0),
                      Boton(
                          funcion: reload,
                          icon: Icons.replay_rounded,
                          iconSize: 27.0),
                    ]))));
  }
}
