

START = PaymentNetwork.start
MAX_TIME = 100000

HOST := 127.0.0.1

SECS    := $(shell date +%S)
COOKIE  := $(shell echo $$PPID)

UNIQUE  := ${SECS}_${LOGNAME}
NODE_SUFFIX := ${UNIQUE}@${HOST}

ELIXIR  := elixir --no-halt --cookie ${COOKIE} --name
MIX 	:= -S mix run -e ${START} ${MAX_TIME} ${NODE_SUFFIX}

compile:
	mix compile

clean:
	mix clean
	@rm -f erl_crash.dump

ps:
	@echo ------------------------------------------------------------
	epmd -names

basic: compile
	${ELIXIR} payment_network_${NODE_SUFFIX} ${MIX} basic_mode

