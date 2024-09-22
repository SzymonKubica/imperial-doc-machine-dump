import matplotlib.pyplot as plt
from typing import Callable, List
from graphing.model import ExperimentData, Experiment
import math


class VaryBpredRuuLsq3d(Experiment):
    def __init__(
        self,
        plot_label: str,
        zlabel: str,
        selected_metric: str,
        data_extractor: Callable[[ExperimentData], float],
    ):
        Experiment.__init__(
            self,
            "vary-ruu-lsq-bpred-huge.csv",
            f"vary-bpred-ruu-lsq-3d-{selected_metric}.png",
        )
        self.label = plot_label
        self.xlabel = "RUU size"
        self.ylabel = "LSQ size"
        self.zlabel = zlabel
        self.data_extractor = data_extractor

    def plot_data(self, data: List[ExperimentData]):
        ax = plt.axes(projection="3d")

        tested_branch_predictors = set(map(lambda test: test.bpred_type, data))

        for bpred in tested_branch_predictors:
            data_for_bpred = list(filter(lambda item: item.bpred_type == bpred, data))
            ruu_sizes = list(map(lambda datapoint: datapoint.ruu_size, data_for_bpred))
            lsq_sizes = list(map(lambda item: item.lsq_size, data_for_bpred))
            values = list(map(self.data_extractor, data_for_bpred))

            log_scaled_ruu_sizes = list(map(lambda x: math.log2(x), ruu_sizes))
            log_scaled_lsq_sizes = list(map(lambda x: math.log2(x), lsq_sizes))

            ax.plot_trisurf(
                log_scaled_ruu_sizes,
                log_scaled_lsq_sizes,
                values,
                label=f"Branch predictor: {bpred} - " + self.label,
            )
            plt.xticks(log_scaled_ruu_sizes, labels=list(map(str, ruu_sizes)))
            plt.yticks(log_scaled_lsq_sizes, labels=list(map(str, lsq_sizes)))

        ax.legend()
        ax.set_zlabel(self.zlabel)
        plt.xlabel(self.xlabel)
        plt.ylabel(self.ylabel)


def vary_bpred_ruu_lsq_plots_3d():
    VaryBpredRuuLsq3d(
        "Energy consumption for varying RUU and LSQ sizes.",
        "Energy Estimate (nJ)",
        "energy",
        lambda x: x.total_power_cycle_cc1,
    ).generate_plot()

    VaryBpredRuuLsq3d(
        "Execution time for varying RUU and LSQ sizes.",
        "Execution Time (s)",
        "execution-time",
        lambda x: x.sim_elapsed_time,
    ).generate_plot()

    VaryBpredRuuLsq3d(
        "IPC for varying RUU and LSQ sizes.",
        "IPC",
        "ipc",
        lambda x: x.sim_IPC,
    ).generate_plot()

    VaryBpredRuuLsq3d(
        "Fraction of clock cycles when RUU is full for varying RUU and LSQ sizes.",
        "RUU full (% clock cycles)",
        "ruu-full",
        lambda x: x.ruu_full,
    ).generate_plot()

    VaryBpredRuuLsq3d(
        "Fraction of clock cycles when LSQ is full for varying RUU and LSQ sizes.",
        "LSQ full (% clock cycles)",
        "lsq-full",
        lambda x: x.lsq_full,
    ).generate_plot()

    VaryBpredRuuLsq3d(
        "Total cycles for varying RUU and LSQ sizes.",
        "Total number of cycles",
        "cycles",
        lambda x: x.sim_cycle,
    ).generate_plot()
