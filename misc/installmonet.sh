#!/bin/bash

touch /etc/apt/sources.list.d/monetdb.list &&
chmod o+w /etc/apt/sources.list.d/monetdb.list &&

suite=$(lsb_release -cs) &&
echo "deb https://dev.monetdb.org/downloads/deb/ $suite monetdb
deb-src https://dev.monetdb.org/downloads/deb/ $suite monetdb" >> /etc/apt/sources.list.d/monetdb.list &&

sudo wget --output-document=/etc/apt/trusted.gpg.d/monetdb.gpg https://www.monetdb.org/downloads/MonetDB-GPG-KEY.gpg &&
chmod og+r /etc/apt/trusted.gpg.d/monetdb.gpg &&

sudo apt update && sudo apt install monetdb5-sql monetdb-client &&

sudo systemctl enable monetdbd &&
sudo systemctl start monetdbd &&
sudo usermod -a -G monetdb $USER
