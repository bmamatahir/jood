import 'package:flutter/material.dart';
import 'package:jood/components/elevation.dart';
import 'package:jood/constants.dart';

enum Switcher {
  list,
  map,
}

class ListMapSwitcher extends StatelessWidget {
  final Function(Switcher) onChange;
  final Switcher value;

  ListMapSwitcher({Key key, this.onChange, this.value = Switcher.list}) : super(key: key);

  final double _borderRadius = 0;

  buildButton(context) {
    return (Switcher s) {
      bool _selected = value == s;
      Color bgc = _selected ? kPrimaryColor : Colors.transparent;
      Color fgc = _selected ? Colors.white : kTextColor;

      return InkWell(
        onTap: () {
          onChange(s);
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: bgc,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(
                value == Switcher.list ? _borderRadius : 0,
              ),
              right: Radius.circular(
                value == Switcher.map ? _borderRadius : 0,
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
    return PhysicalModel(
      elevation: 2,
      color: Colors.black26,
      borderRadius: BorderRadius.circular(
        _borderRadius,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
      ),
    );
  }
}
