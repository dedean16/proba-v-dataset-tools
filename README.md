# PROBA-V Dataset Tools
PROBA-V Python Data Tool collection for testing Super Resolution algorithms on PROBA-V satellite images. Commit titles in this repo start with a `[CATEGORY]:` label. As there are several tools in this repo, each commit will be categorized as either one of these tools, or `[MAIN]` if they affect the entire repo.

## Tools:
- `[COLLECT]:` Downloads PROBA-V satellite images from the website with `wget`.
- `[MAP]:` Generates a map that shows the contents of the dataset in a clear overview.
- `[COUPLE]:` Sorts out corresponding 100m and 300m downloaded data. Filters by cloud coverage.
- `[NDVI]:` Computes NDVI images from RED and NIR channels.
- `[SR]:` The Super Resolution algorithm(s). (Third party Matlab scripts.)
- `[KELVINS]:` Functions for validation and scoring on the Kelvins website.
- `[BUILD]:` Build dataset from the coupled images. Computes bicubic interpolation scores.

## Requirements
- Python 3.5+
- Python libraries: h5py, numpy, Pillow, PyPNG, scikit-image and progress
- wget
