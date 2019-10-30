import numpy as np

from parse import avg_time_per_epoch, final_accuracy, parse_dir

if __name__ == '__main__':

    baseline_log_dir = '../results/delay_baseline_logs/'
    baseline_log_prefix = 'baseline'

    xs = ('Workers', ['w1', 'w2', 'w4', 'w6'])
    replications = 5

    for worker in xs[1]:
        directory = f"{baseline_log_dir}{baseline_log_prefix}-{worker}-d0"
        df = parse_dir(directory)

        # Compute average time per epoch
        # Compute end accuracy
        avg = avg_time_per_epoch(df)
        acc = final_accuracy(df)

        print(worker)
        print(f"{np.mean(acc)} -  {np.std(acc)}")
        print(f"{np.mean(avg)} - {np.std(avg)}")
