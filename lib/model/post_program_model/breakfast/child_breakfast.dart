class ChildBreakfast {
  ChildBreakfast({
    this.dataDo,
    this.doNot,
    this.none,
  });

  List<Do>? dataDo;
  List<Do>? doNot;
  List<Do>? none;

  ChildBreakfast.fromJson(Map<String, dynamic> json) {
      dataDo = List<Do>.from(json["do"].map((x) => Do.fromJson(x)));
      doNot = List<Do>.from(json["do not"].map((x) => Do.fromJson(x)));
      none = List<Do>.from(json["none"].map((x) => Do.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
    "do": List<dynamic>.from(dataDo!.map((x) => x.toJson())),
    "do not": List<dynamic>.from(doNot!.map((x) => x.toJson())),
    "none": List<dynamic>.from(none!.map((x) => x.toJson())),
  };
}

class Do {
  Do({
    this.id,
    this.itemId,
    this.name,
  });

  int? id;
  int? itemId;
  String? name;

  factory Do.fromJson(Map<String, dynamic> json) => Do(
    id: json["id"],
    itemId: json["item_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item_id": itemId,
    "name": name,
  };
}