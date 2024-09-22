
# distributed algorithms, n.dulay, 3 jan 23
# Makefile, v1

PEERS    = 10
START    = Flooding.start
MAX_TIME = 10000

HOST	:= 127.0.0.1

# --------------------------------------------------------------------

TIME    := $(shell date +%H:%M:%S)
SECS    := $(shell date +%S)
COOKIE  := $(shell echo $$PPID)

NODE_SUFFIX := ${SECS}_${LOGNAME}@${HOST}

ELIXIR  := elixir --no-halt --cookie ${COOKIE} --name
MIX 	:= -S mix run -e ${START} ${MAX_TIME} ${NODE_SUFFIX} ${PEERS}

# --------------------------------------------------------------------

run cluster: compile
	@ ${ELIXIR} peer0_${NODE_SUFFIX} ${MIX} cluster_wait &
	@ ${ELIXIR} peer1_${NODE_SUFFIX} ${MIX} cluster_wait &
	@ ${ELIXIR} peer2_${NODE_SUFFIX} ${MIX} cluster_wait &
	@ ${ELIXIR} peer3_${NODE_SUFFIX} ${MIX} cluster_wait &
	@ ${ELIXIR} peer4_${NODE_SUFFIX} ${MIX} cluster_wait &
	@ ${ELIXIR} peer5_${NODE_SUFFIX} ${MIX} cluster_wait &
	@ ${ELIXIR} peer6_${NODE_SUFFIX} ${MIX} cluster_wait &
	@ ${ELIXIR} peer7_${NODE_SUFFIX} ${MIX} cluster_wait &
	@ ${ELIXIR} peer8_${NODE_SUFFIX} ${MIX} cluster_wait &
	@ ${ELIXIR} peer9_${NODE_SUFFIX} ${MIX} cluster_wait &
	@sleep 3
	@ ${ELIXIR} flooding_${NODE_SUFFIX} ${MIX} cluster_start

compile:
	mix compile

clean:
	mix clean
	@rm -f erl_crash.dump

ps:
	@echo ------------------------------------------------------------
	epmd -names

