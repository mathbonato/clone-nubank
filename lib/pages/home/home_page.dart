import 'package:clone_nubank/pages/home/widgets/item_menu_bottom.dart';
import 'package:clone_nubank/pages/home/widgets/menu_app.dart';
import 'package:clone_nubank/pages/home/widgets/my_app_bar.dart';
import 'package:clone_nubank/pages/home/widgets/my_dots_app.dart';
import 'package:clone_nubank/pages/home/widgets/page_view_app.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showMenu;
  int _currentIndex;
  double _yPosition;

  @override
  void initState() {
    super.initState();
    _showMenu = false;
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    if (_yPosition == null) {
      _yPosition = _screenHeight * .24;
    }

    return Scaffold(
        backgroundColor: Colors.purple[800],
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            MyAppBar(
              showMenu: _showMenu,
              onTap: () {
                setState(() {
                  _showMenu = !_showMenu;
                  _yPosition =
                      _showMenu ? _screenHeight * .75 : _screenHeight * .24;
                });
              },
            ),
            MenuApp(
              top: _screenHeight * .20,
              showMenu: _showMenu,
            ),
            PageViewApp(
              showMenu: _showMenu,
              top: _yPosition,
              onChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              onPanUpdate: (details) {
                double positionTopLimit = _screenHeight * .24;
                double positionBottonLimit = _screenHeight * .75;
                double midlePosition = positionBottonLimit - positionTopLimit;
                midlePosition = midlePosition / 2;

                setState(() {
                  _yPosition += details.delta.dy;

                  _yPosition = _yPosition < positionTopLimit
                      ? positionTopLimit
                      : _yPosition;

                  _yPosition = _yPosition > positionBottonLimit
                      ? positionBottonLimit
                      : _yPosition;

                  if (_yPosition != positionTopLimit && details.delta.dy < 0) {
                    _yPosition =
                        _yPosition < positionBottonLimit - midlePosition
                            ? positionTopLimit
                            : _yPosition;
                  }

                  if (_yPosition != positionBottonLimit &&
                      details.delta.dy > 0) {
                    _yPosition =
                        _yPosition > positionTopLimit + midlePosition - 50
                            ? positionBottonLimit
                            : _yPosition;
                  }

                  if (_yPosition == positionBottonLimit) {
                    _showMenu = true;
                  } else if (_yPosition == positionTopLimit) {
                    _showMenu = false;
                  }
                });
              },
            ),
            MyDotsApp(
              top: _screenHeight * .70,
              currentIndex: _currentIndex,
              showMenu: _showMenu,
            ),
            AnimatedPositioned(
              duration: Duration(microseconds: 200),
              bottom: _showMenu ? 0 : 0 + MediaQuery.of(context).padding.bottom,
              left: 0,
              right: 0,
              height: _screenHeight * 0.13,
              child: AnimatedOpacity(
                duration: Duration(microseconds: 200),
                opacity: _showMenu ? 0 : 1,
                child: Container(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ItemMenuBottom(
                        icon: Icons.person_add,
                        text: 'indicar amigos',
                      ),
                      ItemMenuBottom(
                        icon: Icons.phone_android,
                        text: 'Recarga de celular',
                      ),
                      ItemMenuBottom(
                        icon: Icons.chat,
                        text: 'Cobrar',
                      ),
                      ItemMenuBottom(
                        icon: Icons.monetization_on,
                        text: 'Empréstimos',
                      ),
                      ItemMenuBottom(
                        icon: Icons.move_to_inbox,
                        text: 'Depositar',
                      ),
                      ItemMenuBottom(
                        icon: Icons.mobile_screen_share,
                        text: 'Transferir',
                      ),
                      ItemMenuBottom(
                        icon: Icons.format_align_center,
                        text: 'Ajustar limite',
                      ),
                      ItemMenuBottom(
                        icon: Icons.chrome_reader_mode,
                        text: 'Pagar',
                      ),
                      ItemMenuBottom(
                        icon: Icons.lock_open,
                        text: 'Bloquear cartão',
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
