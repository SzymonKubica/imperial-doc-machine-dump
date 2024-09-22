import matplotlib.pyplot as plt
import csv


def read_data_from_file(filename: str):
    # data is a list of tuples (cache_size, cache_miss_rate)
    data = []
    with open(filename) as csvfile:
        reader = csv.reader(csvfile, delimiter = ',')
        # example row: D1_cache_size, 64  ,dl1.miss_rate, 0.1614
        for row in reader:
            data.append((int(row[1]), float(row[3])))
    return data

# Given a list of tuples unzips them into two lists of x, y coordinates so that
# matplotlib can plot them
def unzip_data(data):
    return list(map(list, zip(*data)))


def main():
    mm1_data = read_data_from_file('varycachesize_MM1_64_8192.csv')
    mm2_data = read_data_from_file('varycachesize_MM2_64_8192.csv')
    mm3_data = read_data_from_file('varycachesize_MM3_64_8192.csv')


    [cache_sizes, mm1_miss_ratios] = unzip_data(mm1_data)
    [_, mm2_miss_ratios] = unzip_data(mm2_data)
    [_, mm3_miss_ratios] = unzip_data(mm3_data)

    print("MM1 Miss Ratios:\n", mm1_miss_ratios)
    print("MM2 Miss Ratios:\n", mm2_miss_ratios)
    print("MM3 Miss Ratios:\n", mm3_miss_ratios)

    plt.plot(cache_sizes, mm1_miss_ratios, label='MM1')
    plt.plot(cache_sizes, mm2_miss_ratios, label='MM2')
    plt.plot(cache_sizes, mm3_miss_ratios, label='MM3')

    # Ensure that the x axis correctly deals with the cache sizes.
    plt.xticks(cache_sizes, labels=list(map(str, cache_sizes)))
    plt.xscale('log', base=2)


    plt.ylabel('Cache Miss Rate')
    plt.xlabel('D1 Cache Size')

    plt.legend()
    plt.show()


if __name__ == '__main__':
    main()

