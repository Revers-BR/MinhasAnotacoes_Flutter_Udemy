import 'package:minhas_anotacoes/model/anotacao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class AnotacaoHelper {

  static const nomeTabela = "Anotacao";

  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();

  AnotacaoHelper._internal();

  factory AnotacaoHelper(){
    return _anotacaoHelper;
  }

  late Database _db;

  Future<Database> db  () async {

    _db = await _inicializarDB();

    return _db;
  }

  Future<Database> _inicializarDB () async {

    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;

    final localDB = join("./","anotacao.db");

    final db = await databaseFactory.openDatabase(localDB);

    _onCreate(db);

    return db;
  }

  Future<int> salvarAnotacao ( Anotacao anotacao ) async {
    
    final db = await this.db();

    final resultado = await db.insert(nomeTabela, anotacao.toMap());

    return resultado;
  }
  
  Future<int> atualizarAnotacao ( Anotacao anotacao ) async {
    
    final db = await this.db();

    anotacao.data = DateTime.now().toIso8601String();

    return await db.update(
      nomeTabela, 
      anotacao.toMap(),
      where: "${Anotacao.colunaId} = ?",
      whereArgs: [anotacao.id]
    );
  }
  
  Future<int> removerAnotacao ( int id ) async {
    
    final db = await this.db();

    return await db.delete(
      nomeTabela, 
      where: "${Anotacao.colunaId} = ?",
      whereArgs: [id]
    );
  }

  recuperarAnotacoes() async {
    
    final db = await this.db();

    const sql = "SELECT * FROM $nomeTabela ORDER BY data DESC";

    final List resultado = await db.rawQuery(sql);
    
    return resultado;
  }

  void _onCreate (Database db) async {

    const sql = "CREATE TABLE IF NOT EXISTS $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo NVARCHAR, descricao TEXT, data DATETIME )";
    await db.execute(sql);
  }
}
