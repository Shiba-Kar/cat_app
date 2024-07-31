class Data {
  List<Cat>? cats;
  List<Tier>? tiers;
  String? currentTier;
  int? tierPoints;

  Data({
    this.cats,
    this.tiers,
    this.currentTier,
    this.tierPoints,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cats: json["cats"] == null
            ? []
            : List<Cat>.from(json["cats"]!.map((x) => Cat.fromJson(x))),
        tiers: json["tiers"] == null
            ? []
            : List<Tier>.from(json["tiers"]!.map((x) => Tier.fromJson(x))),
        currentTier: json["currentTier"],
        tierPoints: json["tierPoints"],
      );
}

class Cat {
  String? id;
  String? url;
  int? width;
  int? height;

  Cat({
    this.id,
    this.url,
    this.width,
    this.height,
  });

  factory Cat.fromJson(Map<String, dynamic> json) => Cat(
        id: json["id"],
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );
}

class Tier {
  String? tierName;
  int? minPoint;
  int? maxPoint;
  int? seqNo;
  String? fontColor;
  String? bgColor;
  dynamic widgets;

  Tier({
    this.tierName,
    this.minPoint,
    this.maxPoint,
    this.seqNo,
    this.fontColor,
    this.bgColor,
    this.widgets,
  });

  factory Tier.fromJson(Map<String, dynamic> json) => Tier(
        tierName: json["tierName"],
        minPoint: json["minPoint"],
        maxPoint: json["maxPoint"],
        seqNo: json["seqNo"],
        fontColor: json["fontColor"],
        bgColor: json["bgColor"],
        widgets: json["widgets"],
      );
}
