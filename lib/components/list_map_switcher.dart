import 'package:flutter/material.dart';
import 'package:jood/constants.dart';

enum Switcher {
  list,
  map,
}

class ListMapSwitcher extends StatefulWidget {
  final Function(Switcher) onChange;

  ListMapSwitcher({Key key, this.onChange}) : super(key: key);

  @override
  _ListMapSwitcherState createState() => _ListMapSwitcherState();
}

class _ListMapSwitcherState extends State<ListMapSwitcher> {
  Switcher _selected = Switcher.list;

  final double _borderRadius = 9.0;

  buildButton(context) {
    return (Switcher s) {
      Color bgc = _selected == s ? Colors.blue : Colors.transparent;
      Color fgc = _selected == s ? Colors.white : kTextColor;

      return InkWell(
        onTap: () {
          setState(() {
            _selected = s;
            widget.onChange(s);
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: bgc,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(
                _selected == Switcher.list ? _borderRadius : 0,
              ),
              right: Radius.circular(
                _selected == Switcher.map ? _borderRadius : 0,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                  s == Switcher.list
                      ? Icons.list_alt_outlined
                      : Icons.map_outlined,
                  color: fgc),
              SizedBox(width: 9),
              Text(
                s == Switcher.list ? "List" : "Map",
                style: TextStyle(
                  color: fgc,
                ),
              ),
            ],
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(
          _borderRadius,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildButton(context)(Switcher.list),
            VerticalDivider(width: 1),
            buildButton(context)(Switcher.map),
          ],
        ),
      ),
    );
  }
}
