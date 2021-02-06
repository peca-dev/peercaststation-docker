# peercaststation-docker

## Monoバージョン毎の動作確認表

| mono | 動作 |
|-|-|
| 6.12 | x(本当か??) |
| 6.10 | o |
| 6.8 | o |
| 6.6 | o |

## docker-machine経由でのセットアップ方法

- ruby 2.6 or higher (rubyが読めればコマンドがんばればなんとかなる)
- VirtualBox
  - VBoxManage (cli)
- docker-machine
- docker-compose
- docker

```shell
ruby docker_machine_setup.rb
```

LAN内に居させる為にブリッジの設定をします。
IPがフラフラ変わるとめんどいのでMacアドレスとIPのマッピングをしておくと便利です。
