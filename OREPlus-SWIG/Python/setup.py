# -*- coding: iso-8859-1 -*-
"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""

import os, sys, math, codecs
from distutils.cmd import Command
from distutils.command.build_ext import build_ext
from distutils.command.build import build
from distutils.ccompiler import get_default_compiler
try:
    from setuptools import setup, Extension
except:
    from distutils.core import setup, Extension
from distutils import sysconfig

class test(Command):
    # Original version of this class posted
    # by Berthold H�llmann to distutils-sig@python.org
    description = "test the distribution prior to install"

    user_options = [
        ('test-dir=', None,
         "directory that contains the test definitions"),
        ]

    def initialize_options(self):
        self.build_base = 'build'
        self.test_dir = 'test'

    def finalize_options(self):
        build = self.get_finalized_command('build')
        self.build_purelib = build.build_purelib
        self.build_platlib = build.build_platlib

    def run(self):
        # Testing depends on the module having been built
        self.run_command('build')

        # extend sys.path
        old_path = sys.path[:]
        sys.path.insert(0, self.build_purelib)
        sys.path.insert(0, self.build_platlib)
        sys.path.insert(0, self.test_dir)

        # import and run test-suite
        module = __import__('OREPlusTestSuite', globals(), locals(), [''])
        module.test()

        # restore sys.path
        sys.path = old_path[:]

class my_wrap(Command):
    description = "generate Python wrappers"
    user_options = []
    def initialize_options(self): pass
    def finalize_options(self): pass
    def run(self):
        print('Generating Python bindings for OREPlus...')
        swig_version = os.popen("swig -version").read().split()[2]
        major_swig_version = swig_version[0]
        if major_swig_version < '3':
           print('Warning: You have SWIG {} installed, but at least SWIG 3.0.1'
                 ' is recommended. \nSome features may not work.'
                 .format(swig_version))
        swig_dir = os.path.join("..","SWIG")
        ql_swig_dir = os.path.join("..","..","QuantLib-SWIG","SWIG")
        qle_swig_dir = os.path.join("..","..","QuantExt-SWIG","SWIG")
        oredata_swig_dir = os.path.join("..","..","OREData-SWIG","SWIG")
        oreanalytics_swig_dir = os.path.join("..","..","OREAnalytics-SWIG","SWIG")
        if sys.version_info.major >= 3:
            os.system('swig -python -py3 -c++ -modern ' +
                      '-I%s ' % swig_dir +
                      '-I%s ' % ql_swig_dir +
                      '-I%s ' % qle_swig_dir +
                      '-I%s ' % oredata_swig_dir +
                      '-I%s ' % oreanalytics_swig_dir +
                      '-outdir OREPlus -o OREPlus/oreplus_wrap.cpp ' +
                      'oreplus.i')
        else:
            os.system('swig -python -c++ -modern ' +
                      '-I%s ' % swig_dir +
                      '-I%s ' % ql_swig_dir +
                      '-I%s ' % qle_swig_dir +
                      '-I%s ' % oredata_swig_dir +
                      '-I%s ' % oreanalytics_swig_dir +
                      '-outdir OREPlus -o OREPlus/oreplus_wrap.cpp ' +
                      'oreplus.i')

class my_build(build):
    user_options = build.user_options + [
        ('static', None,
         "link against static CRT libraries on Windows")
    ]
    boolean_options = build.boolean_options + ['static']
    def initialize_options(self):
        build.initialize_options(self)
        self.static = None
    def finalize_options(self):
        build.finalize_options(self)


class my_build_ext(build_ext):
    user_options = build_ext.user_options + [
        ('static', None,
         "link against static CRT libraries on Windows")
    ]
    boolean_options = build.boolean_options + ['static']
    def initialize_options(self):
        build_ext.initialize_options(self)
        self.static = None
    def finalize_options(self):
        build_ext.finalize_options(self)
        self.set_undefined_options('build', ('static','static'))

        self.include_dirs = self.include_dirs or []
        self.library_dirs = self.library_dirs or []
        self.define = self.define or []
        self.libraries = self.libraries or []

        extra_compile_args = []
        extra_link_args = []

        compiler = self.compiler or get_default_compiler()

        if compiler == 'msvc':
            try:
                # QuantLib Directories
                QL_INSTALL_DIR = os.environ['QL_DIR']
                self.include_dirs += [QL_INSTALL_DIR]
                self.library_dirs += [os.path.join(QL_INSTALL_DIR, 'lib')]
                # QuantExt Directories
                QLEXT_INSTALL_DIR = os.environ['QLEXT_DIR']
                self.include_dirs += [QLEXT_INSTALL_DIR]
                self.library_dirs += [os.path.join(QLEXT_INSTALL_DIR, 'lib')]
                # OREAnalytics Directories
                OREANALYTICS_INSTALL_DIR = os.environ['OREANALYTICS_DIR']
                self.include_dirs += [OREANALYTICS_INSTALL_DIR]
                self.library_dirs += [os.path.join(OREANALYTICS_INSTALL_DIR, 'lib')]
                # OREData Directories
                OREDATA_INSTALL_DIR = os.environ['OREDATA_DIR']
                self.include_dirs += [OREDATA_INSTALL_DIR]
                self.library_dirs += [os.path.join(OREDATA_INSTALL_DIR, 'lib')]
                # OREPlus Directories
                OREPLUS_INSTALL_DIR = os.environ['OREPLUS_DIR']
                self.include_dirs += [OREPLUS_INSTALL_DIR]
                self.library_dirs += [os.path.join(OREPLUS_INSTALL_DIR, 'lib')]
                OREPLUSAPP_INSTALL_DIR = os.environ['OREPLUSAPP_DIR']
                self.include_dirs += [OREPLUSAPP_INSTALL_DIR]
                self.library_dirs += [os.path.join(OREPLUSAPP_INSTALL_DIR, 'lib')]
                OREPLUSBASE_INSTALL_DIR = os.environ['OREPLUSBASE_DIR']
                self.include_dirs += [OREPLUSBASE_INSTALL_DIR]
                self.library_dirs += [os.path.join(OREPLUSBASE_INSTALL_DIR, 'lib')]
                # BOOST Directories
                BOOST_DIR = os.environ['BOOST']
                self.include_dirs += [BOOST_DIR]
                self.library_dirs += [os.path.join(BOOST_DIR, 'lib', 'x64', 'lib', 'lib')]

                # Link static Libraries
                self.libraries += ['QuantLib-vc141-x64-mt', 'QuantExt-vc141-x64-mt', 'OREAnalytics-vc141-x64-mt', 'OREPlusBase-vc141-x64-mt', 'OREData-vc141-x64-mt', 'OREPlusApp-vc141-x64-mt','libboost_filesystem-vc141-mt-1_65_1', 'libboost_serialization-vc141-mt-1_65_1', 'libboost_regex-vc141-mt-1_65_1']
            except KeyError:
                print('warning: unable to detect QuantExt/QuantLib/OREAnalytics/OREPlus installation')

            if 'INCLUDE' in os.environ:
                dirs = [dir for dir in os.environ['INCLUDE'].split(';')]
                self.include_dirs += [ d for d in dirs if d.strip() ]
            if 'LIB' in os.environ:
                dirs = [dir for dir in os.environ['LIB'].split(';')]
                self.library_dirs += [ d for d in dirs if d.strip() ]
            dbit = round(math.log(sys.maxsize, 2) + 1)
            if dbit == 64:
                machinetype = '/machine:x64'
            else:
                machinetype = '/machine:x86'
            self.define += [('__WIN32__', None), ('WIN32', None),
                            ('NDEBUG', None), ('_WINDOWS', None),
                            ('NOMINMAX', None)]
            extra_compile_args = ['/GR', '/FD', '/Zm250', '/EHsc', '/bigobj' ]
            extra_link_args = ['/subsystem:windows', machinetype]

            if self.debug:
                if self.static:
                    extra_compile_args.append('/MTd')
                else:
                    extra_compile_args.append('/MDd')
            else:
                if self.static:
                    extra_compile_args.append('/MT')
                else:
                    extra_compile_args.append('/MD')

        elif compiler == 'unix':
            ql_compile_args = \
                os.popen('oreplus-config --cflags').read()[:-1].split()
            ql_link_args = \
                os.popen('oreplus-config --libs').read()[:-1].split()

            self.define += [ (arg[2:],None) for arg in ql_compile_args
                             if arg.startswith('-D') ]
            self.include_dirs += [ arg[2:] for arg in ql_compile_args
                                   if arg.startswith('-I') ]
            self.library_dirs += [ arg[2:] for arg in ql_link_args
                                   if arg.startswith('-L') ]
            self.libraries += [ arg[2:] for arg in ql_link_args
                                if arg.startswith('-l') ]

            extra_compile_args = [ arg for arg in ql_compile_args
                                   if not arg.startswith('-D')
                                   if not arg.startswith('-I') ] \
                                   + [ '-Wno-unused' ]
            if 'CXXFLAGS' in os.environ:
                extra_compile_args += os.environ['CXXFLAGS'].split()

            extra_link_args = [ arg for arg in ql_link_args
                                if not arg.startswith('-L')
                                if not arg.startswith('-l') ]
            if 'LDFLAGS' in os.environ:
                extra_link_args += os.environ['LDFLAGS'].split()

        else:
            pass

        for ext in self.extensions:
            ext.extra_compile_args = ext.extra_compile_args or []
            ext.extra_compile_args += extra_compile_args

            ext.extra_link_args = ext.extra_link_args or []
            ext.extra_link_args += extra_link_args

if os.name == 'posix':
    # changes the compiler from gcc to g++
    save_init_posix = sysconfig._init_posix
    def my_init_posix():
        save_init_posix()
        g = sysconfig._config_vars
        if 'CXX' in os.environ:
            g['CC'] = os.environ['CXX']
        else:
            g['CC'] = 'g++'
        if sys.platform.startswith("darwin"):
            g['LDSHARED'] = g['CC'] + \
                            ' -bundle -flat_namespace -undefined suppress'
        else:
            g['LDSHARED'] = g['CC'] + ' -shared'
    sysconfig._init_posix = my_init_posix

datafiles  = []

# patch distutils if it can't cope with the "classifiers" or
# "download_url" keywords
if sys.version < '2.2.3':
    from distutils.dist import DistributionMetadata
    DistributionMetadata.classifiers = None
    DistributionMetadata.download_url = None

classifiers = [
    'Development Status :: 5 - Production/Stable',
    'Environment :: Console',
    'Intended Audience :: Developers',
    'Intended Audience :: End Users/Desktop',
    'License :: OSI Approved :: BSD License',
    'Natural Language :: English',
    'Operating System :: OS Independent',
    'Programming Language :: Python',
    'Topic :: Scientific/Engineering',
]

setup(name             = "OREPlus-Python",
      version          = "@PACKAGE_VERSION@",
      description      = "Python bindings for the OREPlus library",
      long_description = """
OREPlus (http://opensourcerisk.org/) is a C++ library for financial quantitative
analysts and developers, aimed at providing a comprehensive software
framework for quantitative finance.
      """,
      author           = "Quaternion Risk Management",
      author_email     = "info@quaternion.com",
      url              = "http://quternion.com",
      license          = codecs.open('../LICENSE.TXT','r+',
                                     encoding='utf8').read(),
      classifiers      = classifiers,
      py_modules       = ['OREPlus.__init__','OREPlus.OREPlus'],
      ext_modules      = [Extension("OREPlus._OREPlus",
                                    ["OREPlus/oreplus_wrap.cpp"])
                         ],
      data_files       = datafiles,
      cmdclass         = {'test': test,
                          'wrap': my_wrap,
                          'build': my_build,
                          'build_ext': my_build_ext
                          }
      )
