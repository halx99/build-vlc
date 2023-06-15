release_tag=$1

# build dep gnutls
git clone https://github.com/gnutls/gnutls
cd gnutls
git checkout 3.7.9
sudo apt install gperf autopoint gtk-doc-tools nettle-dev libidn-dev libtasn1-dev libev-dev libp11-kit-dev libtasn1-bin texinfo
./bootstrap
./configure --prefix=/usr --with-included-libtasn1 --with-included-unistring
make && sudo make install
cd -

# build vlc
git clone https://github.com/videolan/vlc
cd vlc
if [ $release_tag != "" ]; then
    echo Checking out to $release_tag ...
    git checkout $release_tag
fi
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev liba52-0.7.4-dev libasound2-dev
sudo apt install flex bison gettext
./bootstrap
cwd=`pwd`
./configure --enable-debug --prefix=$cwd/../libvlc-dev --disable-lua --disable-xcb --disable-qt --enable-gnutls
make && make install
cd -

# create package for upload
zip -q -r libvlc-dev.zip ./libvlc-dev
