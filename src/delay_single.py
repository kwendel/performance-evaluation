from anova import two_way_anova
from delay_all import avg_time_per_epoch, final_accuracy
from parse import parse_dir


if __name__ == '__main__':

    log_dir = '../results/delay_single_logs/'
    log_prefix = 'delay-single'

    # TODO fill in available logs
    xs = ('Workers', ['w1'])
    ys = ('Delays', ['d10', 'd35', 'd140', 'd500'])
    replications = 5

    # Per w - delay
    time_per_epoch = list()
    final_acc = list()

    for worker in xs[1]:
        for delay in ys[1]:
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
