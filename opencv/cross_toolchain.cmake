set(X_TOOLS /root/x-tools/${PREFIX})

# this is required
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

# specify the cross compiler
SET(CMAKE_C_COMPILER ${X_TOOLS}/bin/${PREFIX}-gcc)
SET(CMAKE_CXX_COMPILER ${X_TOOLS}/bin/${PREFIX}-g++)

# where is the target environment 
SET(CMAKE_FIND_ROOT_PATH ${X_TOOLS})

# search for programs in the build host directories (not necessary)
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries, headers and package in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# configure Boost and Qt
# SET(QT_QMAKE_EXECUTABLE /opt/qt-embedded/qmake)
# SET(BOOST_ROOT /opt/boost_arm)
