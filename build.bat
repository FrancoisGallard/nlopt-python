@rem Sample build script to test build process locally

make clean

@rem Start at package directory
set PKG_DIR=%CD%
set NLOPT_DIR=%CD%\nlopt_src

@rem install numpy, needed to build python
CALL conda install -y -v numpy twine

@rem move up one directory to clone nlopt application
rmdir /S /Q %NLOPT_DIR%
git clone https://github.com/stevengj/nlopt %NLOPT_DIR%

@rem move into build folder
cd %NLOPT_DIR% && mkdir build && cd build

@rem Release configuration
set CONFIG=Release
set CMAKE_PLATFORM=Visual Studio 16 2019

@rem build package
set INST_DIR=%NLOPT_DIR%\install
cmake -G "%CMAKE_PLATFORM%" -DCMAKE_INSTALL_PREFIX="%INST_DIR%" ..
cmake --build . --config %CONFIG% --target install


@rem copy dll and python generated files over to package folder
cp %INST_DIR%\bin\nlopt.dll %PKG_DIR%\nlopt\nlopt.dll
cp %INST_DIR%\lib\site-packages\_nlopt.pyd %PKG_DIR%\nlopt\_nlopt.pyd
cp %INST_DIR%\lib\site-packages\nlopt.py %PKG_DIR%\nlopt\nlopt.py

cd %PKG_DIR%
python setup.py bdist_wheel --plat-name win_amd64

@rem upload to pypi
@rem twine upload --skip-existing dist/*
