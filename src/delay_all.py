from anova import two_way_anova
from parse import parse_dir, avg_time_per_epoch, final_accuracy

if __name__ == '__main__':

    baseline_log_dir = '../results/delay_baseline_logs/'
    baseline_log_prefix = 'baseline'
    log_dir = '../results/delay_logs/'
    log_prefix = 'delay'

    xs = ('Workers', ['w1', 'w4', 'w6'])
    ys = ('Delays', ['d0', 'd10', 'd35', 'd140', 'd500'])
    replications = 5

    # Per w - delay
    time_per_epoch = list()
    final_acc = list()

    for worker in xs[1]:
        directory = f"{baseline_log_dir}{baseline_log_prefix}-{worker}-d0"
        print(directory)
        df = parse_dir(directory)

        # Compute average time per epoch
        # Compute end accuracy
        avg = avg_time_per_epoch(df)
        acc = final_accuracy(df)
        time_per_epoch.extend(avg)
        final_acc.extend(acc)

        for delay in ys[1][1:]:
            directory = f"{log_dir}{log_prefix}-{worker}-{delay}"
            df = parse_dir(directory)

            # Compute average time per epoch
            # Compute end accuracy
            avg = avg_time_per_epoch(df)
            acc = final_accuracy(df)
            time_per_epoch.extend(avg)
            final_acc.extend(acc)


    times = ('Mean_Time', time_per_epoch)
    accs = ('Final_Accuracy', final_acc)

    # Do anova for both
    two_way_anova(xs, ys, times, replications, log_transform=True)
    two_way_anova(xs, ys, accs, replications, log_transform=False)
