import matplotlib.pyplot as plt
from typing import Callable, List
from graphing.model import ExperimentData, Experiment


class VaryRuu(Experiment):
    def __init__(
        self,
        plot_label: str,
        ylabel: str,
        selected_metric: str,
        data_extractor: Callable[[ExperimentData], float],
    ):
        Experiment.__init__(self, "vary-ruu.csv", f"vary-ruu-{selected_metric}.png")
        self.plot_label = plot_label
        self.xlabel = "RUU size"
        self.ylabel = ylabel
        self.data_extractor = data_extractor

    def plot_data(self, data: List[ExperimentData]):
        ruu_sizes = list(map(lambda datapoint: datapoint.ruu_size, data))
        values = list(map(self.data_extractor, data))

        plt.plot(
            ruu_sizes,
            values,
        )

        plt.scatter(
            ruu_sizes,
            values,
            label=self.plot_label,
            color="red",
        )

        plt.legend()
        plt.xlabel(self.xlabel)
        plt.xticks(ruu_sizes, labels=list(map(str, ruu_sizes)))
        plt.xscale("log", base=2)
        plt.ylabel(self.ylabel)


def vary_ruu_plots():
    VaryRuu(
        "IPC for RUU size varied between 2 and 256",
        "IPC",
        "ipc",
        lambda x: x.sim_IPC,
    ).generate_plot()

    VaryRuu(
        "Execution time for RUU size varied between 2 and 256",
        "Execution Time (cycles)",
        "cycles",
        lambda x: x.sim_cycle,
    ).generate_plot()

    VaryRuu(
        "Consumed Energy for RUU size varied between 2 and 256",
        "Energy Estimate (nJ)",
        "energy",
        lambda x: x.total_power_cycle_cc1,
    ).generate_plot()

    VaryRuu(
        "Simulation time for RUU size varied between 2 and 256",
        "Elapsed Simulation Time (s)",
        "elapsed-time",
        lambda x: x.sim_elapsed_time,
    ).generate_plot()
