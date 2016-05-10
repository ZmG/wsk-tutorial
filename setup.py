# -*- coding: utf-8 -*-
from setuptools import setup
from setuptools import find_packages

setup(
    name='wsk_tutorial',
    version='0.1.1',
    author=u'IBM jStart',
    author_email='jstart@us.ibm.com',
    packages=find_packages(),
    license='TBD',
    description='An interactive learning environment to get familiar with the OpenWhisk cli',
    long_description=open('README.md').read(),
    include_package_data=True,
)
