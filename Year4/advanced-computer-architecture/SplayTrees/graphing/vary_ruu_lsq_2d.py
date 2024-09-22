import matplotlib.pyplot as plt
from typing import Callable, List
from graphing.model import ExperimentData, Experiment


class VaryRuuLsq2D(Experiment):
    def __init__(
        self,
        ylabel: str,
        selected_metric: str,
        data_extractor: Callable[[ExperimentData], float],
    ):
        Experiment.__init__(
            self, "vary-ruu-lsq.csv", f"vary-ruu-lsq-2d-{selected_metric}.png"
        )
        self.ylabel = ylabel
        self.xlabel = "LSQ size"
        self.data_extractor = data_extractor

    def plot_data(self, data: List[ExperimentData]):
        ruu_sizes = set(map(lambda datapoint: datapoint.ruu_size, data))

        for ruu_size in ruu_sizes:
            lsq_sizes = list(
                map(
                    lambda item: item.lsq_size,
                    filter(lambda item: item.ruu_size == ruu_size, data),
                )
            )
            values = list(
                map(
                    self.data_extractor,
                    filter(lambda item: item.ruu_size == ruu_size, data),
                )
            )

            plt.plot(
                lsq_sizes,
                values,
                label=f"{self.ylabel} for RUU of size " + str(ruu_size),
            )
            plt.xticks(lsq_sizes, labels=list(map(str, lsq_sizes)))

        plt.xscale("log", base=2)
        plt.ylabel(self.ylabel)
        plt.xlabel(self.xlabel)
        plt.legend()


def vary_ruu_lsq_plots_2d():
    VaryRuuLsq2D(
        "Energy Estimate (nJ)", "energy", lambda x: x.total_power_cycle_cc1
    ).generate_plot()

    VaryRuuLsq2D(
        "Simulation Elapsed Time (s)", "elapsed-time", lambda x: x.sim_elapsed_time
    ).generate_plot()

    VaryRuuLsq2D(
        "Total number of cycles", "cycles", lambda x: x.sim_cycle
    ).generate_plot()

    VaryRuuLsq2D("IPC", "ipc", lambda x: x.sim_IPC).generate_plot()
