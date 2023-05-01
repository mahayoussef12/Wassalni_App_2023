import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wassalni/Session_User/UserAdresse.dart';
import 'package:wassalni/Session_User/push_notification_booking.dart';
import '../Singup/LoginHeaderWidget.dart';
import 'Controller.dart';
import 'reservation.dart';


class CompleteForm extends StatefulWidget {
  const CompleteForm({Key? key}) : super(key: key);

  @override
  State<CompleteForm> createState() {
    return _CompleteFormState();
  }
}

class _CompleteFormState extends State<CompleteForm> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _ageHasError = false;
  bool _genderHasError = false;
  bool _thingHasError = false;
  bool _songHasError = false;

  var genderOptions = ['Male', 'Female', 'Other'];
  bool _destinationHasError = false;



  void _onChanged(dynamic val) => debugPrint(val.toString());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Forme')),
      body: Padding(
        padding: const EdgeInsets.all(10),



        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              LoginHeaderWidget(image: 'images/booking.png', title: 'book!', subtitle: 'Now',),
              FormBuilder(
                key: _formKey,
                // enabled: false,
                onChanged: () {
                  _formKey.currentState!.save();
                  debugPrint(_formKey.currentState!.value.toString());
                },
                autovalidateMode: AutovalidateMode.disabled,
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    FormBuilderDateTimePicker(
                      name: 'dateTime',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: DateTime.now(),
                      inputType: InputType.both,
                      decoration: InputDecoration(
                        labelText: 'Appointment Time',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () {
                            final formValue= _formKey.currentState!.value;
                          },
                        ),
                      ),
                      initialTime: const TimeOfDay(hour: 8, minute: 0),
                      // locale: const Locale.fromSubtags(languageCode: 'fr'),
                    ),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'age',
                      decoration: InputDecoration(
                        labelText: 'Age',
                        suffixIcon: _ageHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _ageHasError = !(_formKey.currentState?.fields['age']
                              ?.validate() ??
                              false);

                        });

                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(70),
                      ]),
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'Things',
                      decoration: InputDecoration(
                        labelText: 'Enter Number of things you take ',
                        suffixIcon: _thingHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.cases_outlined, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _thingHasError = !(_formKey.currentState?.fields['Things']
                              ?.validate() ??
                              false);});},
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(70),
                      ]),
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'Song',
                      decoration: InputDecoration(
                        labelText: 'Enter  name of  favorite song  ',
                        suffixIcon: _songHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.music_note, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _songHasError = !(_formKey.currentState?.fields['Song']
                              ?.validate() ?? false);});},
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(),]),
                      // initialValue: '12',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(width: 20),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'Destination',
                      decoration: InputDecoration(
                        labelText: 'Enter Destination ',
                        suffixIcon: _destinationHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.music_note, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _destinationHasError = !(_formKey.currentState?.fields['destination']
                              ?.validate() ?? false);});},
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(),]),
                      // initialValue: '12',
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(width: 20),

                    FormBuilderDropdown<String>(
                      // autovalidate: true,
                      name: 'gender',
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        suffix: _genderHasError
                            ? const Icon(Icons.error)
                            : const Icon(Icons.check),
                        hintText: 'Select Gender',
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: genderOptions
                          .map((gender) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: gender,
                        child: Text(gender),
                      ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _genderHasError = !(_formKey
                              .currentState?.fields['gender']?.validate() ?? false);});},
                      valueTransformer: (val) => val?.toString(),
                    ),

                  ],
                ),
              ),
              const SizedBox(width: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if ( _formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());
                          final firstore  = FirebaseFirestore.instance;
                          final prefs = await SharedPreferences.getInstance();

                          final  formValue = _formKey.currentState!.value;
                          final dateTime = formValue['dateTime'] as DateTime;
                          final age = formValue['age'] ;
                          final Song = formValue['Song'] ;
                          final Things = formValue['Things'];
                          final gender = formValue['gender'];
                          final destination=formValue['destination'];
                          //var i=0;
                          firstore.collection('bookings').add({
                            'dateTime':dateTime,
                            'age':age,
                            'Song':Song,
                            'destination':destination,
                            'Things':Things,
                            'gender':gender,
                            'idDriver': prefs.getString('idDriver'),
                            'acceptation':false,
                           // 'id': i++,
                            'idUser': FirebaseAuth.instance.currentUser!.uid,
                           // 'idUser':FirebaseAuth.instance.currentUser!.uid
                            }).then((DocumentReference doc) =>
                              prefs.setString("iddoc", doc.id)

                          );
                          try {
                            // Show a success message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Data saved successfully'))
                            );
                            Push.sendPushNotification();

                            /*AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Reservation ',
                                desc: 'reservation done',
                                btnCancelOnPress: () {},
                        btnOkOnPress: () {
                                  Get.to(Reservation());
                                  prefs.setInt("iddoc", i);
                        },
                        ).show();*/

                          } catch (error) {
                            // Show an error message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $error')),
                            );
                          }
                        } else {
                          debugPrint(_formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },
                      child: const Text(
                        'Valide',
                        style: TextStyle(color: Colors.white ,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      // color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }

}

