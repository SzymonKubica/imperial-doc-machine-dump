import matplotlib.pyplot as plt

NUM_SERVERS = 5
def get_data(file_location):
    file = open(file_location, 'r')
    timestamps = []
    requests_done_per_server = {i : [] for i in range(NUM_SERVERS)}
    for line in file.readlines():
        input = line.split(', ')
        timestamps.append(int(input[0]))
        for i in range(NUM_SERVERS):
            requests_done_per_server[i].append(int(input[i+1]))

    return (timestamps, requests_done_per_server)


timestamps1, requests1 = get_data('requests_done/full_liveness_bad_settings.txt')
timestamps2, requests2 = get_data('requests_done/simplified_liveness.txt')
timestamps3, requests3 = get_data('requests_done/full_liveness_long.txt')
timestamps4, requests4 = get_data('requests_done/no_liveness_short.txt')
timestamps5, requests5 = get_data('requests_done/partial_liveness_short.txt')
timestamps6, requests6 = get_data('requests_done/no_liveness_medium.txt')
timestamps7, requests7 = get_data('requests_done/partial_liveness_medium.txt')

#for i in range(NUM_SERVERS):
#  plt.plot(timestamps1, requests1[i], label = "full_liveness_bad server {}".format(i + 1))
#  plt.plot(timestamps2, requests2[i], label = "simple_liveness server {}".format(i + 1))
#  plt.plot(timestamps3, requests3[i], label = "full_liveness server {}".format(i + 1))

#plt.plot(timestamps1, requests1[0], label = "full_liveness_bad server {}".format(0))
#plt.plot(timestamps2, requests2[0], label = "simple_liveness server {}".format(0))
#plt.plot(timestamps3, requests3[0], label = "full_liveness server {}".format(0))
#plt.plot(timestamps4, requests4[0], label = "no_liveness server {}".format(0))
#plt.plot(timestamps5, requests5[0], label = "partial_liveness server {}".format(0))

#plt.plot(timestamps6, requests6[0], label = "no_liveness server {}".format(0))
#plt.plot(timestamps7, requests7[0], label = "partial_liveness server {}".format(0))
timestamps8, requests8 = get_data('requests_done/crash2.txt')
timestamps9, requests9 = get_data('requests_done/partial_liveness_crash2.txt')

timestamps10, requests10= get_data('requests_done/crash2_liveness.txt')
for i in range(NUM_SERVERS):
  #plt.plot(timestamps8, requests8[i], label = "no_liveness crash2 server {}".format(i + 1))
  #plt.plot(timestamps9, requests9[i], label = "partial_liveness crash2 server {}".format(i + 1))
  plt.plot(timestamps10, requests10[i], label = "liveness crash2 server {}".format(i + 1))

plt.legend()
plt.show()
