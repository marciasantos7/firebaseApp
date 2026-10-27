import 'package:flutter_test/flutter_test.dart';

abstract class Pessoa {
  late int _id;
  String nome;

  Pessoa(this.nome);

  int get id => _id;

  set id(int id) {
    if (id > 0) {
      _id = id;
    } else {
      throw ArgumentError('Identificador deve ser positivo.');
    }
  }
}

mixin Ano {
  late int _ano;

  int get ano => _ano;

  set ano(int ano) {
    if (ano > 0) {
      _ano = ano;
    } else {
      throw ArgumentError('Ano deve ser positivo.');
    }
  }
}

class Aluno extends Pessoa with Ano {
  Aluno(super.nome, int ano) {
    this.ano = ano;
  }
}

class Professor extends Pessoa {
  Professor(super.nome);
}

class Disciplina {
  String nome;

  Disciplina(this.nome);
}

class Turma with Ano {
  Disciplina disciplina;
  Professor professor;

  final List<Aluno> _alunos = [];

  Turma(this.disciplina, this.professor, int ano) {
    this.ano = ano;
  }

  void matricular(Aluno aluno) {
    if (aluno.ano == ano) {
      _alunos.add(aluno);
    } else {
      throw ArgumentError('O ano do aluno deve ser igual ao da turma.');
    }
  }
}

class Historico extends Turma {
  final Map<Aluno, List<double>> notas = {};

  Historico(super.disciplina, super.professor, super.ano);

  @override
  void matricular(Aluno aluno) {
    super.matricular(aluno);
    notas[aluno] = [];
  }

  double media(Aluno aluno) {
    final listaNotas = notas[aluno]!;

    if (listaNotas.isEmpty) {
      return 0.0;
    }

    double soma = 0;

    for (double nota in listaNotas) {
      soma += nota;
    }

    return soma / listaNotas.length;
  }
}

void main() {
  test('Testar matrícula de alunos', () {
    Disciplina disciplina1 = Disciplina('Flutter');

    Professor professor1 = Professor('Carlos');
    professor1.id = 10;

    Historico historico1 = Historico(
      disciplina1,
      professor1,
      2023,
    );

    // Cadastrar primeiro aluno sem erros.
    Aluno aluno1 = Aluno('Maria', 2023);
    aluno1.id = 1;

    historico1.matricular(aluno1);

    expect(historico1.media(aluno1), 0.0);
    expect(historico1.professor.nome, 'Carlos');
    expect(historico1.professor.id, 10);

    // Cadastrar segundo aluno com erros.
    Aluno aluno2 = Aluno('Paula', 2022);

    expect(
      () => aluno2.id = 0,
      throwsA(isA<ArgumentError>()),
    );

    expect(
      () => historico1.matricular(aluno2),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('Testar cálculo da média das notas', () {
    Disciplina disciplina = Disciplina('Matemática');
    Professor professor = Professor('Ana');
    Historico historico = Historico(disciplina, professor, 2023);

    Aluno aluno = Aluno('João', 2023);
    aluno.id = 2;

    historico.matricular(aluno);

    historico.notas[aluno]!.addAll([8.0, 6.0, 10.0]);

    expect(historico.media(aluno), 8.0);
  });
}