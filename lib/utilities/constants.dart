import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kTempTextStyle = GoogleFonts.montserrat(
  fontSize: 70.0,
);

var kCityTextStyle = GoogleFonts.montserrat(
  fontSize: 20.0,
);

var kCityTextStyleB = GoogleFonts.montserrat(
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 60.0,
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
);

const kConditionTextStyle = TextStyle(
  fontSize: 100.0,
);

const KTextFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  icon: Icon(Icons.location_city_rounded, color: Colors.white),
  hintText: 'Enter City Name',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none),
);
