class Anotacao {
  
  int? id;

  late String titulo;

  late String descricao;

  late String data;

  static const colunaId = "id";
  static const colunaTitulo = "titulo";
  static const colunaDescricao = "descricao";
  static const colunaData = "data";

  Anotacao(this.titulo, this.descricao, this.data);

  Anotacao.fromMap (Map map) {
    
    id = map[colunaId];
    titulo = map[colunaTitulo];
    descricao = map[colunaDescricao];
    data = map[colunaData];
  }

  Map<String, dynamic> toMap (){

    final Map<String, dynamic>  anotacao =  {
      colunaTitulo: titulo,
      colunaDescricao: descricao,
      colunaData: data
    };

    if(id != null) anotacao[colunaId] = id;

    return anotacao;
  }
}
