import 'package:flutter/widgets.dart';

import 'authorization_bloc.dart';

class AuthorizationProvider extends InheritedWidget {
  final AuthorizationBloc authorizationBloc;

  AuthorizationProvider({
    Key key,
    AuthorizationBloc authorizationBloc,
    Widget child,
  })  : authorizationBloc = authorizationBloc ?? AuthorizationBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AuthorizationBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(AuthorizationProvider)
              as AuthorizationProvider)
          .authorizationBloc;
}
