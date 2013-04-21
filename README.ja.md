Garnet
======

MeCabの新しいRubyバインディングです。

特徴
----

GarnetはRubyから[MeCab](http://mecab.googlecode.com/)を利用するためのライブラリで、
MeCabから提供されているRubyバインディング[mecab-ruby](https://code.google.com/p/mecab/downloads/list?q=mecab-ruby)
に比べて以下の特徴を備えています。

### RubyGems.orgで提供されている

mecab-rubyもRubyGemsの仕様に則っているのですが、[RubyGems.org](http://rubygems.org)
などで提供されていないため、インストールに少々手間が掛かっていました。

GarnetはRubyGems.orgにて提供されているため、`gem`コマンドでのインストールはもちろん、
[Bundler](http://gembundler.com/)によるインストールも可能です。

### MeCabのバージョンに依存しない

mecab-rubyのC言語のコードは[SWIG](http://www.swig.org/)によって生成されているため、
MeCabとmecab-rubyが密接に繋がっており、基本的にMeCabバージョンとmecab-rubyのバージョンを
揃えなくてはいけません。これはBundlerを使用しているが、ローカルマシンとサーバで
MeCabのバージョンが違うときに問題となります。

Garnetはあらゆるバージョンにおいて以下のバージョンのMeCabに対応しています。

* 0.98
* 0.99
* 0.991
* 0.992
* 0.993
* 0.994
* 0.996

### MeCabのバージョンを意識する必要がない

MeCabは0.98以前と0.99以降でマルチスレッド時における使用法が異なっています。
mecab-rubyはMeCabの薄いラッパであるため、この使用法の差はあなたのRubyのコードに
影響を与えます。

Garnetはその差を埋めているため、特にMeCabのバージョンを意識する必要はなく、
あなたのRubyのコードを変更することもありません。

インストール
------------

あらかじめMeCabをインストールしておく必要があります。

その上であなたのアプリケーションのGemfileに以下の行を追加してください。

    gem 'garnet'

そして以下を実行します。

    $ bundle

または`gem`コマンドによってインストールすることも出来ます。

    $ gem install garnet

使い方
------

    # coding: utf-8
    require 'garnet'

    tagger = Garnet.spawn(:dicdir => '...', ...)

    tagger.parse('太郎はこの本を二郎を見た女性に渡した。') do |node|
      puts node.surface
    end

### Garnet::ParsingContextの取り扱い

`Garnet::Tagger#parse`の戻り値は、`Garnet::ParsingContext`です。
`Garnet::Tagger#parse`を呼んだ時点で解析は行われておらず、すべては
`Garnet::ParsingContext`を準備するための動作です。
`Garnet::ParsingContext`の各種メソッドを用いて解析の挙動を変更することが出来ます。

    parsing_context = tagger.parse(text)
    parsing_context.request_type = :all_morphs

`Garnet::ParsingContext`の設定は`Garnet::Tagger#parse`のオプションとして与えることも
出来ます。

    parsing_context = tagger.parse(text, :request_type => :nbest)

`Garnet::ParsingContext#each`または`Garnet::ParsingContext#to_s`を呼んだ時点で
実際の解析が行われ、結果を受け取ることが出来ます。呼ぶ度に解析が行われますので、
何度も呼ぶ場合は気を付けてください。

    parsing_context.each do |node|
      puts node.surface
    end

    puts parsing_context

### マルチスレッドでの利用

スレッドを用いて並行に解析を行う場合は`Garnet.provide_for`と`Garnet#spawn`を用います。
`Garnet::Tagger`のインスタンスは必ずスレッド毎に用意するようにしてください。

    garnet = Garnet.provide_for(options)

    t1 = Thread.start do
      tagger = garnet.spawn
      # ...
    end

    t2 = Thread.start do
      tagger = garnet.spawn
      # ...
    end
