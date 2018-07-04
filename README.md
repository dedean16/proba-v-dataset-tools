# PROBA-V Dataset Tools
PROBA-V Python Data Tool collection for building a dataset for testing Super Resolution algorithms on PROBA-V satellite images. Commit titles in this repo start with a `[CATEGORY]:` label. As there are several tools in this repo, each commit will be categorized as either one of these tools, or `[MAIN]` if they affect the entire repo.

## Tools:
- `[COLLECT]:` The script `collect.py` downloads all PROBA-V satellite images from the website with `wget`, given the constraints in the config file. The script `couple_collect.py` also takes into account the output tiles from `couple.py`. Configuration: `collect_cfg.py`.
- `[PURGE]:` The `purgedatabase.py` script removes corrupted HDF5 files.
- `[MAP]:` Generates a map that shows the contents of the dataset in a clear overview, which can be found in `/map/map.html`. Configuration: `map_cfg.py`.
- `[COUPLE]:` Sorts out corresponding 100m and 300m downloaded data. Filters by cloud coverage. Configuration: `couple_cfg.py`.
- `[NDVI]:` Computes NDVI images from RED and NIR channels.
- `[SR]:` The Super Resolution algorithm(s). (Third party Matlab scripts.)
- `[KELVINS]:` The script `kelvin_submission_validation.py` contains the functions for validation and scoring on the Kelvins website.
- `[BUILD]:` The `builddataset.py` script builds a dataset from the coupled images. Computes bicubic interpolation norm. Configuration: `build_cfg.py`.

## Configuration files
`paths.py` is a general configuration file, specifying folder paths (e.g. data folder, tiles folder, kelvinsset folder). Other configuration files carry the suffix `_cfg` and are specified in the previous section.

## Recommended order of use
1. Create a credentials file `collect_credentials.py`, using the example `collect_credentials.py-dummy`.
2. Adjust configuration files if required. Be sure to adjust/create the folders specified in `path.py`, as not all of these are created automatically.
3. Download files with `collect.py` (for 1 Region Of Interest) or `couple_collect.py` (for a list of coordinates, specified in `couple_coords.py`). If hard drive is full, go to next step.
4. Use `purgedatabase.py` to remove corrupted and unfinished files.
5. Optional: Use `map.py` to produce a map of database contents.
6. Use `couple.py` to extract areas from HDF5 files into tiles folder. Also extracts Quality Masks from HDF5 files.
7. If hard drive was full after step 2, the data folder may now be emptied; repeat step 2 to 5 until all desired tile images are downloaded and extracted.
8. Use `ndvi.py` to compute and write NDVI images.
9. Use `builddataset.py` to build the dataset datastructure in the kelvinsset folder.

## Requirements
- Python 3.5+
- Python libraries: h5py, numpy, Pillow, PyPNG, scikit-image and progress
- wget
