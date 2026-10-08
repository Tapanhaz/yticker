from Cython.Build import cythonize
from setuptools import Extension, setup
from setuptools.command.build_ext import build_ext


class BuildExt(build_ext):
    _FLAGS = {  # noqa: RUF012
        "msvc": ["/std:c++latest", "/O2"],
        "unix": ["-std=c++23", "-O3"],
        "mingw32": ["-std=c++23", "-O3"],
    }

    def build_extensions(self):
        flags = self._FLAGS.get(self.compiler.compiler_type, [])
        for ext in self.extensions:
            ext.extra_compile_args = flags + list(ext.extra_compile_args or [])
        super().build_extensions()


extensions = [
    Extension("yticker.yticker", ["yticker/yticker.pyx"], language="c++"),
]

setup(
    ext_modules=cythonize(
        extensions,
        compiler_directives={"language_level": "3"},
    ),
    cmdclass={"build_ext": BuildExt},
)
