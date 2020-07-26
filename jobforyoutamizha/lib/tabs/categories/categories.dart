import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/model/category.dart';
import 'package:jobforyoutamizha/service/job_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/tabs/categories/category_result.dart';

class Categories extends StatelessWidget {
  final JobInfoService _jobInfoService = locator<JobInfoService>();
  final List<Color> colors = [
    Colors.red,
    Colors.amber,
    Colors.blueAccent,
    Colors.grey,
    Colors.blue,
    Colors.orangeAccent,
  ];
  final _random = new Random();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
        future: _jobInfoService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var categories = snapshot.data;
            return Container(
              padding: EdgeInsets.all(10),
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(categories.length, (index) {
                  return InkWell(
                    onTap: () => Navigator.of(context).push( MaterialPageRoute(builder: (context)=>CategoryResult(category: categories[index],))),
                    child: Card(
                      color: colors[_random.nextInt(colors.length)].withOpacity(0.5),//Colors.yellow.withOpacity(0.2),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        child: Text(
                          categories[index].displayName,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error Fetching the Categories'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
