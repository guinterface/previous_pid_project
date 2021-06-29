class User{

  String _nome;
  String _senha;
  String _email;
  String _urlImagem;


  User();


  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }

  String get email => _email;



  set email(String value) {
    _email = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }


  Map<String,dynamic>toMap(){

    Map<String,dynamic>map = {
      "nome": this.nome,
      "email": this.email,






    };
    return map;
  }
}
