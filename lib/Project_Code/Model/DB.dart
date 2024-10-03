import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

//reteieves data from super base
class RecyclingCentersFetch {
  Future<List<Map<String, dynamic>>> fetchRC() async {
    final response =
        await Supabase.instance.client.from('recyclingcenter').select();//retrieves all data from this table
    return response as List<Map<String, dynamic>>;
  }

  List<Map<String, dynamic>> get Rcenters => _Rcenters;
  List<Map<String, dynamic>> _Rcenters = [];

  //retrieves recycling center data
  Future<void> retrieveData() async {
    try {
      final data = RecyclingCentersFetch();
      final Rcenters = await data.fetchRC();
      _Rcenters = Rcenters;
    } catch (error) {
      print('Error:$error');
    }
  }
}

//returns specific row in table from superbase depending on the material chosen
class MaterialsRecyclingCentersFetch {
  Future<List<Map<String, dynamic>>> fetchRC(String Material) async {
    final response = await Supabase.instance.client
        .from('recyclingcenter')
        .select()
        .like('reccentermaterials', '%$Material%');
    return response;
  }
}
