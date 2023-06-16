# refer to https://code.videolan.org/videolan/vlc/-/blob/master/doc/BUILD-win32.md
# ucrt for win10+
release_tag=$1

# msvcrt, ucrt(may not works)
crt=ucrt

# install deps
sudo apt-get update -qq
sudo apt-get install -qqy \
    git wget bzip2 file libwine-dev unzip libtool libtool-bin libltdl-dev pkg-config ant \
    build-essential automake texinfo ragel yasm p7zip-full autopoint \
    gettext cmake zip wine nsis g++-mingw-w64-i686 curl gperf flex bison \
    libcurl4-gnutls-dev python3 python3-setuptools python3-mako python3-requests \
    gcc make procps ca-certificates \
    openjdk-11-jdk-headless nasm jq gnupg \
    meson autoconf

# install toolchain
wget https://github.com/mstorsjo/llvm-mingw/releases/download/20230603/llvm-mingw-20230603-$crt-ubuntu-20.04-x86_64.tar.xz
tar xvf llvm-mingw-20230603-$crt-ubuntu-20.04-x86_64.tar.xz -C /opt
export PATH=/opt/llvm-mingw-20230603-$crt-ubuntu-20.04-x86_64/bin:$PATH

# install deps
sudo apt-get install gtk-doc-tools

# clone & build vlc
git clone https://github.com/videolan/vlc.git
if [ $release_tag != "" ]; then
    cd vlc
    echo Checking out to $release_tag ...
    git checkout $release_tag
    cd -
fi
cp ./harfbuzz-patch/* ./vlc/contrib/src/harfbuzz/
mkdir build
cd build
../vlc/extras/package/win32/build.sh -a x86_64 -z -D "E:/dev/vlc"
cd win64
make install
cd -
cd -
mv ./build/win64/_win32 ./libvlc-dev

# create package for upload
zip -q -r libvlc-dev.zip ./libvlc-dev
