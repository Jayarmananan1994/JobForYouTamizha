

class Category {
    String displayName;
    String tagShorthand;

    Category(this.displayName, this.tagShorthand);
    static Category fromSnapshot(e){
      print(e.toString());
      return Category(e['display-name'], e['tag-short-hand']);
    }
}