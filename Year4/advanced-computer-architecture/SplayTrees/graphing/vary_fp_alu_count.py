import matplotlib.pyplot as plt
from typing import Callable, List
from graphing.model import ExperimentData, Experiment, VaryFPAluCountData


class VaryFpAluCount(Experiment):
    def __init__(
        self,
        plot_label: str,
        ylabel: str,
        selected_metric: str,
        data_extractor: Callable[[ExperimentData], float],
    ):
        Experiment.__init__(
            self, "vary-fp-alu-count.csv", f"vary-fp-alu-{selected_metric}.png"
        )
        self.plot_label = plot_label
        self.ylabel = ylabel
        self.xlabel = "Number of FP ALUs"
        self.data_extractor = data_extractor

    def extract_data(self, raw_data: List[List[str]]) -> List[VaryFPAluCountData]:
        return list(map(lambda row: VaryFPAluCountData.from_csv_row(row), raw_data))

    def plot_data(self, data: List[VaryFPAluCountData]):
        alu_counts = list(map(lambda datapoint: datapoint.fp_alu_count, data))
        values = list(map(self.data_extractor, data))

        plt.plot(
            alu_counts,
            values,
            label=self.plot_label,
        )

        plt.legend()
        plt.xlabel(self.xlabel)
        plt.xticks(alu_counts, labels=list(map(str, alu_counts)))
        plt.ylabel(self.ylabel)


def vary_fp_alu_count_plots():
    VaryFpAluCount(
        "IPC for FP ALU Count between 1 and 4",
        "IPC",
        "ipc",
        lambda x: x.sim_IPC,
    ).generate_plot()

    VaryFpAluCount(
        "Energy estimate for FP ALU Count between 1 and 4",
        "Energy Estimate (nJ)",
        "energy",
        lambda x: x.total_power_cycle_cc1,
    ).generate_plot()

