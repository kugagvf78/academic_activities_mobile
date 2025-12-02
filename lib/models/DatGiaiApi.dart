class DatGiaiApi {
  final String id;
  final String event;
  final String award;
  final String prize;
  final double points;
  final String date;
  final String type;

  DatGiaiApi({
    required this.id,
    required this.event,
    required this.award,
    required this.prize,
    required this.points,
    required this.date,
    required this.type,
  });

  factory DatGiaiApi.fromJson(Map<String, dynamic> j) {
    return DatGiaiApi(
      id: j["id"] ?? "",
      event: j["event"] ?? "",
      award: j["award"] ?? "",
      prize: j["prize"] ?? "",
      points: double.tryParse(j["points"]?.toString() ?? "0") ?? 0,
      date: j["date"] ?? "",
      type: j["type"] ?? "CaNhan",
    );
  }
}
