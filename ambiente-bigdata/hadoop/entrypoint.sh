#!/usr/bin/env bash
set -e

service ssh start

# Formata o NameNode apenas na primeira execução (evita apagar dados existentes)
if [ ! -f "$HADOOP_HOME/data/nn/current/VERSION" ]; then
  echo "Formatando o NameNode (primeira execução)..."
  hdfs namenode -format -force
fi

start-dfs.sh
start-yarn.sh

echo "Hadoop iniciado."
echo "HDFS NameNode: http://localhost:9870"
echo "YARN: http://localhost:8088"

# Mantém o container rodando
tail -f /dev/null
