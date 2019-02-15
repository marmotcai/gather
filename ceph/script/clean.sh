#!/bin/bash
rm -f ./ceph-deploy-ceph.log
rm -rf /root/.ssh

USERNAME=cephuser
WORK_DIR=/home/${USERNAME}

userdel ${USERNAME}
rm -f /etc/sudoers.d/cephuser
rm -rf ${WORK_DIR}/.ssh
rm -rf ${WORK_DIR}

