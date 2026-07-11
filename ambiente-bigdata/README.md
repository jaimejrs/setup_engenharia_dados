# Ambiente Big Data — PostgreSQL + Hadoop + Airflow

Ambiente para acompanhar as aulas de engenharia de dados da Digital College.
Em caso de formatação ou troca de máquina, ou não ter participado das aulas de passo a passo,
basta rodar os comandos abaixo para subir o ambiente.

## Estrutura

```text
ambiente-bigdata/
├── docker-compose.yml
├── dags/
│   └── dag_exemplo.py
├── hadoop/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── config/
│       ├── core-site.xml
│       ├── hdfs-site.xml
│       ├── mapred-site.xml
│       └── yarn-site.xml
└── README.md
```

## Pré-requisitos

- Docker Desktop com Docker Compose

## Subir o ambiente

```bash
docker compose up -d
```

A primeira execução constrói a imagem do Hadoop (baixa o Hadoop 3.3.6 e configura
Java/SSH), então pode demorar alguns minutos.

## Acessar os serviços

| Serviço          | URL / Endereço          |
|------------------|--------------------------|
| Airflow          | http://localhost:8080 (usuário: `admin`) |
| Hadoop NameNode  | http://localhost:9870   |
| HDFS RPC         | `hdfs://localhost:8020` |
| YARN             | http://localhost:8088    |
| PostgreSQL       | `localhost:5433` (usuário `airflow`, senha `1234`, banco `airflow`) |

Dentro da rede Docker `bigdata`, os serviços se enxergam pelos nomes `postgres`,
`hadoop` e `airflow` (ex.: `postgresql+psycopg2://airflow:1234@postgres:5432/airflow`
e `hdfs://hadoop:8020`).

Para ver a senha gerada do usuário `admin` do Airflow:

```bash
docker compose exec airflow cat /opt/airflow/logs/simple_auth_manager_passwords.json.generated
```

## Adicionar DAGs

Basta colocar o arquivo `.py` dentro da pasta `dags/` — o Airflow detecta
automaticamente, sem precisar de `docker cp`.

## Verificar status

```bash
docker compose ps
docker compose logs -f hadoop
docker compose logs -f airflow
```


