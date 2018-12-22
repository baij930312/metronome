
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class DragDeleteTile<T> extends StatelessWidget {
  const DragDeleteTile({
    Key key,
    @required this.item,
    @required this.onDelete,
    @required this.child,
    @required this.dismissDirection,
  }) : super(key: key);

  final T item;
  final Widget child;
  final DismissDirection dismissDirection;

  final void Function(T) onDelete;

  void _handleDelete() {
    onDelete(item);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      customSemanticsActions: <CustomSemanticsAction, VoidCallback>{
        const CustomSemanticsAction(label: 'Delete'): _handleDelete,
      },
      child: Dismissible(
        key: ObjectKey(item),
        direction: dismissDirection,
        onDismissed: (DismissDirection direction) {
          _handleDelete();
        },
        background: Container(
            color: theme.primaryColor,
            child: const ListTile(
                trailing: Icon(Icons.delete, color: Colors.white, size: 36.0))),
        child: child,
      ),
    );
  }
}
