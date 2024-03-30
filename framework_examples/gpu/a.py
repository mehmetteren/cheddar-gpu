
from dataclasses import dataclass
import random


@dataclass
class Task:
    name: str
    dag_id: int
    index: int
    period: int
    deadline: int
    capacity: int
    priority: int
    cpu: str


@dataclass
class DAG:
    id: int
    size: int
    stream: int


def gpu_generator(DAGs: list[DAG], stream_to_tpc: list[str]):
    tpc_count = len(set(stream_to_tpc))

    # generate <tpc_count> tpcs here

    # dont do anything here for now

    tasks = []
    for dag in DAGs:
        priority = dag.stream
        tpc = stream_to_tpc[dag.stream]
        for i in range(dag.size):
            tasks.append(Task(f"DAG{dag.id}-{i}", dag.id, i, random.uniform(
                0, 10), random.uniform(0, 100), random.uniform(0, 10), priority, tpc))
    return tasks


DAGs = [DAG(0, 3, stream=0), 
        DAG(1, 4, stream=1), DAG(2, 1, stream=1), 
        DAG(3, 2, stream=2)]

stream_to_tpc = ['tpc0', 'tpc0', 'tpc1']

tasks = gpu_generator(DAGs, stream_to_tpc)

for task in tasks:
    print(task)
