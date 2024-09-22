import matplotlib.pyplot as plt
from typing import Callable, List
from graphing.model import ExperimentData, Experiment, VaryIssueDecodeWidthData
import math


class VaryIssueDecodeWidth3D(Experiment):
    def __init__(
        self,
        plot_label: str,
        zlabel: str,
        selected_metric: str,
        data_extractor: Callable[[ExperimentData], float],
    ):

        Experiment.__init__(
            self, "vary-issue-decode-width.csv", f"vary-issue-decode-width-{selected_metric}.png"
        )
        self.label = plot_label
        self.xlabel = "Issue width (instructions/cycle)"
        self.ylabel = "Decode width (instructions/cycle)"
        self.zlabel = zlabel
        self.data_extractor = data_extractor

    def extract_data(self, raw_data: List[List[str]]) -> List[VaryIssueDecodeWidthData]:
        return list(map(lambda row: VaryIssueDecodeWidthData.from_csv_row(row), raw_data))

    def plot_data(self, data: List[VaryIssueDecodeWidthData]):
        ax = plt.axes(projection="3d")

        issue_widths = list(map(lambda x: x.issue_width, data))
        decode_widths = list(map(lambda x: x.decode_width, data))
        values = list(map(self.data_extractor, data))

        log_scaled_issue_widths = list(map(lambda x: math.log2(x), issue_widths))
        log_scaled_decode_widths = list(map(lambda x: math.log2(x), decode_widths))

        ax.plot_trisurf(
            log_scaled_issue_widths,
            log_scaled_decode_widths,
            values,
        )

        ax.scatter(
            log_scaled_issue_widths,
            log_scaled_decode_widths,
            values,
            label=self.label,
            color="red",
        )

        # Here we plot the minimum value
        min_value = min(values)
        print("Minimum: ", min_value )
        min_datapoint = list(filter(lambda x: self.data_extractor(x) == min_value, data))[0]
        ax.scatter(
            [math.log2(min_datapoint.issue_width)],
            [math.log2(min_datapoint.decode_width)],
            min_value,
            label="Minimum energy estimate value.",
            color="yellow",
            s=100,
        )


        ax.legend()
        ax.set_zlabel(self.zlabel)
        plt.xlabel(self.xlabel)
        plt.ylabel(self.ylabel)
        plt.xticks(log_scaled_issue_widths, labels=list(map(str, issue_widths)))
        plt.yticks(log_scaled_decode_widths, labels=list(map(str, decode_widths)))


def vary_issue_decode_width():
    VaryIssueDecodeWidth3D(
        "Energy consumption for varying RUU and LSQ sizes.",
        "Energy Estimate (nJ)",
        "energy",
        lambda x: x.total_power_cycle_cc1,
    ).generate_plot()

    VaryIssueDecodeWidth3D(
        "Execution time for varying RUU and LSQ sizes.",
        "Execution Time (s)",
        "execution-time",
        lambda x: x.sim_elapsed_time,
    ).generate_plot()

    VaryIssueDecodeWidth3D(
        "IPC for varying RUU and LSQ sizes.",
        "IPC",
        "ipc",
        lambda x: x.sim_IPC,
    ).generate_plot()

    VaryIssueDecodeWidth3D(
        "Fraction of clock cycles when RUU is full for varying RUU and LSQ sizes.",
        "RUU full (% clock cycles)",
        "ruu-full",
        lambda x: x.ruu_full,
    ).generate_plot()

    VaryIssueDecodeWidth3D(
        "Fraction of clock cycles when LSQ is full for varying RUU and LSQ sizes.",
        "LSQ full (% clock cycles)",
        "lsq-full",
        lambda x: x.lsq_full,
    ).generate_plot()

    VaryIssueDecodeWidth3D(
        "Total cycles for varying RUU and LSQ sizes.",
        "Total number of cycles",
        "cycles",
        lambda x: x.sim_cycle,
    ).generate_plot()
