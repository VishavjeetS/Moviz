class KeywordModel {
  int? id;
  List<Keywords>? keywords;

  KeywordModel({this.id, this.keywords});

  KeywordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['keywords'] != null) {
      keywords = <Keywords>[];
      json['keywords'].forEach((v) {
        keywords!.add(Keywords.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (keywords != null) {
      data['keywords'] = keywords!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Keywords {
  int? id;
  String? name;

  Keywords({this.id, this.name});

  Keywords.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
