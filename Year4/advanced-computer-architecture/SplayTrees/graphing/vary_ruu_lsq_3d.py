import matplotlib.pyplot as plt
from typing import Callable, List
from graphing.model import ExperimentData, Experiment
import math


class VaryRuuLsq3D(Experiment):
    def __init__(
        self,
        plot_label: str,
        zlabel: str,
        selected_metric: str,
        data_extractor: Callable[[ExperimentData], float],
    ):
        Experiment.__init__(
            self, "vary-ruu-lsq.csv", f"vary-ruu-lsq-3d-{selected_metric}.png"
        )
        self.label = plot_label
        self.xlabel = "RUU size"
        self.ylabel = "LSQ size"
        self.zlabel = zlabel
        self.data_extractor = data_extractor

    def plot_data(self, data: List[ExperimentData]):
        ax = plt.axes(projection="3d")

        ruu_sizes = list(map(lambda datapoint: datapoint.ruu_size, data))
        lsq_sizes = list(map(lambda item: item.lsq_size, data))
        values = list(map(self.data_extractor, data))

        log_scaled_ruu_sizes = list(map(lambda x: math.log2(x), ruu_sizes))
        log_scaled_lsq_sizes = list(map(lambda x: math.log2(x), lsq_sizes))

        ax.plot_trisurf(
            log_scaled_ruu_sizes,
            log_scaled_lsq_sizes,
            values,
            alpha=0.75,
        )

        ax.scatter(
            log_scaled_ruu_sizes,
            log_scaled_lsq_sizes,
            values,
            label=self.label,
            color="red",
        )


        # Here we plot the minimum value
        min_value = min(values)
        print("Minimum: ", min_value )
        min_datapoint = list(filter(lambda x: self.data_extractor(x) == min_value, data))[0]
        ax.scatter(
            [math.log2(min_datapoint.ruu_size)],
            [math.log2(min_datapoint.lsq_size)],
            min_value,
            label="Minimum",
            color="black",
            s=120,
        )

        # Here we indicate the default simulator settings. (RUU - 16, LSQ - 8)
        value_at_default = list(
            map(
                self.data_extractor,
                filter(lambda item: item.ruu_size == 16 and item.lsq_size == 8, data),
            )
        )
        print(value_at_default)

        # 4, 3 corresponds to 16, 8 after log scaling
        ax.scatter(
            [4],
            [3],
            value_at_default,
            label="Default architecture",
            color="cyan",
            s=100,
        )

        ax.legend()
        ax.set_zlabel(self.zlabel)
        plt.xlabel(self.xlabel)
        plt.ylabel(self.ylabel)
        plt.xticks(log_scaled_ruu_sizes, labels=list(map(str, ruu_sizes)))
        plt.yticks(log_scaled_lsq_sizes, labels=list(map(str, lsq_sizes)))


def vary_ruu_lsq_plots_3d():
    VaryRuuLsq3D(
        "Energy consumption for varying RUU and LSQ sizes.",
        "Energy Estimate (nJ)",
        "energy",
        lambda x: x.total_power_cycle_cc1,
    ).generate_plot()

    VaryRuuLsq3D(
        "Execution time for varying RUU and LSQ sizes.",
        "Execution Time (s)",
        "execution-time",
        lambda x: x.sim_elapsed_time,
    ).generate_plot()

    VaryRuuLsq3D(
        "IPC for varying RUU and LSQ sizes.",
        "IPC",
        "ipc",
        lambda x: x.sim_IPC,
    ).generate_plot()

    VaryRuuLsq3D(
        "Fraction of clock cycles when RUU is full for varying RUU and LSQ sizes.",
        "RUU full (% clock cycles)",
        "ruu-full",
        lambda x: x.ruu_full,
    ).generate_plot()

    VaryRuuLsq3D(
        "Fraction of clock cycles when LSQ is full for varying RUU and LSQ sizes.",
        "LSQ full (% clock cycles)",
        "lsq-full",
        lambda x: x.lsq_full,
    ).generate_plot()

    VaryRuuLsq3D(
        "Total cycles for varying RUU and LSQ sizes.",
        "Total number of cycles",
        "cycles",
        lambda x: x.sim_cycle,
    ).generate_plot()
