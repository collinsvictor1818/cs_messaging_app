import 'package:flutter/material.dart';

class BuildList extends StatefulWidget {
  final BuildContext? context; // Pass BuildContext as a parameter
  final String? title;
  final String? desc;
  final IconData? icon;
  final VoidCallback? onClicked;

  const BuildList({
    Key? key,
    this.context, // Pass BuildContext as a parameter
    this.title,
    this.desc,
    this.icon,
    this.onClicked,
  }) : super(key: key);

  @override
  State<BuildList> createState() => _buildListState();
}

class _buildListState extends State<BuildList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 10)
          .add(const EdgeInsets.symmetric(horizontal: 18)),
      // padding: EdgeInsets.symmetric(horizontal: 15),
      child: PhysicalModel(
        clipBehavior: Clip.none,
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
        child: Center(
          child: SizedBox(
              height: 68,
              child: ListTile(
                  dense: true,
                  leading: Transform.translate(
                      offset: const Offset(0, 0),
                      child: Icon(widget.icon,
                          color: Theme.of(context).colorScheme.tertiary)),
                  title: Transform.translate(
                      offset: const Offset(-10, 2),
                      child: Text(
                        '${widget.title}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontFamily: 'Gilmer',
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      )),
                  subtitle: Transform.translate(
                      offset: const Offset(-10,-2),
                      child: Text(
                        '${widget.desc}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontFamily: 'Gilmer',
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      )),
                  trailing: Transform.translate(
                    offset: const Offset(10, 0),
                    child: IconButton(
                        icon: const Icon(Icons.chevron_right_rounded),
                        iconSize: 25,
                        onPressed: widget.onClicked),
                  ),
                  onTap: widget.onClicked)),
        ),
      ),
    );
  }
}
