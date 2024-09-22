import matplotlib.pyplot as plt
from typing import Callable, List
from graphing.model import ExperimentData, Experiment, GradualImprovementData


class GradualImprovement(Experiment):
    def __init__(
        self,
        plot_label: str,
        ylabel: str,
        selected_metric: str,
        data_extractor: Callable[[ExperimentData], float],
    ):
        Experiment.__init__(
            self,
            "gradual-improvements.csv",
            f"gradual-improvements-{selected_metric}.png",
        )
        self.plot_label = plot_label
        self.ylabel = ylabel
        self.xlabel = "Subsequent optimizations"
        self.data_extractor = data_extractor

    def extract_data(self, raw_data: List[List[str]]) -> List[GradualImprovementData]:
        return list(map(lambda row: GradualImprovementData.from_csv_row(row), raw_data))

    def plot_data(self, data: List[ExperimentData]):
        fig, ax1 = plt.subplots()
        ipc = list(map(lambda x: x.sim_IPC, data))
        energies = list(map(lambda x: x.total_power_cycle_cc1, data))
        xlabels = [
            "Default",
            "RUU & LSQ",
            "FP ALU / Mult",
            "BPred",
            "Caches",
            "Issue/Decode/Commit",
            "I ALU",
            "D/I TLB",
        ]

        ln1 = ax1.plot(
            range(8), ipc, label="IPC for subsequent optimizations", color="red"
        )
        ax1.set_ylabel("IPC", color="red")
        ax1.scatter(range(8), ipc, color="red")

        ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis

        ln2 = ax2.plot(
            range(8),
            energies,
            color="green",
            label="Energy estimate for subsequent optimizations",
        )
        ax2.set_ylabel("Energy Estimate (1x10^8 nJ)", color="green")

        ax2.scatter(
            range(8),
            energies,
            color="green",
        )

        lns = ln1 + ln2
        labs = [l.get_label() for l in lns]
        ax1.legend(lns, labs, loc=0)

        xlabels = [
            "Default",
            "RUU & LSQ",
            "FP ALU / Mult",
            "BPred",
            "Caches",
            "Issue/Decode/Commit",
            "I ALU",
            "D/I TLB",
        ]

        plt.xticks(range(8), labels=xlabels)


def gradual_improvements_plots():
    GradualImprovement(
        "test",
        "IPC",
        "ipc",
        lambda x: x.sim_IPC,
    ).generate_plot()
