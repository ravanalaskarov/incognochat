import 'package:flutter_riverpod/flutter_riverpod.dart';


final textFiledValueControllerProvider = NotifierProvider.autoDispose<TextFieldValueController, String>(() => TextFieldValueController());


class TextFieldValueController extends AutoDisposeNotifier<String> {
  
  @override
  String build() => "";
  
  void changeValue(String value) => state = value;

}
