import os
import sys
import platform
import subprocess
from Cython.Build import cythonize
from setuptools import setup, Extension, find_packages
try:
    from pyrobuf import __path__ as pyrobuf_path
except ModuleNotFoundError:
    print("pyrobuf not found. Installing...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pyrobuf"])
finally:
    from pyrobuf import __path__ as pyrobuf_path

pyrobuf_src_path = os.path.join(pyrobuf_path[0], 'src')

compiler_flags = []
linker_flags = []
install_requires = ["Cython", "picows", "pyrobuf", "orjson"]

if platform.system() == "Windows":
    if "msvc" in sys.version.lower():
        compiler_flags = ['/std:c++17', "/O2"]
        linker_flags = ["/O2"]       
    elif "gcc" in sys.version.lower() or "clang" in sys.version.lower():
        compiler_flags = ["-O3", '-flto']
        linker_flags = ["-O3"]
    event_loop = "winloop"
else:
    compiler_flags = ["-O3", '-flto']
    linker_flags = ["-O3"]
    event_loop = "uvloop"

install_requires.append(event_loop)

extensions = [
    Extension(
        name="yticker.yaticker_proto",
        sources=["yticker/yaticker_proto.pyx"],
        language="c++",
        include_dirs=[pyrobuf_src_path], 
        extra_compile_args=compiler_flags,
        extra_link_args=linker_flags
    ),
    Extension(
        name="yticker.yticker",
        sources=["yticker/yticker.pyx"],
        language="c++",
        extra_compile_args=compiler_flags,
        extra_link_args=linker_flags
    ),
]

cythonized_extensions = cythonize(
    extensions,
    include_path=[pyrobuf_src_path],  
    compiler_directives={'language_level': "3"}
)

with open("LICENSE", "r", encoding="utf-8") as fh:
    license_file = fh.read()

setup(
    name="yticker",
    version="0.1.0",
    author="Tapan Hazarika",
    author_email="tapanhaz@gmail.com",
    description="A Python package for connecting to yahoo websocket.",
    license= license_file,
    url="https://github.com/Tapanhaz/yticker",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    ext_modules=cythonized_extensions,  
    install_requires=install_requires, 
    zip_safe=False, 
    packages=find_packages()
)
