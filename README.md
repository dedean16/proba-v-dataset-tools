# PROBA-V Dataset Tools
PROBA-V Python Data Tool collection for testing Super Resolution algorithms on PROBA-V satellite images. Commit titles in this repo start with a `[CATEGORY]:` label. As there are several tools in this repo, each commit will be categorized as either one of these tools, or `[MAIN]` if they affect the entire repo.

## Tools:
- `[COLLECT]:` Downloads PROBA-V satellite images from the website with `wget`.
- `[SHOW]:` A means of showing (manageable slices) of satellite image data files.
- `[MAP]:` Generates a map that shows the contents of the dataset in a clear overview.
- `[COUPLE]:` Sorts out corresponding 100m and 300m downloaded data
- `[FILTER]:` Filters images to construct a smaller subset containing all features/cases important for testing super resolution.
- `[SR]:` The Super Resolution algorithm(s).
- `[DELTA]` Measure for differences in the multiple frames used for the Super Resolution algorithm.
- `[METRIC]` Quality metric of the SR algorithm performance.

## Requirements
- Python 3
- Python libraries: h5py, numpy
- wget
