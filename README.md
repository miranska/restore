# RESTORE

<!-- One Paragraph of project description goes here -->
RESTORE stands for REgreSsion Testing tool fOR datasEts. Given two datasets in a scenario where an old version of a dataset is replaced by a new version of a dataset, we analyze the difference between them based on a number of tests, such as

   1. Distribution test: Kolmogorov-Smirnov test;
   2. Correlation tests: Pearson correlation coefficient and Spearman's correlation;
   3. Different variables and records;
   4. Magnitude comparison;
   5. Mean relative errors;
   6. The difference between two hierarchical pairs in Spearman's test;
   7. Features that have NA values;
   8. Hybrid tests, which shows features that appear in Kolmogorov-Smirnov test, mean relative error test, and correlation tests;
   9. Ranking, which shows the ranking of variables that appear in Kolmogorov-Smirnov test, mean relative error test, and correlation tests.

These tests help us assess if discrepancies in two versions of the dataset are attributed to the natural evolution of the data or to errors in data transformations. The former is expected and can be ignored, while the latter is a defect and should be corrected. RESTORE generates a report that helps an analyst to differentiate between these two cases. Our [study](https://arxiv.org/pdf/1903.03676.pdf) suggests that RESTORE enables fast and efficient detection of errors in the data as well as decreases the cost of testing.

## Announcements

We are working on porting the code from a private Github repo to this one; please stay tuned.

## Getting Started

These instructions will show you how to instal the RESTORE package from GitHub, and how to run RESTORE on your local machine for development and testing purposes.

### Prerequisites

You need to install `devtools` first in R to install the package.

```R
install.packages('devtools')
```

### Installing

To install it directly from GitHub:
```R
devtools::install_github("https://github.com/miranska/restore")
```

To install it locally:

1. Download the source code from GitHub
2. In R console, run the following command:

```R
devtools::install("The full path to the source code", repos=NULL, type='source')
```

## Running the tests

Under the `demo` directory of this project, we provide one example of how to use this package. After the installation, you can test the installation by running the `example.R` file. The `example.R` file will call the function of `test_two_datasets()`. In addition, you can type `help("test_two_datasets")` in R console to see the details of all the arguments.

### Break down into end to end tests

#### Compare hierarchical datasets
A demo of comparing two hierarchical datasets is given in [`example.R`](https://github.com/miranska/restore/blob/master/demo/example.R), which executes `test_two_datasets` function used to compare two vintages of a dataset.

In this demo, we read the data from five `RData` files residing in the [`data`](https://github.com/miranska/restore/tree/master/data) folder. Alternatively, the data can be supplied as R data frames or read from CSV files (see the manual for details). The old vintage of the dataset resides in `restore_old.RData`, the new vintage -- in `restore_new.RData`. The file  `restore_geo_hierarchies.RData` contains a ranking of the hierarchies, `restore_geo_pairs.RData` --- pair-wise relations between the hierarchy levels, and `restore_thresholds.RData` --- threshold values for the metrics of interest. We discuss the details of the input files in Section 4.1 of the [preprint](https://arxiv.org/pdf/1903.03676.pdf).

```R
old_dataset <- # read data frame from restore_old.RData
new_dataset <- # read data frame from restore_new.RData
hierarchy_ordering <- # read data frame from restore_geo_hierarchies.RData
hierarchy_pairs <- # read data frame from restore_geo_pairs.RData
metric_thresholds <- # read data frame from restore_thresholds.RData
```

We also need to provide the names of the `key` and `hierarchy` columns in the `restore_old.RData` and `restore_new.RData`:

```R
key <- 'CODE'
hierarchy <- 'GEO'
```

Finally, we should specify the name of the output file in `xlsx` format or/and `RData` format. The former is passed to `final_report` parameter of the `test_two_datasets`, the latter to the parameter `final_data`. In this demo, we will save the output in both of them:

```R
final_report <- paste(output_dir, 'analysis_results_hierarchy.xlsx', sep = '')
final_data <- paste(output_dir, 'analysis_results_hierarchy.RData', sep = '')
```

Function `test_two_datasets` takes the parameter values defined above, executes the tests and saves the results in both the `final_report` and the `final_data` files. The samples of output files `analysis_results_hierarchy.xlsx` and `analysis_results_hierarchy.RData` reside in the [`inst/extdata/`](https://github.com/miranska/restore/tree/master/inst/extdata) folder.

```R
test_two_datasets(legacy_df = old_dataset,
                  target_df = new_dataset,
                  hier_df = hierarchy_ordering,
                  hier_pair_df = hierarchy_pairs,
                  thresholds_df = metric_thresholds,
                  final_report = final_report,
                  final_data = final_data,
                  key_col = key,
                  hier_col = hierarchy)
```

#### Compare datasets with flat hierarchy
The comparison of the datasets with flat hierarchy (i.e., those that contain non-hierarchical data) is given in [example_no_hierarchy.R](https://github.com/miranska/restore/blob/master/demo/example_no_hierarchy.R).  This comparison is even more straightforward, as we do not need any hierarchy-related data. Thus, we will use only three data frames:

```R
old_dataset <- # read data frame from restore_old.RData
new_dataset <- # read data frame from restore_new.RData
metric_thresholds <- # read data frame from restore_thresholds.RData
```

To minimize the size of this R package, we reuse the hierarchical files used in the [`example.R`](https://github.com/miranska/restore/blob/master/demo/example.R) demo. Therefore, we need to eliminate the columns containing information about the hierarchy:
```R
#let us remove the "GEO" column to mimic flat hierarchy
old_dataset$GEO <- NULL
new_dataset$GEO <- NULL
```
In practice, these columns would not exist in the input files.

We then need to specify the name of the `key` columns in the `restore_old.RData` and `restore_new.RData`:

```R
key <- 'CODE'
```

Finally, we should provide the name of the output file in `xlsx` format or/and `RData` format. The former is passed to `final_report` parameter of the `test_two_datasets`, the latter to the parameter `final_data`. In this demo we will save the output in both of them:

```R
final_report <- paste(output_dir, 'analysis_results_flat_hierarchy.xlsx', sep = '')
final_data <- paste(output_dir, 'analysis_results_flat_hierarchy.RData', sep = '')
```

Function `test_two_datasets` takes the parameter values defined above, executes the tests and saves the results in both the `final_report` and the `final_data` files. The samples of output files `analysis_results_flat_hierarchy.xlsx` and `analysis_results_flat_hierarchy.RData` reside in the [`inst/extdata/`](https://github.com/miranska/restore/tree/master/inst/extdata) folder. Note that the reports will contain a dummy column `GEO` which can be ignored.

```R
test_two_datasets(legacy_df = old_dataset,
                  target_df = new_dataset,
                  thresholds_df = metric_thresholds,
                  final_report = final_report,
                  final_data = final_data,
                  key_col = key)
```

### Sample data and sample outputs

To illustrate the usage of RESTORE, we provide a set of metadata and sample outputs in the folder of [`inst/extdata/`](https://github.com/miranska/restore/tree/master/inst/extdata) under the root directory of RESTORE.

The metadata and the sample output files are as follows.

1. `VariableDescriptions.csv` --- the descriptions of variable names in `restore_old.RData` and `restore_new.RData` (residing in the [`data`](https://github.com/miranska/restore/tree/master/data) folder). These two `RData` files contain data frames of the old and new versions of the data, respectively.
2. `analysis_results_hierarchy.xlsx` --- the sample report for comparing hierarchical data (with multiple tabs for various test results).
3. `analysis_results_hierarchy.RData` --- the sample report for comparing non-hierarchical (flat) data in the machine-readable format.
4. `analysis_results_flat_hierarchy.xlsx` --- the sample report for comparing non-hierarchical (flat) data (with multiple tabs for various test results).
5. `analysis_results_flat_hierarchy.RData` --- the sample report for comparing non-hierarchical (flat) data in the machine-readable format.

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
