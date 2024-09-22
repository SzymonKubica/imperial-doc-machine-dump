from typing import List
import csv

def read_csv_contents(filename: str) -> List[List[str]]:
    with open(filename) as csvfile:
        reader = csv.reader(csvfile, delimiter=",")
        return list(reader)
