from glob import glob

import numpy as np
import pandas as pd


def parse_file(fname, idx):
    print(f"Parsing {fname}")

    epoch = 1
    total_times = list()
    accs = list()

    for line in open(fname):

        if 'INFO' not in line:
            continue

        # 2019-10-22 13:04:32 INFO  DistriOptimizer$:451 - [Epoch 1 60032/60000][Iteration 469][Wall Clock 27.8385898s]
        # Epoch finished. Wall clock time is 28003.4155 ms
        if 'Epoch finished' in line:
            time = line.split("Wall clock time is ")[1]
            time = time.split(" ")[0]

            total_times.append(float(time))

            epoch += 1

        #  2019-10-22 13:04:33 INFO  DistriOptimizer$:180 - [Epoch 1 60032/60000][Iteration 469][Wall Clock 27.8385898s]
        # Top1Accuracy is Accuracy(correct: 7785, count: 10000, accuracy: 0.7785)
        if 'Top1Accuracy' in line:
            acc = line.split("accuracy: ")[1]
            acc = acc.split(")")[0]

            accs.append(float(acc))

    diffs = [total_times[0]] + list(np.diff(total_times))

    data = {
        'Epoch':               list(range(1, epoch)),
        'Accuracy':            accs,
        'Time per epoch (ms)': diffs,
        'Total time':          total_times
    }

    # Zero index
    idx = range((epoch - 1) * (idx), (epoch - 1) * (idx + 1))

    df = pd.DataFrame(data=data, index=idx)
    return df


def parse_dir(dirname):
    frames = list()
    for i, f in enumerate(glob(f"{dirname}/*.log")):
        frames.append(parse_file(f, i))

    result = pd.concat(frames)
    return result


def avg_time_per_epoch(df, col_idx=2, epochs=20, runs=5):
    times = list()
    stds = list()
    start_row = 0
    end_row = start_row + (epochs - 1)

    for i in range(0, runs):
        data = df.iloc[start_row:end_row, col_idx]
        times.append(data.mean())
        stds.append(data.std())
        start_row += epochs
        end_row += epochs

    return times, stds


def final_accuracy(df, col_idx=1, epochs=20, runs=5):
    accs = list()
    final_epoch = epochs - 1

    for i in range(0, runs):
        accs.append(df.iloc[final_epoch, col_idx])

    return accs


if __name__ == '__main__':

    # Example to parse a directory
    log_dir = "../results/delay_logs/"
    experiment = "delay-w1-d10/"

    frames = list()
    for i, f in enumerate(glob(f"{log_dir}{experiment}*.log")):
        frame = parse_file(f, i)
        frames.append(frame)

    result = pd.concat(frames)
    print(result)
