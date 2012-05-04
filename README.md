# Exemplos usando MiniTest

Nesse mini-tutorial pretendo mostrar a criação de uma aplicação com MiniTest, sem Rails, igual ao código feito no [Coding Dojo](https://github.com/gurusorocaba/dojos/tree/master/celular). Para cada passo eu criei uma pasta com o código funcionando até aquele ponto. Em caso de dúvidas ou sugestões crie uma [issue](https://github.com/tiagogodinho/mini_test_exemplos/issues) aqui no GitHub que eu responderei.

## 1º Passo - Criar a estrutura inicial

Primeiro precisamos instalar a gem:

``` console
gem install minitest
```

Agora vamos criar um arquivo chamado `calculator.rb` com o seguinte conteúdo:

`calculator.rb`

``` ruby
require 'minitest/autorun'

class Calculator
  def self.sum(number_one, number_two)
    number_one + number_two
  end
end

class TestCalculator < MiniTest::Unit::TestCase
  def test_sum_two_numbers
    assert_equal 3, Calculator.sum(1, 2)
  end
end
```

Depois disso podemos salvar o arquivo e executá-lo no terminal:

``` console
ruby calculator.rb
```

Nesse primeiro passo deixamos tudo num arquivo só para simplificar. Se fosse em uma aplicação real, conforme o código fosse crescendo a aplicação ficaria cada vez mais difícil de manter. Então vamos para a próxima etapa.

## 2º Passo - Separar o teste do código a ser testado

Vamos criar um arquivo chamado `test_calculator.rb` e copiar a classe `TestCalculator` para esse arquivo. Os arquivos ficarão assim:

`calculator.rb`

``` ruby
class Calculator
  def self.sum(number_one, number_two)
    number_one + number_two
  end
end
```

`test_calculator.rb`

``` ruby
require 'minitest/autorun'
require './calculator' # Carrega o arquivo calculator.rb

class TestCalculator < MiniTest::Unit::TestCase
  def test_sum_two_numbers
    assert_equal 3, Calculator.sum(1, 2)
  end
end
```

Depois é só salvar o arquivo e executar:

``` console
ruby calculadora.rb
```

Com o teste separado do código a aplicação fica mais limpa e fácil de entender. Mas na maioria dos projeto que trabalhamos não temos somente uma classe. Com dezenas de classes, cada uma com seu arquivo de testes, essa estrutura ficaria um caos. Então vamos separar por pastas.

## 3º Passo - Separando em pastas

Crie uma pasta chamada `lib` e outra chamada `test`. Na `lib` jogue o arquivo `calculator.rb` e na `test` o `test_calculator.rb`. Como o endereço do arquivo `calculator.rb` mudou, precisamos mudar o require também.

`test/test_calculator.rb`

``` ruby
require 'minitest/autorun'
require File.expand_path('../../lib/calculator', __FILE__) # Carrega o arquivo calculator.rb

# ... o resto continua igual
```

Depois é só salvar o arquivo e executar:

``` console
ruby calculator.rb
```

## 4º Passo - Criando uma Rake Task

Rodar os testes para um arquivo é fácil, o problema é quando temos vários deles. A solução é criar uma tarefa que rode todos seus testes com um só comando. Para isso utilizamos a gem **Rake**:

``` console
gem install rake
```

Depois de instalar a gem precisamos criar um arquivo chamado `Rakefile.rb` para configurarmos as tarefas.

`Rakefile.rb`

``` ruby
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/test_*.rb']
end
```

Agora podemos executar os testes com o comando `rake test`:

``` console
rake test
```

## 5º Passo - Rodando os testes automaticamente

Todo vez que você altera um arquivo precisa ir na linha de comando, rodar os testes, esperar o resultado e só aí voltar para o editor de texto e continuar o trabalho. Isso é muito chato e improdutivo. Por isso surgiram diversas gems que fazem esse trabalho ingrato por nós. Nesse exemplo vou usar a gem `guard-minitest`. Se quiser saber mais sobre o **Guard** existe um episódio do [RailsCasts](http://railscasts.com/episodes/264-guard) que explica bem isso.

``` console
gem install guard-minitest
```

Depois de instalar a gem precisamos criar um arquivo chamado `Guardfile` para configurarmos o **Guard**.

`Guardfile`

``` ruby
guard 'minitest' do
  watch(%r|^test/(.*)\/?test_(.*)\.rb|)
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})  { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r|^test/test_helper\.rb|)    { "test" }
end
```

Agora precisamos colocar o **Guard** para rodar:

``` console
guard
```

## 6º Passo - Deixando tudo mais bonito

Obaaaaa. Agora os testes rodam automaticamente quando eu mudo um arquivo. Só que quando eu estou no editor de texto tenho que ficar voltando para o terminal para ver o resultado dos testes. Agora podemos usar os notificadores para nos avisar se os testes passaram ou não. Esse notificadores dependem do sistema operacional. No **Mac OS X** temos o Growl e no **Linux** o Libnotify. Exitem outras gems para notificações na [documentação do Guard](https://github.com/guard/guard).

Para **Mac OS X**:

``` console
gem install guard-minitest
```
Para **Linux**:

``` console
gem install libnotify
```

Agora desligue o **Guard** (Ctrl-C ou Command-C) e reinicie-o:

``` console
guard
```

Agora você será avisado toda vez que seus testes executarem :)

Outra coisa que você pode fazer para facilitar a visualização dos testes é colorir o resultado. A gem `turn` faz esse serviço muito bem:

``` console
gem install turn
```

Só precisamos nosso código carregar a gem.

`test/test_calculator.rb`

``` ruby
require 'minitest/autorun'
require 'turn' # Carrega o turn
require File.expand_path('../../lib/calculator', __FILE__) # Carrega o arquivo calculator.rb

# ... o resto continua igual
```

## 7º Passo - Não se repita

Vamos supor que daqui a uns dias você tenha 20 classes e 20 arquivos de teste. No topo de cada arquivo de testes você faz o require do minitest, do turn e da classe que será testada. Se algum dia você precisar mudar alguma coisa, terá que sair caçando no código e alterando. Seria muito mais fácil se esse código repetido estivesse em um só lugar.

Vamos criar um arquivo na pasta `test` chamado `test_helper.rb` e copiar esses requires pra lá.

`test/test_helper.rb`

``` ruby
require 'minitest/autorun'
require 'turn' # Carrega o turn
```

No arquivo `test/test_calculator.rb` fazemos o require do `test_helper`

`test/test_calculator.rb`

``` ruby
require File.expand_path('../test_helper', __FILE__)
require File.expand_path('../../lib/calculator', __FILE__)

# ... o resto continua igual
```

Nesse ponto chegamos bem perto do [código feito no Coding Dojo](https://github.com/gurusorocaba/dojos/tree/master/celular). O Gemfile foi ignorado porque pretendo explicá-lo melhor em outro tutorial.

# Conclusão

Nunca tinha mexido com o MiniTest até o Coding Dojo. Sempre trabalhei com RSpec e poucas vezes mexi com TestUnit, embora ele seja padrão no Rails e em muitos outros projetos importantes. Gostei muito do MiniTest e se eu precisasse criar uma gem hoje eu usaria ele ao invés do RSpec. O MiniTest tem até uma sintaxe alternativa que é igual a do RSpec.

Acho que ficamos muito mal acostumados com o Rails e esquecemos de como é criar um projeto "crú". Não sei quase nada sobre *require*, *File.expand_path* e afins porque o Rails sempre fez isso por mim.

Espero que gostem desse mini-tutorial.
