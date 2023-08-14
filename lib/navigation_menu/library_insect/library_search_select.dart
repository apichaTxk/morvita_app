import 'package:flutter/material.dart';

import 'package:morvita_app/navigation_menu/library_insect/library_all_list.dart';

class LibrarySearchSelect extends SearchDelegate {
  final List titles;

  LibrarySearchSelect(this.titles) : super(
    searchFieldLabel: "ค้นหาหมวดหมู่",
    textInputAction: TextInputAction.search,
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final resultList = query.isEmpty
        ? titles
        : titles.where((title) => title.startsWith(query)).toList();

    return ListView.builder(
      itemCount: resultList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(resultList[index], style: TextStyle(fontFamily: "prompt"),),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? titles
        : titles.where((title) => title.startsWith(query)).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestions[index], style: TextStyle(fontFamily: "prompt"),),
        onTap: () {
          query = suggestions[index];

          // ค้นหา index ที่แท้จริง
          int newIndex = 0;
          for(int i=0;i<titles.length;i++){
            if(suggestions[index] == titles[i]){
              newIndex = i;
              break;
            }
          }

          close(context, null);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Library_all_list(
                  library_name: titles[newIndex],
                  band_show: false,
                )
            ),
          );
        },
      ),
    );
  }
}
