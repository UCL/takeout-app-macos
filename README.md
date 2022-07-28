# Takeout Filter

MacOS desktop application for processing Google Takeout export files.

![GitHub release](https://img.shields.io/github/release/UCL/takeout-app-macos.svg)

## Installation

Download and move to `/Applications` folder. It runs on MacOS Monterey 12.4.

## Usage

The application extracts and filters search activity data from Google Takeout exports. All exports must be present in a single folder.

### Input files

The application accepts Takeout export files in ZIP format, where the MyActivity report is in either JSON or HTML format.

#### Takeout files

All Takeout exports **must** be ZIP files in the format `[ID].zip`, where ID is an integer.

#### Catalogue file

It is a CSV file containing the dates of presentation and the names to be filtered off the Takeout export.
The CSV files **must** have the following format:

```
ID,DateOfPresentation,NamesToFilter
1001,2022-07-28,Forename Surname
1002,2022-07-29,Forename Surname
```

The CSV file **must** include a header in its first line, and the date of presentation **must** be in the format `YYYY-MM-DD`.

### Output files

The application will generate two csv files per ID. All output files will be saved in the `TakeoutFilter` directory created in the output folder. This folder can then be zipped and shared:

- Aggregates: Named `[id]-aggregates.csv`, it contains the date of the first query, and the total number of queries before the filtering.

- Queries: Named `[id]-queries.csv`, it contains the list of health related queries after the filtering process, and their timestamp.


## Reporting bugs

Please use the Github issue tracker for any bugs or feature suggestions:

[https://github.com/UCL/takeout-app-macos/issues](https://github.com/UCL/takeout-app-macos/issues)


## Authors

- David Guzman (Github: [@david-guzman](https://github.com/david-guzman))

Except `porterstemmer_ansi_thread_safe.c`, The Porter Stemming Algorithm, by Martin Porter [https://tartarus.org/martin/PorterStemmer/](https://tartarus.org/martin/PorterStemmer/)
