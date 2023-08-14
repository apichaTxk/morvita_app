class Ipoint_model{
  late String ip_name;
  late String ip_date;
  late String ip_number;
  late String ip_latitude;
  late String ip_longitude;
  late String ip_type;
  late String ip_plant;
  late String ip_detail;
  late String ip_image;
  int? il_id;
  late int u_id;

  Ipoint_model({
    required this.ip_name,
    required this.ip_date,
    required this.ip_number,
    required this.ip_latitude,
    required this.ip_longitude,
    required this.ip_type,
    required this.ip_plant,
    required this.ip_detail,
    required this.ip_image,
    this.il_id,
    required this.u_id,
  });
}