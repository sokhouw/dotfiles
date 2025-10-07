DIR=$(dirname ${BASH_SOURCE[0]})
NAME=$(basename ${BASH_SOURCE[0]})
for f in $(ls ${DIR} | grep -v ${NAME}); do source ${DIR}/$f; done
