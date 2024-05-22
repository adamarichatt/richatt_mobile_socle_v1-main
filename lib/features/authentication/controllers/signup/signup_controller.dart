

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController{

  static SignupController get instance => Get.find();

  ///Variables
  final email=TextEditingController();
  final lastName=TextEditingController();
  final username=TextEditingController();
  final firstName=TextEditingController();
  final password=TextEditingController();
  final phoneNumber=TextEditingController();

  GlobalKey<FormState> signupFormKey =GlobalKey<FormState>();
  
  Future<void> signup() async{
    try{

      // loading 
      

    }finally{

  }

  }
  

}