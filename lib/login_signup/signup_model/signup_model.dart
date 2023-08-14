class Signup_Model{
  int u_id;
  String email;
  String password;
  String name;
  String lastname;
  String favorite;
  String image;

  Signup_Model(
      {required this.u_id,
        required this.email,
        required this.password,
        required this.name,
        required this.lastname,
        required this.favorite,
        required this.image});
}