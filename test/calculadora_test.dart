
import 'package:flutter_test/flutter_test.dart';

// Cria um Mapa (Dicionário) global para simular um banco de dados de alunos e suas respectivas notas.

Map<String, List<double>> alunos = {
 'Maria': [8.0, 9.0],
 'Bruna': [7.0, 7.0],
 'Carla': [10.0, 9.0],
};


void main() {
  
  // 1º TESTE: Verifica como adicionar um novo aluno caso ele ainda não exista no mapa.
  test('Adicionar elemento', () {
    
    alunos.putIfAbsent('Elena', () => [9.0, 8.0]);
  
    expect(alunos.containsKey('Elena'), isTrue);
   
    expect(alunos['Elena'], [9.0, 8.0]);
  });

  // 2º TESTE: Verifica como adicionar múltiplos alunos de uma só vez.
  test('Adicionar outro dicionário', () {
    alunos.addAll({
      'Elena': [9.0, 8.0],
      'Luiza': [8.0, 9.0],
    });
    // Valida se ambas as chaves agora existem com sucesso no mapa.
    expect(alunos.containsKey('Elena'), isTrue);
    expect(alunos.containsKey('Luiza'), isTrue);
  });

  // 3º TESTE: Verifica a remoção de um aluno.
  test('Remover elemento', () {
    // 'remove' deleta o registro da aluna 'Bruna' do mapa.
    alunos.remove('Bruna');
    
    // Valida se a chave 'Bruna' realmente deixou de existir no mapa.
    expect(alunos.containsKey('Bruna'), isFalse);
  });

  // 4º TESTE: Verifica como atualizar o valor (as notas) de um aluno existente.
  test('Atualizar elemento', () {
   
    alunos.update('Carla', (value) => [9.0, 8.0]);
    expect(alunos['Carla'], [9.0, 8.0]);
    alunos['Carla'] = [8.0, 9.0];
    expect(alunos['Carla'], [8.0, 9.0]);
  });

  // 5º TESTE: Pratica a leitura e iteração (laço) por dentro do mapa.
  test('Testar percorrer dicionário', () {
    // Valida se a lista de nomes (chaves) bate exatamente com a ordem dos alunos restantes.
    expect(alunos.keys, ['Maria', 'Carla', 'Elena', 'Luiza']);
    
  
    expect(alunos.values, [
      [8.0, 9.0],
      [8.0, 9.0],
      [9.0, 8.0],
      [8.0, 9.0],
    ]);
    
    double soma = 0;
    // 'forEach' passa de aluno em aluno. 'key' é o nome e 'value' é a lista de notas.
    alunos.forEach((key, value) {
      // Este segundo laço (for) entra na lista de notas do aluno atual e soma nota por nota.
      for (double nota in value) {
        soma += nota; // Acumula o valor na variável 'soma'.
      }
    });
    expect(soma, 68.0);
  });

  // 6º TESTE: Calcula a média individual de cada aluno restante.
  test('Calcular médias', () {
    // Cria um novo mapa vazio para guardar o resultado final (Nome: Média).
    Map<String, double> medias = {};
    
    // 'forEach' passa por cada aluno no mapa global para fazer o cálculo individual.
    alunos.forEach((nome, notas) {
      double soma = 0;
      
      // Passa por cada uma das notas daquele aluno específico e as soma.
      for (double nota in notas) {
        soma += nota;
      }
      
      // Divide o total somado pela quantidade de notas (notas.length) para descobrir a média.
      // Em seguida, salva no mapa 'medias' usando o nome do aluno como chave.
      medias[nome] = soma / notas.length;
    });

    // Valida se o mapa final de médias contém os valores corretos calculados (todos resultam em 8.5).
    expect(medias, {'Maria': 8.5, 'Carla': 8.5, 'Elena': 8.5, 'Luiza': 8.5});
  });
}