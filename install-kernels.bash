#!/bin/bash
set -ex

for f in /tmp/envs/*.yml; do
    if [[ -f $f ]]; then
        # install kernel env and register kernelspec
        echo "installing kernel env:"
        cat $f

        conda env create -f $f
        name=`awk '/^name:/{sub("\r$", "");print $2;exit;}' $f`
        prefix=`awk '/^prefix:/{sub("\r$", "");print $2;exit;}' $f`
        ${prefix}/bin/ipython kernel install --user --name ${name}

        echo '' > ${prefix}/conda-meta/history
        conda list -p ${prefix}
    fi
done

# Clean things out!
conda clean --all -f -y
