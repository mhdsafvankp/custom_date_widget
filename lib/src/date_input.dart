
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDateField extends StatefulWidget {

  const CustomDateField(
      {Key? key,
        this.preFillDate,
        required this.errorCallback,
        required this.currentValue,
        required this.onPressRightIcon,
        required this.rightIconSvg, this.onTapCallBack, this.onParticularTapCallBack, this.validation, this.isMinor})
      : super(key: key);

  final String? preFillDate;
  final Function(String) errorCallback;
  final Function(String) currentValue;
  final Function() onPressRightIcon;
  final Function()? onTapCallBack;
  final Function(String)? onParticularTapCallBack;
  final Map<String, dynamic>? validation;
  final String? isMinor;

  final Icon? rightIconSvg;

  @override
  createState() => _CustomDateFieldState();
}

enum BoarderEnum { unFocus , focus , error }

class _CustomDateFieldState extends State<CustomDateField> {
  List<String> validateArray = ['DD','MM','YYYY','18year','99year'];

  var c1 = TextEditingController();
  var c2 = TextEditingController();
  var c3 = TextEditingController();
  var f1 = FocusNode();
  var f2 = FocusNode();
  var f3 = FocusNode();
  var borderLine = BoarderEnum.unFocus;

  var isHint1 = true;
  var isHint2 = true;
  var prefillText = '';
  var errorTxt = '';

  _validate(){
    for(var i = 0 ; i < validateArray.length ; i++){
      errorTxt = _validateFields(validateArray[i]);
      if(errorTxt.isNotEmpty){
        widget.errorCallback(errorTxt);
        break;
      }
    }
    if(errorTxt.isEmpty){
      widget.errorCallback('');
      if(f1.hasFocus || f2.hasFocus || f3.hasFocus){
        FocusScope.of(context).unfocus();
      }
    }
  }

  String _validateFields(String type){

    var error = '';
    if(type == 'DD'){
      if(c1.text.isEmpty){
        error = _getValidationMsg('DT001');
      }else{
        var dd = int.parse(c1.text.toString());
        if(dd<1 || dd > 31){
          error = _getValidationMsg('DT004');
        }
      }
    }else if(type == 'MM' ){
      if(c2.text.isEmpty){
        error = _getValidationMsg('DT002');
      }else{
        var mm = int.parse(c2.text.toString());
        if(mm<1 || mm > 12){
          error = _getValidationMsg('DT005');
        }
      }
    }else if(type == 'YYYY'){
      if(c3.text.isEmpty){
        error = _getValidationMsg('DT003');
      }else{
        if(_yearValidate(c3.text.toString())){
          error = _getValidationMsg('DT006');
        }
      }
    }else if(type == '18year' && widget.isMinor == 'true' ){
      if(_isNot18older(_getFinalval() ?? '')){
        error = _getValidationMsg('DT007');
      }
    }else if(type == '99year'){
      if(_yearValidateMax99(_getFinalval() ?? '')){
        error = _getValidationMsg('DT008');
      }
    }
    //widget.errorCallback(error,isShow.toString());
    return error;
  }

  String _getValidationMsg(String errorCode){
    var e = '';
    var validation = widget.validation ?? defaultValidationValues();
    if(validation.containsKey(errorCode)) {
      e = validation[errorCode];
    }
    return e;
  }

  Map<String, dynamic> defaultValidationValues(){
    return {
      'DT001' : "Date is mandatory. Don't leave it blank.",
      'DT002' : "Month is mandatory. Don't leave it blank.",
      'DT003' : "Year is mandatory. Don't leave it blank.",
      'DT004' : 'Kindly enter a valid date between 1 & 31',
      'DT005' : 'Kindly enter a valid month between 1 & 12',
      'DT006' : 'Kindly enter a valid year',
      'DT007': 'You must be at least 18 years of age to open an account online.',
      'DT008': "Currently, we don't accept applications of people aged over 99 years."
    };
  }


  bool _yearValidate(String yyyy){
    if(yyyy.length == 4){
      var todayYear = DateTime.now().year;  // max
      var yy = int.parse(yyyy);
      return ( yy > todayYear );
    }else{
      return false;
    }
  }

  bool _yearValidateMax99(String birthDateString){
    if (birthDateString.isNotEmpty && '/'.allMatches(birthDateString).length == 2) {
      var array = birthDateString.split('/');
      var birthDate =
      DateTime(int.parse(array[2]), int.parse(array[1]), int.parse(array[0]));
      var today = DateTime.now();
      var maxDate = DateTime(today.year - 99 , today.month , today.day);
      return birthDate.isBefore(maxDate);
    }else {
      return false;
    }
  }


  bool _isNot18older(String birthDateString) {
    if (birthDateString.isNotEmpty && '/'.allMatches(birthDateString).length == 2) {
      var array = birthDateString.split('/');
      var birthDate =
      DateTime(int.parse(array[2]), int.parse(array[1]), int.parse(array[0]));
      var adultDate = DateTime(
        birthDate.year + 18,
        birthDate.month,
        birthDate.day,
      );
      var today = DateTime.now();
      return today.isBefore(adultDate);
    }
    return false;
  }

  _addPreFillDate(){
    var date = widget.preFillDate;
    if(date!.isNotEmpty && '/'.allMatches(date).length == 2){
      var splitArray = date.split('/');
      c1.text = splitArray[0];
      c2.text = splitArray[1];
      c3.text = splitArray[2];
      widget.currentValue( _getFinalval() ?? '');
      _validate();
    }else if(date == ''){
      c1.text = '';
      c2.text = '';
      c3.text = '';
    }
    prefillText = date;
  }

  String? _getFinalval(){
    return '${c1.text}/${c2.text}/${c3.text}';
  }

  Widget _getInputField(String hint , BuildContext context ,TextEditingController controller ,FocusNode f){
    return IntrinsicWidth(
      child: TextFormField(
        focusNode: f,
        cursorColor: Theme.of(context).textTheme.displayLarge?.color,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        maxLines: 1,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
        ],
        controller: controller,
        maxLength: (hint == 'DD' || hint == 'MM') ? 2 : 4,
        decoration: InputDecoration(
          isDense: true,
            hintText: hint,
            border: InputBorder.none,
            counterText: '',
        ),
        onTap: (){
          //debugPrint('on tap called $hint');
          if(widget.onParticularTapCallBack != null){
            widget.onParticularTapCallBack!(hint);
          }
        },

        onChanged: (value){
          if(value.isEmpty && hint == 'YYYY'){
            debugPrint('previous focus YYYY');
            FocusScope.of(context).previousFocus();
          }else if(value.isEmpty && hint == 'MM'){
            debugPrint('previous focus MM');
            FocusScope.of(context).previousFocus();
          }
          if(value.length >= 2 && (hint == 'DD' || hint == 'MM')){
            if(hint == 'DD'){
              isHint1 = false;
              setState(() {
              });
              errorTxt = _validateFields('DD');
            }else if(hint == 'MM'){
              isHint2 = false;
              setState(() {
              });
              errorTxt = _validateFields('MM');
            }
            if(errorTxt.isNotEmpty){
              widget.errorCallback(errorTxt);
            }else{
              FocusScope.of(context).nextFocus();
            }
          }else if(value.length == 4 && hint == 'YYYY' ){
            errorTxt = _validateFields('YYYY');
            if(errorTxt.isNotEmpty){
              widget.errorCallback(errorTxt);
            }
            //print('Choose Date: ${c1.text}/${c2.text}/${c3.text}');
          }else if(value.length < 2 && (hint == 'DD' || hint == 'MM')){
            if(hint == 'DD' && c2.text.isEmpty){
              isHint1 = true;
              setState(() {
              });
            }else if(hint == 'MM' && c3.text.isEmpty){
              isHint2 = true;
              setState(() {
              });
            }
          }
          widget.currentValue( _getFinalval() ?? '');
          if(_getFinalval() != null && _getFinalval()!.length == 10){
            _validate();
          }else{
            widget.errorCallback(errorTxt);
          }
          setState(() {
          });
        },

      ),
    );
  }


  TextStyle? _getSlashStyle(isHint, BuildContext context ){
    return isHint?  TextStyle(
        color: Theme.of(context).hintColor
    ) : TextStyle(color: Theme.of(context).textTheme.headlineMedium?.color);
  }

  Color _getBoarderColor(){
    debugPrint('val : $borderLine');
    if(BoarderEnum.focus == borderLine){
      return Theme.of(context).primaryColor;
    }else if(BoarderEnum.unFocus == borderLine){
      return Theme.of(context).dividerColor;
    }else{
      return Theme.of(context).colorScheme.error;
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('preFilled val initState - > ${widget.preFillDate} ');
    if(widget.preFillDate !=null ){
      _addPreFillDate();
    }

  }
  @override
  Widget build(BuildContext context) {
    debugPrint('preFilled val  Widget build- > ${widget.preFillDate} ');

    if(f1.hasFocus || f2.hasFocus || f3.hasFocus){
      borderLine = BoarderEnum.focus;
      if(errorTxt.isNotEmpty){
        borderLine = BoarderEnum.error;
      }
    }else{
      borderLine = BoarderEnum.unFocus;
      if(errorTxt.isNotEmpty){
        borderLine = BoarderEnum.error;
      }
    }

    if(prefillText != widget.preFillDate){
      if(widget.preFillDate !=null ){
        _addPreFillDate();
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              if (widget.onTapCallBack != null) {
                widget.onTapCallBack!();
              }
              if(c1.text.length < 2){
                f1.requestFocus();
              }else if(c2.text.length < 2){
                f2.requestFocus();
              }else {
                f3.requestFocus();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getInputField('DD',context,c1,f1),
                      Text('/',style: _getSlashStyle(isHint1,context)),
                      _getInputField('MM',context,c2,f2),
                      Text('/',style: _getSlashStyle(isHint2,context),),
                      _getInputField('YYYY',context,c3,f3)
                    ],
                  ),
                  const Spacer(),
                  (widget.rightIconSvg != null)
                      ? GestureDetector(
                    onTap: widget.onPressRightIcon,
                    child: Container(
                      padding:const EdgeInsets.symmetric(vertical: 10),
                      child: widget.rightIconSvg,
                    ),
                  )
                      : const Icon(Icons.date_range)
                ],

              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: _getBoarderColor(),
          ),
         if(errorTxt.isNotEmpty)
           Text(errorTxt ,style: TextStyle(color: Theme.of(context).colorScheme.error ),)
        ],
      ),
    );
  }
}





