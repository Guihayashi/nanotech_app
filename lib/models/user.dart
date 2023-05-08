class User {
  final int id;
  final String cpf;
  final String password;
  final String tipo;

  User(this.id, this.cpf, this.password, this.tipo);

  @override
  String toString() {
    return 'User{id: $id, cpf: $cpf, password: $password, tipo: $tipo}';
  }

  Map<String, dynamic> toMap(){
    return {
      'id':id,
      'username':cpf,
      'password':password,
      'tipo':tipo,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['id'],
      map['cpf'],
      map['password'],
      map['tipo'],
    );
  }
}
