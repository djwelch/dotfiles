# /bin/sh
ls config/ | xargs -I {dir} -n 1 rsync -uia ./config/{dir} ~/.config/
