# RESTORE

<!-- One Paragraph of project description goes here -->
RESTORE stands for regression testing of two dataset migration. Given two datasets in a scenario where a legacy dataset will be replaced by a target dataset, we will analyze the difference between them based on a number of tests such as:

   1. Distribution test: Kolmogorov-Smirnov test;
   2. Correlation tests: Pearson correlation coefficient and Spearman's correlation;
   3. Mean relative errors;
   4. The difference between two hierarchical pairs in Spearman's test;
   5. Features that have NA values, Missing Columns, etc.;
   6. Hybrid tests, which shows features that appear in Kolmogorov-Smirnov test, mean relative error test, and correlation tests.

The final report will be written into a user-specified `xlsx` file or an object (which is stored in an RData file). Users can choose the test results produced in the final report.

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

Under the root directory of this project, we provide one example of how to use this package. After the installation, you can test the installation by running the `example.R` file. The `example.R` file will call the function of `test_two_datasets()`. In addition, you can type `help("test_two_datasets")` in R console to see the details of all the arguments.

### Break down into end to end tests

In `example.R`, we define five `csv` files for inputs --- `legacy_file`, `target_file`, `hier`, `hier_pair`, and `thresholds` with full path (alertatively, you can also use 'data.frame' as input parameters instead of files); we also define one `xlsx` file for outputs --- `final_result`; `key_col` stores the column name of the key, and `hier_col` stores the column name of the geographic hierarchy. One example of calling the function can be seen as follows.

```
test_two_datasets(legacy_file = legacy_file,
                  target_file = target_file,
                  hier = geo_hier,
                  hier_pair = geo_pair,
                  thresholds = thresholds,
                  final_report = final_report,
                  key_col = key,
                  hier_col = hierarchy)
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
