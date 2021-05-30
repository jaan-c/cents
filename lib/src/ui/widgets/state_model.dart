import 'package:flutter/widgets.dart';

/// Responsible for preparing and managing data for a [State].
///
/// Basically a [State] without the [State.build] method, so your [State]s can
/// focus on building widgets and its business logic will be placed in this
/// class.
class StateModel with ChangeNotifier {
  @mustCallSuper
  void initState() {}

  @mustCallSuper
  @override
  void dispose() {
    super.dispose();
  }
}

/// A class that integrate's [StateModel]'s lifecycle methods with [State].
///
/// Use it by extending [StateWithModel] instead of [State].
abstract class StateWithModel<T extends StatefulWidget, M extends StateModel>
    extends State<T> {
  @protected
  M get model;

  @mustCallSuper
  @override
  void initState() {
    super.initState();

    model.initState();
    model.addListener(() => setState(() {}));
  }

  @mustCallSuper
  @override
  void dispose() {
    model.dispose();

    super.dispose();
  }
}
