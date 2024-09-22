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

#for i in range(NUM_SERVERS):
#  plt.plot(timestamps1, requests1[i], label = "full_liveness_bad server {}".format(i + 1))
#  plt.plot(timestamps2, requests2[i], label = "simple_liveness server {}".format(i + 1))
#  plt.plot(timestamps3, requests3[i], label = "full_liveness server {}".format(i + 1))

plt.plot(timestamps1, requests1[0], label = "full_liveness_bad server {}".format(0))
plt.plot(timestamps2, requests2[0], label = "simple_liveness server {}".format(0))
plt.plot(timestamps3, requests3[0], label = "full_liveness server {}".format(0))

plt.legend()
plt.show()
