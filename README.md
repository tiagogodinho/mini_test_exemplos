# Exemplos usando MiniTest

Esse pequeno tutorial pretende auxiliar na criação de uma aplicação com MiniTest, sem Rails, nos moldes do código feito no [Coding Dojo](https://github.com/gurusorocaba/dojos/tree/master/celular).

## 1º Passo - Instalar a gem e criar a estrutura inicial

Primeiro precisamos instalar a gem `minitest`:

``` console
gem install minitest
```

Agora crie um arquivo chamado `calculator.rb` com o seguinte conteúdo:

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

Depois é só salvar o arquivo e executar no terminal:

``` console
ruby calculator.rb
```

Nesse primeiro passo deixamos tudo num arquivo para simplificar. Se fosse em uma aplicação real, conforme o código fosse crescendo a aplicação ficaria cada vez mais difícil de manter. Então vamos para a próxima etapa.

## 2º Passo - Separar o teste do código a ser testado

Crie um arquivo chamado `test_calculator.rb` e copie a classe `TestCalculator` para esse arquivo. Os arquivos ficarão assim:

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

`lib/test_calculator.rb`

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

Rodar os testes de um arquivo é fácil, o problema é quando temos muitos arquivos. A solução é criar uma tarefa que rode todos seus testes com um só comando. Para isso utilizamos a gem Rake:

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

Todo vez que você altera um arquivo precisa ir na linha de comando, rodar os testes, esperar o resultado e só aí voltar para o editor de texto e corrigir se for preciso. Isso é muito trabalhoso e improdutivo. Por isso surgiram diversas gems que fazem esse trabalho sujo por nós. Nesse exemplo vou usar a gem `guard-minitest`. Se quiser saber mais sobre o **guard** existe um episódio do [RailsCasts](http://railscasts.com/episodes/264-guard) que explica bem isso.

``` console
gem install guard-minitest
```

Depois de instalar a gem precisamos criar um arquivo chamado `Guardfile` para configurarmos o Guard.

`Guardfile`

``` ruby
guard 'minitest' do
  watch(%r|^test/(.*)\/?test_(.*)\.rb|)
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})  { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r|^test/test_helper\.rb|)    { "test" }
end
```

Agora precisamos colocar o **guard** para rodar nossos testes:

``` console
guard
```

## 6º Passo - Deixando tudo mais bonito

Obaaa. Agora os testes rodam automaticamente. Só que quando eu estou no editor de texto tenho que ficar voltando para o terminal para ver o resultado dos testes. Agora podemos usar os notificadores para nos dizer se os testes passaram ou não. Esse notificadores dependem do sistema operacional. No MacOS X temos o Growl e no Linux o Libnotify que funcionam super bem. Exitem outras gems na [documentação do Guard](https://github.com/guard/guard).

Para MacOS X:

``` console
gem install guard-minitest
```
Para Linux:

``` console
gem install libnotify
```

Agora desligue o Guard (Ctrl-C ou Command-C) e inicie novamente:

``` console
guard
```

Agora você será avisado toda vez que seus testes rodarem :)

Outra coisa que você pode fazer para facilitar a visualização dos testes é colorir o resultado. A gem `turn` faz esse serviço muito bem:

``` console
gem install turn
```

Só precisamos fazer o teste carregar o `turn` agora.

`lib/test_calculator.rb`

``` ruby
require 'minitest/autorun'
require 'turn' # Carrega o turn
require File.expand_path('../../lib/calculator', __FILE__) # Carrega o arquivo calculator.rb

# ... o resto continua igual
```

## 7º Passo - Não se repita

Daqui a uns meses você terá 20 classes e 20 arquivos de teste. No topo de cada arquivo de testes você faz o require do minitest, do turn e da classe que será testada. Se algum dia precisar mudar alguma coisa você terá que sair caçando no código e alterando tudo. Seria muito mais fácil se todo esse código que se repete muito estivesse em um lugar único.

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

Nunca tinha mexido com o MiniTest até o Coding Dojo. Sempre trabalhei com RSpec e poucas vezes mexi com TestUnit, embora ele seja padrão no Rails e em muitos projetos importantes. Gostei muito do MiniTest e se eu precisasse criar uma gem hoje eu usaria ele ao invés do RSpec. O MiniTest tem até uma sintaxe alternativa que é igual a do RSpec.

Acho que ficamos muito mal acostumados com o Rails e esquecemos de como é criar um projeto "crú". Não sei quase nada sobre 'require', File.expand_path, e outros porque o Rails sempre fez isso por mim.

Espero que gostem desse mini-tutorial.
