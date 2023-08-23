
if [[ $EUID -ne 0 ]]; then
    echo "$0  not running as root. Run using sudo."
    exit 2
fi

sudo mkdir /etc/clash
sudo mkdir /etc/clash/web-ui
sudo mkdir /etc/clash/configs

if [[ ! -e FILE ]]; then
	wget https://release.dreamacro.workers.dev/latest/clash-linux-amd64-v3-latest.gz
fi
gunzip clash-linux-amd64-v3-latest.gz
sudo mv clash-linux-amd64-v3-latest clash
sudo mv clash /usr/local/clash
# rm -rf clash-linux-amd64-v3-latest.gz
sudo chmod +x /usr/local/clash


cat << EOF > /etc/systemd/system/clash.service
[Unit]
Description=Clash daemon, A rule-based proxy in Go.
After=network.target

[Service]
Type=simple
Restart=always
ExecStart=/usr/local/clash -d /etc/clash/configs
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

if [[ ! -e FILE ]]; then
	wget https://github.com/haishanh/yacd/releases/download/v0.3.6/yacd.tar.xz
fi

tar -xvf yacd.tar.xz
#rm -rf yacd.tar.xz
sudo mv public /etc/clash/web-ui

sudo systemctl start clash.service

echo "Waiting 10 seconds to download some files"
sleep 10

sudo systemctl stop clash.service

echo "
*****************************************************************************
Clash Installed Successfully

To start clash, run: sudo systemctl start clash
To stop clash, run: sudo systemctl stop clash
To enable clash on boot, run: sudo systemctl enable clash

To view the web UI, go to http://localhost:9090/ui

To change the config, edit the file at /etc/clash/configs/config.yaml

*****************************************************************************

"
