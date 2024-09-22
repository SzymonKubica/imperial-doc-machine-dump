from typing import Any, Callable, Tuple, List
import matplotlib.pyplot as plt
import math
from abc import abstractmethod
import sys

from graphing.vary_ruu import vary_ruu_plots
from graphing.vary_ruu_lsq_2d import vary_ruu_lsq_plots_2d
from graphing.vary_ruu_lsq_3d import vary_ruu_lsq_plots_3d
from graphing.vary_cachesize import vary_cachesize_plots
from graphing.vary_cachelinesize import vary_cachelinesize_plots
from graphing.vary_bpred_ruu_lsq_3d import vary_bpred_ruu_lsq_plots_3d
from graphing.vary_fp_alu_count import vary_fp_alu_count_plots
from graphing.vary_issue_decode_width_3d import vary_issue_decode_width
from graphing.gradual_improvement_plots import gradual_improvements_plots

def main():
    #vary_ruu_plots()
    #vary_ruu_lsq_plots_2d()
    #vary_ruu_lsq_plots_3d()
    #vary_cachesize_plots()
    #vary_cachelinesize_plots()
    #vary_bpred_ruu_lsq_plots_3d()
    #vary_fp_alu_count_plots()
    #analyse_power_data()
    #vary_issue_decode_width()
    #analyse_power_data()
    gradual_improvements_plots()

def analyse_power_data():
    file_name = sys.argv[1]
    file = open(file_name, "r")
    data = {}
    for line in file:
        [component, power_used] = line.split(" ")
        data[component] = float(power_used)


    items = list(data.items())
    items.sort(key=lambda x: x[1])
    items.reverse()
    for item in items:
        print(item[0], " ", item[1])

    print("Total energy used: ", sum(list(map(lambda item: item[1], items))))





if __name__ == "__main__":
    main()
