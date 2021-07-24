import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swcap/api/order_book_api.dart';
import 'package:swcap/components/buttons/text_button.dart';
import 'package:swcap/components/dropdown/custom_dropdown.dart';
import 'package:swcap/components/inputs/custom_input.dart';
import 'package:swcap/pages/order_book/order_book.dart';

class AddOrder extends StatefulWidget {
  final userID;
  const AddOrder({Key key, this.userID}) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  bool isLoading = false;
  String _orderCategory = "Equity";
  TextEditingController _scriptName = TextEditingController();
  TextEditingController _tradeDateController = TextEditingController();
  TextEditingController _tradeTimeController = TextEditingController();
  String _tradeType = "Buy";
  TextEditingController _tradeQuantity = TextEditingController();
  TextEditingController _tradePrice = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: EdgeInsets.all(8),
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              CustomInput(
                textEditingController: _scriptName,
                showHint: true,
                hintText: "SBIN",
                showLabel: true,
                labelText: "Script Name",
              ),
              SizedBox(height: 10,),
              CustomInput(
                textEditingController: _tradeDateController,
                showLabel: true,
                showHint: false,
                labelText: "Select Date",
                onTap: () {
                  showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now()
                  ).then((value) {
                    String date = value.year.toString().padLeft(2 , "0") + "-" + value.month.toString().padLeft(2 , "0") +"-" + value.day.toString().padLeft(2 , "0");
                    _tradeDateController.text = date;
                  });
                },
              ),
              SizedBox(height: 10,),
              CustomInput(
                textEditingController: _tradeTimeController,
                showLabel: true,
                showHint: false,
                labelText: "Select Time",
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    String time = value.hour.toString().padLeft(2 , "0") + ":" + value.minute.toString().padLeft(2 , "0");
                    _tradeTimeController.text = time;
                  });
                },
              ),
              CustomDropdown(
                selectedValue: _tradeType,
                hint: "Select Trade Type",
                onChange: (value) {
                  print(value);
                  setState(() {
                    _tradeType = value;
                  });
                },
                dropdownOptions: [
                  DropdownMenuItem(child: Text("Buy") , value: "Buy",),
                  DropdownMenuItem(child: Text("Sell") , value: "Sell",)
                ],
              ),
              CustomInput(
                showLabel: true,
                showHint: false,
                labelText: "Quantity",
                textEditingController: _tradeQuantity,
              ),
              CustomInput(
                showHint: false,
                showLabel: true,
                labelText: "Price",
                textEditingController: _tradePrice,
              ),
              SizedBox(height: 20,),
              CustomTextButton(
                title: "Add",
                isLoading: isLoading,
                onPressed: () async {

                  setState(() {
                    isLoading = !isLoading;
                  });

                  if(_orderCategory.isEmpty || _scriptName.text.isEmpty || _tradeDateController.text.isEmpty || _tradeTimeController.text.isEmpty || _tradeQuantity.text.isEmpty || _tradePrice.text.isEmpty){
                    print("empty");
                  }else{

                    var data = jsonEncode({
                      "order_category" : _orderCategory,
                      "script_name" : _scriptName.text,
                      "order_date" : _tradeDateController.text,
                      "order_time" : _tradeTimeController.text,
                      "buy_sell" : _tradeType,
                      "quantity" : _tradeQuantity.text,
                      "price" : _tradePrice.text,
                      "admin_id" : widget.userID
                    });

                    print(data);

                    final response = await OrderBookApi.createOrderBook(data);

                    if(response.status){

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderBook(),));

                    }else{
                      print("Something went wrong");
                      setState(() {
                        isLoading = !isLoading;
                      });
                    }



                  }

                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
