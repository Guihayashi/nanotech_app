class Reclamacao {
  final int id;
  final String fullName;
  final String cpf;
  final String endereco;
  final String email;
  final String celular;
  final String telefone;
  final String descricao;
  final String assunto;
  final String dataIncidente;
  final String numPedido;
  final String numRec;
  final String status;
  final List<String> fileNames;

  Reclamacao(
      this.id,
      this.fullName,
      this.cpf,
      this.endereco,
      this.email,
      this.celular,
      this.telefone,
      this.descricao,
      this.assunto,
      this.dataIncidente,
      this.numPedido,
      this.numRec,
      this.status,
      this.fileNames);

  @override
  String toString() {
    return 'Reclamacao{_fullName: $fullName, _cpf: $cpf, _endereco: $endereco, _email: $email, _celular: $celular, _telefone: $telefone, _descricao: $descricao, _dataIncidente: $dataIncidente, _numPedido: $numPedido, _numRec: $numRec, status: $status, _fileNames: $fileNames}';
  }

  factory Reclamacao.fromMap(Map<String, dynamic> reclamacaoMap) {
    return Reclamacao(
        reclamacaoMap['id'],
        reclamacaoMap['fullName'],
        reclamacaoMap['cpf'],
        reclamacaoMap['endereco'],
        reclamacaoMap['email'],
        reclamacaoMap['celular'],
        reclamacaoMap['telefone'],
        reclamacaoMap['assunto'],
        reclamacaoMap['descricao'],
        reclamacaoMap['dataIncidente'],
        reclamacaoMap['numPedido'],
        reclamacaoMap['numReclamacao'],
        reclamacaoMap['status'],
        reclamacaoMap['anexos'],
    );
  }
}
