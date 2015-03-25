# -*- coding: utf-8 -*-
from setuptools import setup
from setuptools import find_packages

setup(
    name='trycedocker-tutorial',
    version='0.2.1',
    author=u'IBM jStart',
    author_email='jstart@us.ibm.com',
    packages=find_packages(),
    url='https://hub.jazz.net/git/joshisa/trycedocker-tutorial/',
    license='TBD',
    description='An interactive learning environment to get familiar with the IBM Containers Extension cli',
    long_description=open('README.md').read(),
    include_package_data=True,
)
