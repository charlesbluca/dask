set -xe

# TODO: Add cityhash back
# We don't have a conda-forge package for cityhash
# We don't include it in the conda environment.yaml, since that may
# make things harder for contributors that don't have a C++ compiler
# python -m pip install --no-deps cityhash

if [[ ${UPSTREAM_DEV} ]]; then

    # NOTE: `dask/tests/test_ci.py::test_upstream_packages_installed` should up be
    # updated when pacakges here are updated.

    # FIXME https://github.com/mamba-org/mamba/issues/412
    # mamba uninstall --force ...
    conda uninstall --force bokeh
    mamba install -y -c bokeh/label/dev bokeh

    # FIXME workaround for https://github.com/mamba-org/mamba/issues/1682
    arr=($(mamba search --override-channels -c arrow-nightlies pyarrow | tail -n 1))
    export PYARROW_VERSION=${arr[1]}
    # FIXME having trouble installing nightly version of pyarrow. Seeing solve issues like:
    #     package pyarrow-11.0.0.dev129-py310hbc2c91e_0_cuda requires
    #     arrow-cpp 11.0.0.dev129 py310hc498ad1_0_cuda, but none of the
    #     providers can be installed
    # The nightly pyarrow / arrow-cpp packages currently don't install with latest
    # protobuf / abseil, see https://github.com/dask/dask/issues/9449
    # mamba install -y -c arrow-nightlies -c conda-forge "pyarrow=$PYARROW_VERSION" "libprotobuf=3.19"

    # FIXME https://github.com/mamba-org/mamba/issues/412
    # mamba uninstall --force ...
    conda uninstall --force fastparquet
    python -m pip install \
        --upgrade \
        locket \
        git+https://github.com/pydata/sparse \
        git+https://github.com/dask/s3fs \
        git+https://github.com/intake/filesystem_spec \
        git+https://github.com/dask/partd \
        git+https://github.com/dask/zict \
        git+https://github.com/dask/distributed \
        git+https://github.com/dask/fastparquet \
        git+https://github.com/zarr-developers/zarr-python

    # FIXME https://github.com/mamba-org/mamba/issues/412
    # mamba uninstall --force ...
    conda uninstall --force numpy pandas scipy
    python -m pip install --no-deps --pre --retries 10 \
        -i https://pypi.anaconda.org/scipy-wheels-nightly/simple \
        numpy \
        pandas \
        scipy

    # Used when automatically opening an issue when the `upstream` CI build fails
    mamba install pytest-reportlog

    # Numba doesn't currently support nightly `numpy`. Temporarily remove
    # `numba` from the upstream CI environment as a workaround.
    # https://github.com/numba/numba/issues/8615

    # Crick doesn't work with latest nightly `numpy`. Temporarily remove
    # `crick` from the upstream CI environment as a workaround.
    # Can restore `crick` once https://github.com/dask/crick/issues/25 is closed.

    # Tiledb is causing segfaults. Temporarily remove `tiledb` and `tiledb-py`
    # as a workaround.

    # FIXME https://github.com/mamba-org/mamba/issues/412
    # mamba uninstall --force ...
    conda uninstall --force numba crick tiledb tiledb-py


fi

# Install dask
python -m pip install --quiet --no-deps -e .[complete]
echo mamba list
mamba list

# For debugging
echo -e "--\n--Conda Environment (re-create this with \`conda env create --name <name> -f <output_file>\`)\n--"
mamba env export | grep -E -v '^prefix:.*$' > env.yaml
cat env.yaml

set +xe
