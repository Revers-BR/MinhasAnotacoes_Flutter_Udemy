import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:minhas_anotacoes/helper/anotacao_helper.dart';
import 'package:minhas_anotacoes/model/anotacao.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _anotacaoHelper = AnotacaoHelper();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  List<Anotacao> _listaAnotacao = [];
  
  void _exibirModalCadastro({Anotacao? anotacaoSelecionado}){

    _tituloController.clear();
    _descricaoController.clear();

    String textoAcao = "Salvar";

    if(anotacaoSelecionado != null ){
      _tituloController.text = anotacaoSelecionado.titulo;
      _descricaoController.text = anotacaoSelecionado.descricao;

      textoAcao = "Atualizar";
    }
    
    showDialog(context: context, builder: (BuildContext context) {
      
      return AlertDialog(
        
        title: Text("$textoAcao Anotação"),

        content: Column(
        
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              autofocus: true,
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: "Titulo",
                hintText: "Digite o Titulo"
              ),
            ),
            
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: "Descrição",
                hintText: "Digite uma Descrição"
              ),
            ),
          ],
        ),

        actions: [

          FilledButton(
            onPressed: (){
              _salvarAtualizarAnotacao(anotacaoSelecionado: anotacaoSelecionado);

              Navigator.pop(context);
            },
            style: ButtonStyle(
              
              foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
              backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green)
            ),
            child: Text(textoAcao)
          ),
          
          FilledButton(
            onPressed: () => Navigator.pop(context), 
            style: ButtonStyle(
              
              foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
              backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green)
            ),
            child: const Text("Cancelar")
          ),
        ],
      );
    });
  }

  void _salvarAtualizarAnotacao ( { Anotacao? anotacaoSelecionado }) async {

    if(anotacaoSelecionado == null ){
      
      final anotacao = Anotacao(
        _tituloController.text, 
        _descricaoController.text, 
        DateTime.now().toString()
      );

      await _anotacaoHelper.salvarAnotacao(anotacao);
    }else {
      anotacaoSelecionado.titulo    = _tituloController.text;
      anotacaoSelecionado.descricao = _descricaoController.text;

      await _anotacaoHelper.atualizarAnotacao(anotacaoSelecionado);
    }
     
    _tituloController.clear();
    _descricaoController.clear();

    _recuperarAnotacoes();
  }

  _recuperarAnotacoes () async {
    
    List anotacoesRecuperada = await  _anotacaoHelper.recuperarAnotacoes();
    
    List<Anotacao> listaTemp = [];

    for (var item in anotacoesRecuperada) {

      Anotacao anotacao = Anotacao.fromMap(item);

      listaTemp.add(anotacao);
    }

    setState(() {
      
      _listaAnotacao = listaTemp;
    });

    listaTemp = [];
  }

  String _formatarData( String dataString ){

    initializeDateFormatting("pt_BR");

    final formatador = DateFormat.yMd("pt_BR");

    final dataConvertida = DateTime.parse(dataString);

    final dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  void _removerAnotacao ( int id ) async {
    
    await _anotacaoHelper.removerAnotacao(id);

    _recuperarAnotacoes();
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _recuperarAnotacoes();
    }
 
  @override
  Widget build ( BuildContext context ){
  
    return Scaffold(
      
      appBar: AppBar(

        title: const Text("Minhas Anotações"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),

      body: Column(
        children: [
          Expanded(
          child: ListView.builder(
            itemCount: _listaAnotacao.length,
            itemBuilder: ( BuildContext context, int index ){

              final anotacao = _listaAnotacao[index];

              return Card(
                
                child: ListTile(
                  title: Text(anotacao.titulo),
                  subtitle: Text("${_formatarData(anotacao.data)} - ${anotacao.descricao}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => _exibirModalCadastro(anotacaoSelecionado:anotacao),
                        child: const Padding(
                          padding: EdgeInsets.only(right:16),
                          child: Icon(
                            Icons.edit_note, 
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _removerAnotacao( anotacao.id! ),
                        child: const Padding(
                          padding: EdgeInsets.only(right:0),
                          child: Icon(
                            Icons.remove,
                            color: Colors.red
                          ),
                        ),
                      )
                    ],
                  ) ,
                ),
              );
            }
          )
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(

        onPressed: () => _exibirModalCadastro(),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

