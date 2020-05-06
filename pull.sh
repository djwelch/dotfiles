# /bin/sh
ls config/ | xargs -I {dir} -n 1 rsync --exclude 'pure' -uia ~/.config/{dir} ./config
