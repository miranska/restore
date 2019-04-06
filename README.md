# RESTORE

<!-- One Paragraph of project description goes here -->
RESTORE stands for regression testing of two dataset migration. Given two datasets in a scenario where a legacy dataset will be replaced by a target dataset, we will analyze the difference between them based on a number of tests such as:

   1. Distribution test: Kolmogorov-Smirnov test;
   2. Correlation tests: Pearson correlation coefficient and Spearman's correlation;
   3. Different variables and records;
   4. Magnitude comparison;
   5. Mean relative errors;
   6. The difference between two hierarchical pairs in Spearman's test;
   7. Features that have NA values;
   8. Hybrid tests, which shows features that appear in Kolmogorov-Smirnov test, mean relative error test, and correlation tests;
   9. Ranking, which shows the ranking of variables that appear in Kolmogorov-Smirnov test, mean relative error test, and correlation tests.

The final report will be written into a user-specified `xlsx` file or an object (which is stored in an `RData` file). Users can choose the test results produced in the final report.

## Announcements

We are working on porting the code from a private Github repo to this one; please stay tuned.

## Getting Started

These instructions will show you how to instal the RESTORE package from GitHub, and how to run RESTORE on your local machine for development and testing purposes.

### Prerequisites

You need to install `devtools` first in R to install the package.

```
install.packages('devtools')
```

### Installing

To install it directly from GitHub:
```
devtools::install_github("https://github.com/miranska/restore")
```

To install it locally:

1. Download the source code from GitHub
2. In R console, run the following command:

```
devtools::install("The full path of the source code", repos=NULL, type='source')
```

## Running the tests

Under the `demo` directory of this project, we provide one example of how to use this package. After the installation, you can test the installation by running the `example.R` file. The `example.R` file will call the function of `test_two_datasets()`. In addition, you can type `help("test_two_datasets")` in R console to see the details of all the arguments.

### Break down into end to end tests

In `example.R`, we define five `RData` files for inputs --- `restore_old`, `restore_new`, `restore_geo_hierarchies`, `restore_geo_pairs`, and `restore_thresholds`, which can be found in the folder of `data` (alertatively, you can also use 'data.frame' as input parameters instead of files); we also define one output file in the format of `xlsx` or `RData` --- using `analysis_results_hierarchy.xlsx` or `analysis_results_hierarchy.RData`, respectively; `key` stores the column name of the key, and `hierarchy` stores the column name of the geographic hierarchy. One example of calling the function can be seen as follows.

```
test_two_datasets(legacy_df = legacy_df,
                  target_df = target_df,
                  hier_df = geo_hier,
                  hier_pair_df = geo_pair,
                  thresholds_df = geo_thresholds,
                  final_report = final_report,
                  key_col = key,
                  hier_col = hierarchy)
```

### Sample data and sample outputs

To illustrate the usage of RESTORE, we provide a set of metadata and sample outputs in the folder of `inst/extdata/` under the root directory of RESTORE.

The metadata and the sample output files are as follows.

1. `VariableDescriptions.csv` --- the descriptions of variable names used in `restore_old.RData` and `restore_new.RData`.
2. `analysis_results_hierarchy.xlsx` --- the sample report of hierarchical data structures (with mutiple tabs for various test results).
3. `analysis_results_hierarchy.RData` --- the sample output of hierarchical data structures in the format of `data.frame` in `R`.
4. `analysis_results_flat_hierarchy.xlsx` --- the sample report of flat data structures (with mutiple tabs for various test results).
5. `analysis_results_flat_hierarchy.RData` --- the sample output of flat data structures in the format of `data.frame` in `R`.

## Publication

The details of the RESTORE package are given in a [preprint](https://arxiv.org/abs/1903.03676). Please cite RESTORE package as

```
@article{zhang2019restore,
  title={{RESTORE: Automated Regression Testing for Datasets}},
  author={Zhang, Lei and Howard, Sean and Montpool, Tom and Moore, Jessica and Mahajan, Krittika and Miranskyy, Andriy},
  journal={arXiv preprint arXiv:1903.03676},
  year={2019}
}
```

## Authors

**Sean Howard**,
**Krittika Mahajan**,
**Andriy Miranskyy**,
**Tom Montpool**,
**Jessica Moore**,
**Lei Zhang**

(in ascending order of last names)

## Maintainers

* **Andriy Miranskyy**
* **Lei Zhang**

## License

This project is licensed under the GPL-3

## Contact Us

If you have a found a bug or came up with a new feature -- please open an [issue](https://github.com/miranska/restore/issues).

## Acknowledgments

* This work was partially supported and funded by Natural Sciences and Engineering Research Council of Canada, Ontario Centres of Excellence, and Environics Analytics. We thank employees of Environics Analytics for their valuable feedback!
