#!/bin/bash
echo -e "[Unit] \nDescription=Puma Ruby Application \n[Service] \nUser=appuser \nGroup=appuser \nWorkingDirectory=/home/appuser/reddit \nExecStart=/usr/local/bin/puma \n[Install] \nWantedBy=multi-user.target" > /etc/systemd/system/puma.service
systemctl daemon-reload
systemctl enable puma.service