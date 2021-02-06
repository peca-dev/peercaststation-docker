#!/usr/bin/env ruby
# frozen_string_literal: true

NAME = 'pecast-docker-host'

def ohai(mes)
  puts "==> #{mes}"
end

unless system("docker-machine inspect #{NAME} > /dev/null 2>&1")
  ohai "#{NAME}でdocker-machine作りまーす"
  system "docker-machine create -d virtualbox #{NAME}"
end

def ask?(*mes)
  puts mes if mes.any?
  print '> '
  gets
end

if ask?("ブリッジネットワーク設定しますか?(y/n)") =~ /y/
  ohai 'ブリッジネットワーク設定したいので一旦止めまーす'
  system "docker-machine stop #{NAME}"

  bridgedifs = `VBoxManage list bridgedifs | grep ^Name:`.lines.map(&:chop).map { |e| e.sub(/Name:\s+/, '') }

  def select_bridgedif(bridgedifs)
    n = nil
    loop do
      puts 'ブリッジに使うやつどれ??'
      bridgedifs.each_with_index do |b, i|
        puts "#{i}) #{b}"
      end
      n = ask?.to_i

      res = ask?("#{bridgedifs[n]} でいいですか? (y/n)").chop
      return n if res =~ /y/
    end
    n
  end

  n = select_bridgedif(bridgedifs)

  adapter = bridgedifs[n]
  ohai "アダプター3にBridged: #{adapter}設定します"
  system "VBoxManage modifyvm #{NAME} --nic3 bridged --bridgeadapter3 \"#{adapter}\""
end

res = `VBoxManage showvminfo pecast-docker-host | grep 'NIC 3'`
if res =~ /MAC: (\w+),/
  macaddr = Regexp.last_match(1)
  macaddr = macaddr.each_char.each_slice(2).to_a.map(&:join).join(':')
  puts "MACアドレスは #{macaddr} です"
  puts 'できればルータで固定IP割り当てた方が楽かもしれない'
end

ask?("なんでもいいのでENTER押したら進みます")

ohai 'docker-machine起動しなおします'
system "docker-machine start #{NAME}"
