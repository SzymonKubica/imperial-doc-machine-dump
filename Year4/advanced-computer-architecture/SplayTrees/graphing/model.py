from typing import List
from abc import abstractmethod
import matplotlib.pyplot as plt
from graphing.utils import read_csv_contents
import os


class ExperimentData:
    def __init__(
        self,
        D1_cache_size,
        D1_cache_linesize,
        bpred_type,  # Branch predictor type
        ruu_size,  # Size of the register update unit
        lsq_size,  # Size of the load-store queue
        sim_elapsed_time,  # Elapsed time of the simulation
        sim_cycle,  # Number of cycles required to execute the program
        sim_IPC,  # Instructions per clock cycle of the simulation
        sim_exec_BW,  # no idea, something with branches?
        ruu_full,  # Proportion of cycles when RUU was full
        lsq_full,  # Proportion of cycles when load-store queue was full
        avg_sim_slip,  # not sure
        dl1_miss_rate,  # Miss rate for the L1 cache for the data accesses
        ul2_miss_rate,
        total_power_cycle_cc1,  # Estimate of the total energy reported by wattch
    ):
        self.D1_cache_size = D1_cache_size
        self.D1_cache_linesize = D1_cache_linesize
        self.bpred_type = bpred_type
        self.ruu_size = ruu_size
        self.lsq_size = lsq_size
        self.sim_IPC = sim_IPC
        self.sim_elapsed_time = sim_elapsed_time
        self.sim_cycle = sim_cycle
        self.sim_exec_BW = sim_exec_BW
        self.ruu_full = ruu_full
        self.lsq_full = lsq_full
        self.avg_sim_slip = avg_sim_slip
        self.dl1_miss_rate = dl1_miss_rate
        self.ul2_miss_rate = ul2_miss_rate
        self.total_power_cycle_cc1 = total_power_cycle_cc1

    @staticmethod
    def from_csv_row(row):
        return ExperimentData(
            D1_cache_size=int(row[1]),
            D1_cache_linesize=int(row[3]),
            bpred_type=row[5],
            ruu_size=int(row[7]),
            lsq_size=int(row[9]),
            sim_elapsed_time=float(row[11]),
            sim_cycle=float(row[13]),
            sim_IPC=float(row[15]),
            sim_exec_BW=float(row[17]),
            ruu_full=float(row[19]),
            lsq_full=float(row[21]),
            avg_sim_slip=float(row[23]),
            dl1_miss_rate=float(row[25]),
            ul2_miss_rate=float(row[27]),
            total_power_cycle_cc1=float(row[29]),
        )


class VaryIssueDecodeWidthData(ExperimentData):
    def __init__(
        self,
        D1_cache_size,
        D1_cache_linesize,
        bpred_type,  # Branch predictor type
        ruu_size,  # Size of the register update unit
        lsq_size,  # Size of the load-store queue
        sim_elapsed_time,  # Elapsed time of the simulation
        sim_cycle,  # Number of cycles required to execute the program
        sim_IPC,  # Instructions per clock cycle of the simulation
        sim_exec_BW,  # no idea, something with branches?
        ruu_full,  # Proportion of cycles when RUU was full
        lsq_full,  # Proportion of cycles when load-store queue was full
        avg_sim_slip,  # not sure
        dl1_miss_rate,  # Miss rate for the L1 cache for the data accesses
        ul2_miss_rate,
        total_power_cycle_cc1,  # Estimate of the total energy reported by wattch
        issue_width,
        decode_width,
        fp_alu_num,
    ):
        self.D1_cache_size = D1_cache_size
        self.D1_cache_linesize = D1_cache_linesize
        self.bpred_type = bpred_type
        self.ruu_size = ruu_size
        self.lsq_size = lsq_size
        self.sim_IPC = sim_IPC
        self.sim_elapsed_time = sim_elapsed_time
        self.sim_cycle = sim_cycle
        self.sim_exec_BW = sim_exec_BW
        self.ruu_full = ruu_full
        self.lsq_full = lsq_full
        self.avg_sim_slip = avg_sim_slip
        self.dl1_miss_rate = dl1_miss_rate
        self.ul2_miss_rate = ul2_miss_rate
        self.total_power_cycle_cc1 = total_power_cycle_cc1
        self.issue_width = issue_width
        self.decode_width = decode_width
        self.fp_alu_num = fp_alu_num

    @staticmethod
    def from_csv_row(row):
        return VaryIssueDecodeWidthData(
            issue_width=int(row[1]),
            decode_width=int(row[3]),
            fp_alu_num=int(row[5]),
            D1_cache_size=int(row[7]),
            D1_cache_linesize=int(row[9]),
            bpred_type=row[11],
            ruu_size=int(row[13]),
            lsq_size=int(row[15]),
            sim_elapsed_time=float(row[17]),
            sim_cycle=float(row[19]),
            sim_IPC=float(row[21]),
            sim_exec_BW=float(row[23]),
            ruu_full=float(row[25]),
            lsq_full=float(row[27]),
            avg_sim_slip=float(row[29]),
            dl1_miss_rate=float(row[31]),
            ul2_miss_rate=float(row[33]),
            total_power_cycle_cc1=float(row[35]),
        )


class VaryFPAluCountData(ExperimentData):
    def __init__(
        self,
        D1_cache_size,
        D1_cache_linesize,
        bpred_type,  # Branch predictor type
        ruu_size,  # Size of the register update unit
        lsq_size,  # Size of the load-store queue
        sim_elapsed_time,  # Elapsed time of the simulation
        sim_cycle,  # Number of cycles required to execute the program
        sim_IPC,  # Instructions per clock cycle of the simulation
        sim_exec_BW,  # no idea, something with branches?
        ruu_full,  # Proportion of cycles when RUU was full
        lsq_full,  # Proportion of cycles when load-store queue was full
        avg_sim_slip,  # not sure
        dl1_miss_rate,  # Miss rate for the L1 cache for the data accesses
        ul2_miss_rate,
        total_power_cycle_cc1,  # Estimate of the total energy reported by wattch
        fp_alu_count,
    ):
        self.D1_cache_size = D1_cache_size
        self.D1_cache_linesize = D1_cache_linesize
        self.bpred_type = bpred_type
        self.ruu_size = ruu_size
        self.lsq_size = lsq_size
        self.sim_IPC = sim_IPC
        self.sim_elapsed_time = sim_elapsed_time
        self.sim_cycle = sim_cycle
        self.sim_exec_BW = sim_exec_BW
        self.ruu_full = ruu_full
        self.lsq_full = lsq_full
        self.avg_sim_slip = avg_sim_slip
        self.dl1_miss_rate = dl1_miss_rate
        self.ul2_miss_rate = ul2_miss_rate
        self.total_power_cycle_cc1 = total_power_cycle_cc1
        self.fp_alu_count = fp_alu_count

    @staticmethod
    def from_csv_row(row):
        return VaryFPAluCountData(
            fp_alu_count=float(row[1]),
            D1_cache_size=int(row[3]),
            D1_cache_linesize=int(row[5]),
            bpred_type=row[7],
            ruu_size=int(row[9]),
            lsq_size=int(row[11]),
            sim_elapsed_time=float(row[13]),
            sim_cycle=float(row[15]),
            sim_IPC=float(row[17]),
            sim_exec_BW=float(row[19]),
            ruu_full=float(row[21]),
            lsq_full=float(row[23]),
            avg_sim_slip=float(row[25]),
            dl1_miss_rate=float(row[27]),
            ul2_miss_rate=float(row[29]),
            total_power_cycle_cc1=float(row[31]),
        )


class GradualImprovementData(ExperimentData):
    def __init__(
        self,
        ruu_size,
        lsq_size,
        fpalu_count,
        fpmult_count,
        decode_width,
        issue_width,
        commit_width,
        ialu_count,
        dl1_cache_config,
        dl2_cache_config,
        il1_cache_config,
        il2_cache_config,
        bpred_type,
        bpred_ras,
        bpred_btb_size,
        bpred_btb_assoc,
        itlb_sets,
        dtlb_sets,
        itlb_assoc,
        dtlb_assoc,
        sim_elapsed_time,
        sim_cycle,
        sim_IPC,
        sim_exec_BW,
        ruu_full,
        lsq_full,
        avg_sim_slip,
        dl1_miss_rate,
        ul2_miss_rate,
        total_power_cycle_cc1,
    ):
        self.ruu_size = ruu_size
        self.lsq_size = lsq_size
        self.fpalu_count = fpalu_count
        self.fpmult_count = fpmult_count
        self.decode_width = decode_width
        self.issue_width = issue_width
        self.commit_width = commit_width
        self.ialu_count = ialu_count
        self.dl1_cache_config = dl1_cache_config
        self.dl2_cache_config = dl2_cache_config
        self.il1_cache_config = il1_cache_config
        self.il2_cache_config = il2_cache_config
        self.bpred_type = bpred_type
        self.bpred_ras = bpred_ras
        self.bpred_btb_size = bpred_btb_size
        self.bpred_btb_assoc = bpred_btb_assoc
        self.itlb_sets = itlb_sets
        self.dtlb_sets = dtlb_sets
        self.itlb_assoc = itlb_assoc
        self.dtlb_assoc = dtlb_assoc
        self.sim_elapsed_time = sim_elapsed_time
        self.sim_cycle = sim_cycle
        self.sim_IPC = sim_IPC
        self.sim_exec_BW = sim_exec_BW
        self.ruu_full = ruu_full
        self.lsq_full = lsq_full
        self.avg_sim_slip = avg_sim_slip
        self.dl1_miss_rate = dl1_miss_rate
        self.ul2_miss_rate = ul2_miss_rate
        self.total_power_cycle_cc1 = total_power_cycle_cc1

    @staticmethod
    def from_csv_row(row):
        return GradualImprovementData(
            ruu_size=int(row[1]),
            lsq_size=int(row[3]),
            fpalu_count=int(row[5]),
            fpmult_count=int(row[7]),
            decode_width=int(row[9]),
            issue_width=int(row[11]),
            commit_width=int(row[13]),
            ialu_count=int(row[15]),
            dl1_cache_config=row[17],
            dl2_cache_config=row[19],
            il1_cache_config=row[21],
            il2_cache_config=row[23],
            bpred_type=row[25],
            bpred_ras=int(row[27]),
            bpred_btb_size=int(row[29]),
            bpred_btb_assoc=int(row[31]),
            itlb_sets=int(row[33]),
            dtlb_sets=int(row[35]),
            itlb_assoc=int(row[37]),
            dtlb_assoc=int(row[39]),
            sim_elapsed_time=int(row[41]),
            sim_cycle=int(row[43]),
            sim_IPC=float(row[45]),
            sim_exec_BW=float(row[47]),
            ruu_full=float(row[49]),
            lsq_full=float(row[51]),
            avg_sim_slip=float(row[53]),
            dl1_miss_rate=float(row[55]),
            ul2_miss_rate=float(row[57]),
            total_power_cycle_cc1=float(row[59]),
        )


class Experiment:
    DATA_DIRECTORY = "data"
    PLOTS_DIRECTORY = "plots"

    def __init__(self, data_filename: str, plot_filename):
        self.data_filename = data_filename
        self.plot_filename = plot_filename

    @abstractmethod
    def plot_data(self, data: List[ExperimentData]):
        pass

    def extract_data(self, raw_data: List[List[str]]) -> List[ExperimentData]:
        return list(map(lambda row: ExperimentData.from_csv_row(row), raw_data))

    def generate_plot(self):
        data = self.extract_data(
            read_csv_contents(self.DATA_DIRECTORY + "/" + self.data_filename)
        )
        self.plot_data(data)
        plot_destination_file = self.PLOTS_DIRECTORY + "/" + self.plot_filename
        if os.path.isfile(plot_destination_file):
            os.remove(plot_destination_file)
        plt.savefig(plot_destination_file)
        plt.show()
        plt.clf()
