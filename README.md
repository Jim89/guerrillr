# guerrillr

A package for setting up and working with Guerrilla Analytics project structures from R.

## Guerrilla Analytics

Developed by Enda Ridge, Guerrilla Analytics is a set of simple princples and practices for building and managing data science projects. For more information check out the [website](http://guerrilla-analytics.net/) or buy the [book](http://guerrilla-analytics.net/book/).

## Installation

You can install this package directly from GitHub using the `devtools` library as follows:

```
install.packages("devtools")
devtools::install_github("jim89/guerrillr")
```

### Package version information

* 0.0.1 - initial package with one function to create project structure;
* 0.0.2 - added create_wp() function to create and log new work products
* 0.0.3 - Re-worked package to use the new Rstudio [project templates](https://rstudio.github.io/rstudio-extensions/rstudio_project_templates.html) for creating the project, and [addins](https://rstudio.github.io/rstudioaddins/) for creating and viewing work products
