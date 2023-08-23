if [[ $EUID -ne 0 ]]; then
    echo "$0  not running as root. Run using sudo."
    exit 2
fi
sudo systemctl disable clash
sudo systemctl stop clash
rm -rf /usr/local/clash
rm -rf /etc/systemd/system/clash.service
sudo systemctl daemon-reload

echo "
*****************************
Clash uninstalled successfully
*****************************
The configuration file is at /usr/clash
You can delete it mannually！
"
