library g2x_mask_text_input_formatter;

import 'package:flutter/services.dart';

///
///var mask = G2xDateTextInputFormatter(mask: "dd/MM/yyyy", seperator: "/");
///
/// ### initialize value
///var mask = G2xDateTextInputFormatter(mask: "dd/MM/yyyy", seperator: "/");
///var text = mask.applyMask(DateTime.now())
///
///TextField(
///  keyboardType: TextInputType.number,
///  inputFormatters: [
///    mask.getTextInputFormatter()
///  ]
///)
///
class G2xDateTextInputFormatter {
  final String mask;
  final String seperator;
  G2xDateTextInputFormatter({
    required this.mask,
    required this.seperator,
  });

  _G2xGenericTextInputFormatter getTextInputFormatter(){
    return G2xGenericTextInputFormatter(mask: mask, seperators: [seperator], onlyIntNumber: true).getTextInputFormatter();
  }

  String applyMask(DateTime value){
    var day = value.day < 10 ? "0${value.day}" : value.day.toString();
    var month = value.month < 10 ? "0${value.month}" : value.month.toString();
    var year = value.year.toString();
    return mask.replaceAll("dd", day).replaceAll("MM", month).replaceAll("yyyy", year);
  }
}

///
////var mask = G2xGenericTextInputFormatter(mask: "###.###.###-##", seperators: [".", "-"]);
///
/// ### initialize value
///var mask = G2xGenericTextInputFormatter(mask: "###.###.###-##", seperators: [".", "-"]);
///var text = mask.applyMask("66787337035")
///
///TextField(
///  keyboardType: TextInputType.number,
///  inputFormatters: [
///    mask.getTextInputFormatter()
///  ]
///)
///
class G2xGenericTextInputFormatter {
  final String mask;
  final List<String> seperators;
  final bool onlyIntNumber;
  G2xGenericTextInputFormatter({
    required this.mask,
    required this.seperators,
    this.onlyIntNumber = false
  });

  _G2xGenericTextInputFormatter getTextInputFormatter(){
    return _G2xGenericTextInputFormatter(mask: mask, seperators: seperators, func: applyMask);
  }

  String applyMask(String value){
    for (var i = 0; i < value.length; i++) {
      if(seperators.indexOf(mask[i]) > -1 && seperators.indexOf(value[i]) == -1){
        value = value.substring(0, i) + mask[i] + value.substring(i);
      }
    }
    return value;
  }
}

class _G2xGenericTextInputFormatter extends TextInputFormatter {
  final String mask;
  final List<String> seperators;
  final Function func;
  _G2xGenericTextInputFormatter({
    required this.mask,
    required this.seperators,
    required this.func
  });
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(oldValue.text.length > newValue.text.length) return newValue;
    var text = func(newValue.text);
    int selectionIndex = text.length;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}