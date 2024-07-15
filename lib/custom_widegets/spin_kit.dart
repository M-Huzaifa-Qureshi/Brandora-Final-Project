
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
Widget loadingIndicator(){
  return const SpinKitCircle(
    duration: Duration(milliseconds: 500),
    color: Colors.purple
  );
}