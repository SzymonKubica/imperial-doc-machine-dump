# Coursework 1 - rough notes

## Varying RUU size between 2 and 256

![IPC for RUU size varied between 2 and 256](./IPC-plot.png)

As predicted in the hypothesis, the IPC increases initially as we increase the
size of the RUU, however beyond 16 we reach a plateau and the IPC no longer
increses.

## Total Energy consumed for RUU size varied between 2 and 256

![Total Energy consumption for RUU size varied between 2 and 256](./energy-consumption-plot.png)

We can observe that the total energy consumption initially decreases, reaches
a minimum at 2^4 and then starts rising again. The likely explanation is that,
initially when we only have 2 slots in the RUU, we cannot really benefit from the
out-of order execution and so the processor will be facing many stalls and we can
see that reflected in the total IPC in that case being less than 1. After we
increase the number of slots in the RUU, the total energy consumption starts to
decrease which can be attributed to the fact that the overall IPC increases and
so the program is able to finish its work faster leading to an overall lower
execution time which leads to a lower total energy consumption. However when we
reach that bottleneck point of 2^4 slots in the RUU, the performance measured in
terms of IPC no longer increases and we are paying the peanalty of using a more
energy-hungry RUU (more slots inside of it mean that the circuit will consume
more energy as it takes time an energy to index into the RUU to find all
instructions waiting for a given tag that corresponds to the instruction that
has just been executed).

## Questions to consider:

Bottleneck:
Q1: What microarchitectural structure is limiting the simulated
execution speed when running this application in the default simulated
architecture?

Q2: Under what circumstances is it the RUU size?
Q3: Under what circumstances is it the LSQ size?

A1: (hypothesis)

## Minimising Total Energy

Task: find the configuration which completes the computation using the minimum
total energy.

Parameters that can be changed:

- cache configuration
- microarchitecture configuration
- delta values

Useful reading: how does wattch calculate the energy consumption

Tips:

- have a look at the sim_cycle, sim_IPC, sim_elapsed_time metrics
- when tuning the search parameters, have a look at ruu_full which tells you
- about the proportion of time (measured in cyclesZ) the when the RUU was full.
- configure the outputs displayed with the tabulate script.

Parameters that can't be changed:

- not allowed to use the the perfect branch predictor
- -issue:wrongpath option must remain true
- -fetch:speed and -fetch:mplat are not architectural decisions
- mem:width and res:memport aren't supposed to be changed.
- spec_update changes when the branch predictor can be updated, but the
  power estimation is buggy > dont' use.

  TODO:

  -> change the plots to have proper dots
  -> rewrite the first exploration sections
  -> refer to varycachesize and vary bpred
