# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [v2.0.0] - 2019-12-18
- add multi version of strip-comment routine
- update API to 2
- deprecate the original signature;
  it will be removed in version 3.0.0.
- improve robustness of strip-comment to multi-char comment marks
- add tests for it 

## [v1.0.0] - 2019-12-17
- started a renamed version of module Text::More (which is now deprecated)
- improved routine 'strip-comment' to allow returning the comment as well
    as the stripped input line
- improved routine 'strip-comment' to allow normalizing the returned
    strings
- improved documentation by using Raku pod declarator blocks
