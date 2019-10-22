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


if __name__ == '__main__':
    log_dir = "../logs/"
    experiment = "test/"

    frames = list()
    for i, f in enumerate(glob(f"{log_dir}{experiment}*.log")):
        frame = parse_file(f, i)
        frames.append(frame)

    result = pd.concat(frames)
    print(result)
