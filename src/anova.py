import numpy as np
import pandas as pd
import researchpy as rp
# import seaborn as sns
import statsmodels.api as sm
# import statsmodels.stats.multicomp
from statsmodels.formula.api import ols


def two_way_anova(xs: tuple, ys: tuple, values: tuple, replications, stds: tuple = None, log_transform=True):
    with pd.option_context('display.max_rows', 100):
        xname, xlevels = xs
        yname, ylevels = ys
        dname, data = values

        y = np.repeat(ylevels, replications)
        for i in range(1, len(xlevels)):
            thing = np.repeat(ylevels, replications)
            y = np.concatenate((y, thing))

        x = np.repeat(xlevels, len(ylevels) * replications)

        df = pd.DataFrame({dname: data,
                           xname: x,
                           yname: y})

        if stds:
            df[stds[0]] = stds[1]
            # Rearrange
            df = df[[dname, stds[0], xname, yname]]

        df[dname] = df[dname].astype(np.float)
        print("=" * 30)
        print("Original data")
        print(df)

        if log_transform:
            print("=" * 30)
            print("LN Transformed data")
            df[dname] = np.log(df[dname])
            df[stds[0]] = stds[1]
            print(df)

        # Remove stds again
        if stds:
            del df[stds[0]]

        print(rp.summary_cont(df.groupby([xname, yname]))[dname])

        model = ols(f"{dname}~ C({xname})*C({yname})", df).fit()
        # Seeing if the overall model is significant
        print("=" * 30)
        print(
            f"Overall model F({model.df_model:.0f},{model.df_resid:.0f}) = {model.fvalue:.3f}, "
            f"p = {model.f_pvalue:.4f}")
        print(model.summary())

        print("=" * 30)
        print("ANOVA")
        res = sm.stats.anova_lm(model, typ=2)
        print(res)


if __name__ == '__main__':
    # Example using exercise 3 of Homework 1
    times = [3200, 3150, 3250, 4700, 4740, 4660, 3200, 3220, 3180, 5100, 5200, 5000, 6800, 6765, 6835,
             5120, 5100, 5140, 9400, 9300, 9500, 4160, 4100, 4220, 5610, 5575, 5645, 12240, 12290, 12190,
             8960, 8900, 8840, 19740, 19790, 19690, 7360, 7300, 7420, 22340, 22440, 22540, 28560, 28360, 28760]

    xs = ('Classifiers', ['A1', 'A2', 'A3'])
    ys = ('Dataset', ['B1', 'B2', 'B3', 'B4', 'B5'])
    values = ('Time', times)

    two_way_anova(xs, ys, values, 3)
