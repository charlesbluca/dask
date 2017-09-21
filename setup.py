#!/usr/bin/env python

import sys
from os.path import exists
from setuptools import setup
import versioneer

# NOTE: These are tested in `continuous_integration/travis/test_imports.sh` If
# you modify these, make sure to change the corresponding line there.
extras_require = {
  'array': ['numpy', 'toolz >= 0.7.3'],
  'bag': ['cloudpickle >= 0.2.1', 'toolz >= 0.7.3', 'partd >= 0.3.8'],
  'dataframe': ['numpy', 'pandas >= 0.19.0', 'toolz >= 0.7.3',
                'partd >= 0.3.8', 'cloudpickle >= 0.2.1'],
  'distributed': ['distributed >= 1.16', 's3fs >= 0.0.8'],
  'delayed': ['toolz >= 0.7.3'],
}
extras_require['complete'] = sorted(set(sum(extras_require.values(), [])))

packages = ['dask', 'dask.array', 'dask.bag', 'dask.store', 'dask.bytes',
            'dask.dataframe', 'dask.dataframe.io', 'dask.dataframe.tseries',
            'dask.diagnostics']

tests = [p + '.tests' for p in packages]

# Only include pytest-runner in setup_requires if we're invoking tests
if {'pytest', 'test', 'ptr'}.intersection(sys.argv):
    setup_requires = ['pytest-runner']
else:
    setup_requires = []

setup(name='dask',
      version=versioneer.get_version(),
      cmdclass=versioneer.get_cmdclass(),
      description='Parallel PyData with Task Scheduling',
      url='http://github.com/dask/dask/',
      maintainer='Matthew Rocklin',
      maintainer_email='mrocklin@gmail.com',
      license='BSD',
      keywords='task-scheduling parallel numpy pandas pydata',
      packages=packages + tests,
      long_description=(open('README.rst').read() if exists('README.rst')
                        else ''),
      setup_requires=setup_requires,
      tests_require=['pytest'],
      extras_require=extras_require,
      zip_safe=False)
