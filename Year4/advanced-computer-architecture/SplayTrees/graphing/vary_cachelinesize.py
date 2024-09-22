import matplotlib.pyplot as plt
from typing import Callable, List
from graphing.model import ExperimentData, Experiment


class VaryCacheLineSize(Experiment):
    def __init__(
        self,
        plot_label: str,
        ylabel: str,
        selected_metric: str,
        data_extractor: Callable[[ExperimentData], float],
    ):
        Experiment.__init__(
            self, "vary-cachelinesize.csv", f"vary-cachelinesize-{selected_metric}.png"
        )
        self.plot_label = plot_label
        self.ylabel = ylabel
        self.xlabel = "Cache line size"
        self.data_extractor = data_extractor

    def plot_data(self, data: List[ExperimentData]):
        cacheline_sizes = list(map(lambda datapoint: datapoint.D1_cache_linesize, data))
        values = list(map(self.data_extractor, data))

        plt.plot(
            cacheline_sizes,
            values,
            label=self.plot_label,
        )

        plt.legend()
        plt.xlabel(self.xlabel)
        plt.xticks(cacheline_sizes, labels=list(map(str, cacheline_sizes)))
        plt.xscale("log", base=2)
        plt.ylabel(self.ylabel)


def vary_cachelinesize_plots():
    VaryCacheLineSize(
        "IPC for cache line size varied between 16 and 64",
        "IPC",
        "ipc",
        lambda x: x.sim_IPC,
    ).generate_plot()

    VaryCacheLineSize(
        "Execution time for cache line size varied between 16 and 64",
        "Execution Time (cycles)",
        "cycles",
        lambda x: x.sim_cycle,
    ).generate_plot()

    VaryCacheLineSize(
        "Consumed Energy for cache line size varied between 16 and 64",
        "Energy Estimate (nJ)",
        "energy",
        lambda x: x.total_power_cycle_cc1,
    ).generate_plot()

    VaryCacheLineSize(
        "Simulation time for cache line size varied between 16 and 64",
        "Elapsed Simulation Time (s)",
        "elapsed-time",
        lambda x: x.sim_elapsed_time,
    ).generate_plot()
