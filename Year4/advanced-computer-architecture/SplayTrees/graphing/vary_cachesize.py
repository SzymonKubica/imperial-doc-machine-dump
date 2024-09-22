import matplotlib.pyplot as plt
from typing import Callable, List
from graphing.model import ExperimentData, Experiment


class VaryCacheSize(Experiment):
    def __init__(
        self,
        plot_label: str,
        ylabel: str,
        selected_metric: str,
        data_extractor: Callable[[ExperimentData], float],
    ):
        Experiment.__init__(
            self, "vary-cachesize.csv", f"vary-cachesize-{selected_metric}.png"
        )
        self.plot_label = plot_label
        self.ylabel = ylabel
        self.xlabel = "Cache size"
        self.data_extractor = data_extractor

    def plot_data(self, data: List[ExperimentData]):
        cache_sizes = list(map(lambda datapoint: datapoint.D1_cache_size, data))
        values = list(map(self.data_extractor, data))

        plt.plot(
            cache_sizes,
            values,
            label=self.plot_label,
        )

        plt.legend()
        plt.xlabel(self.xlabel)
        plt.xticks(cache_sizes, labels=list(map(str, cache_sizes)))
        plt.xscale("log", base=2)
        plt.ylabel(self.ylabel)


def vary_cachesize_plots():
    VaryCacheSize(
        "IPC for cache size varied between 256 and 8192",
        "IPC",
        "ipc",
        lambda x: x.sim_IPC,
    ).generate_plot()

    VaryCacheSize(
        "Execution time for cache size varied between 256 and 8192",
        "Execution Time (cycles)",
        "cycles",
        lambda x: x.sim_cycle,
    ).generate_plot()

    VaryCacheSize(
        "Consumed Energy for cache size varied between 256 and 8192",
        "Energy Estimate (nJ)",
        "energy",
        lambda x: x.total_power_cycle_cc1,
    ).generate_plot()

    VaryCacheSize(
        "Simulation time for cache size varied between 256 and 8192",
        "Elapsed Simulation Time (s)",
        "elapsed-time",
        lambda x: x.sim_elapsed_time,
    ).generate_plot()
