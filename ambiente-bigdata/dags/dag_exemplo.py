from datetime import datetime

from airflow.sdk import DAG
from airflow.providers.standard.operators.bash import BashOperator

with DAG(
    dag_id="dag_exemplo",
    description="DAG de exemplo para validar o ambiente Airflow",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["exemplo"],
) as dag:
    tarefa_hello = BashOperator(
        task_id="hello_world",
        bash_command="echo 'Ambiente Airflow funcionando!'",
    )
