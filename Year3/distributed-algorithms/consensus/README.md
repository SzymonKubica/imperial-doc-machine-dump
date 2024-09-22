# MultiPaxos


## Running configurations for experiments

I have defined a set of configurations which are thoroughly described in the
lib/configuration.ex file. The way I was running them was to invoke

```
make run PARAMS=<configuration name>

```

The list of available configurations can be seen below

debug

no_liveness_short

no_liveness_medium

partial_liveness_medium

partial_liveness_long

crash2

partial_liveness_crash2

full_liveness

full_liveness_stress

full_liveness_bad_settings

simplified_liveness

crash2_liveness

Please refer to the configuration flie for more in-depth description.
