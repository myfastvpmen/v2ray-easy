#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: Debian 8/9,Ubuntu 16+
#	Description: V2ray + Optimaize
#	Version: 1.4.5
#	Author: LEECHEE
#=================================================

sh_ver="1.4.5"
github="raw.githubusercontent.com/myfastvpmen/v2ray-easy/master"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[info]${Font_color_suffix}"
Error="${Red_font_prefix}[error]${Font_color_suffix}"
Tip="${Green_font_prefix}[tip]${Font_color_suffix}"


#add BBR code
startbbr(){
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	sysctl -p
	echo -e "${Info}TCP Acc. BBR added complate！"
    start_menu
}


#v2ray install
v2ray-install(){
	source <(curl -sL https://git.io/fNgqx)
	echo -e "${Info}v2ray install complate！"
    start_menu
}

#v2ray reinstall -force
v2ray-reinstall(){
   	source <(curl -sL https://git.io/fNgqx) -f
	echo -e "${Info}v2ray reinstall complate！"
    start_menu
}

#prepare for install
v2ray-prepare(){
    apt-get update && apt-get upgrade -y
    apt-get install python3-pip -y
    echo -e "${Info}apt-get up to date！"
    start_menu
}

#prepare for install
v2ray-timesync(){
    ntpdate pool.ntp.org
    /etc/init.d/ntp status
    /etc/init.d/ntp stop
    ntpdate pool.ntp.org
    start_menu
    echo -e "${Info}Timesync compalte！"
}


#优化系统配置
optimizing_system(){
	sed -i '/fs.file-max/d' /etc/sysctl.conf
	sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
	sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
	sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
	sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
	echo "start add script
    
            "
    echo "

fs.file-max = 1000000
fs.inotify.max_user_instances = 8192

net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mem = 25600 51200 102400
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
# forward ipv4
net.ipv4.ip_forward = 1

">>/etc/sysctl.conf
	sysctl -p
    echo "
    ${Info}suscess add /etc/sysctl.conf script!!
    "
	echo "* soft nofile 1000000
* hard nofile 1000000">>/etc/security/limits.conf
	echo "ulimit -SHn 1000000">>/etc/profile
    ulimit -SHn 1000000
    echo "
    ${Info}suscess add security/limits.conf !!
    "
    read -p "Need to reboot server ? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [[ $yn == [Yy] ]]; then
        echo -e "${Info} Rebooting now..."
		reboot
	fi
}
#更新脚本
Update_Shell(){
	echo -e "current version is [ ${sh_ver} ]，..."
	sh_new_ver=$(wget --no-check-certificate -qO- "http://${github}/tcp.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1)
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} someting wrong !" && start_menu
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "there is new version [ ${sh_new_ver} ]，update？[Y/n]"
		read -p "(confirm: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			wget -N --no-check-certificate http://${github}/tcp.sh && chmod +x tcp.sh
			echo -e "this version is[ ${sh_new_ver} ] !"
		else
			echo && echo "	cancle..." && echo
		fi
	else
		echo -e "it is latest version [ ${sh_new_ver} ] !"
		sleep 5s
	fi
}

#开始菜单
start_menu(){
echo && 
echo -e " v2ray install controller ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  -- by leejungwoo@me.com --
 
 ${Green_font_prefix}0.${Font_color_suffix} version check and update
 ${Green_font_prefix}1.${Font_color_suffix} V2ray prepare
 ${Green_font_prefix}2.${Font_color_suffix} V2ray timesync
 ${Green_font_prefix}3.${Font_color_suffix} V2ray install
 ${Green_font_prefix}4.${Font_color_suffix} V2ray reinstall
 ${Green_font_prefix}5.${Font_color_suffix} TCP-BBR add
 ${Green_font_prefix}6.${Font_color_suffix} TCP system optimaize add
 ${Green_font_prefix}7.${Font_color_suffix} EXIT
————————————————————————————————" && 
echo
	check_status
	if [[ ${kernel_status} == "noinstall" ]]; then
		echo -e " Current state: ${Green_font_prefix}Not install${Font_color_suffix} Acc. kernel ${Red_font_prefix} Please install kernel first${Font_color_suffix}"
	else
		echo -e " 
        This System OS : ${release} | version : ${version} | ${bit} | ${Green_font_prefix}Kernel : ${kernel_version}${Font_color_suffix} | 
		BBR is implemented in kernel version 4.9 or higher.
		--ref 
        Current state: ${Green_font_prefix}istalled${Font_color_suffix} ${Green_font_prefix}${kernel_status}${Font_color_suffix} |
        Acc. kernel state : ${Green_font_prefix}${run_status}${Font_color_suffix}
        "
		
	fi
echo
read -p " please input number [0-11]:" num
case "$num" in
	0)
	Update_Shell
	;;
	1)
	v2ray-prepare
	;;
    2)
	v2ray-timesync
	;;
    3)
	v2ray-install
	;;
	4)
	v2ray-reinstall
	;;
	5)
	startbbr
	;;
	6)
	optimizing_system
	;;
	7)
	exit 1
	;;
	*)
	clear
	echo -e "${Error}:wrong input! input number again [0-11]"
	sleep 1s
	start_menu
	;;
esac
}

#检查系统
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
}

check_version(){
	if [[ -s /etc/redhat-release ]]; then
		version=`grep -oE  "[0-9.]+" /etc/redhat-release | cut -d . -f 1`
	else
		version=`grep -oE  "[0-9.]+" /etc/issue | cut -d . -f 1`
	fi
	bit=`uname -m`
	if [[ ${bit} = "x86_64" ]]; then
		bit="x64"
	else
		bit="x32"
	fi
}

check_status(){
	kernel_version=`uname -r | awk -F "-" '{print $1}'`
	kernel_version_full=`uname -r`
	if [[ ${kernel_version_full} = "4.14.129-bbrplus" ]]; then
		kernel_status="BBRplus"
	elif [[ ${kernel_version} = "3.10.0" || ${kernel_version} = "3.16.0" || ${kernel_version} = "3.2.0" || ${kernel_version} = "4.4.0" || ${kernel_version} = "3.13.0"  || ${kernel_version} = "2.6.32" ]]; then
		kernel_status="Lotserver"
	elif [[ `echo ${kernel_version} | awk -F'.' '{print $1}'` == "4" ]] && [[ `echo ${kernel_version} | awk -F'.' '{print $2}'` -ge 9 ]] || [[ `echo ${kernel_version} | awk -F'.' '{print $1}'` == "5" ]]; then
		kernel_status="BBR"
	else 
		kernel_status="noinstall"
	fi

	if [[ ${kernel_status} == "Lotserver" ]]; then
		if [[ -e /appex/bin/lotServer.sh ]]; then
			run_status=`bash /appex/bin/lotServer.sh status | grep "LotServer" | awk  '{print $3}'`
			if [[ ${run_status} = "running!" ]]; then
				run_status="running now "
			else 
				run_status="not ruuning"
			fi
		else 
			run_status="acceleration module not installed-ls"
		fi
	elif [[ ${kernel_status} == "BBR" ]]; then
		run_status=`grep "net.ipv4.tcp_congestion_control" /etc/sysctl.conf | awk -F "=" '{print $2}'`
		if [[ ${run_status} == "bbr" ]]; then
			run_status=`lsmod | grep "bbr" | awk '{print $1}'`
			if [[ ${run_status} == "tcp_bbr" ]]; then
				run_status="BBR启动成功"
			else 
				run_status="BBR启动失败"
			fi
		elif [[ ${run_status} == "tsunami" ]]; then
			run_status=`lsmod | grep "tsunami" | awk '{print $1}'`
			if [[ ${run_status} == "tcp_tsunami" ]]; then
				run_status="BBR魔改版启动成功"
			else 
				run_status="BBR魔改版启动失败"
			fi
		elif [[ ${run_status} == "nanqinlang" ]]; then
			run_status=`lsmod | grep "nanqinlang" | awk '{print $1}'`
			if [[ ${run_status} == "tcp_nanqinlang" ]]; then
				run_status="暴力BBR魔改版启动成功"
			else 
				run_status="暴力BBR魔改版启动失败"
			fi
		else 
			run_status="未安装加速模块No acceleration module installed-bbr"
		fi
	elif [[ ${kernel_status} == "BBRplus" ]]; then
		run_status=`grep "net.ipv4.tcp_congestion_control" /etc/sysctl.conf | awk -F "=" '{print $2}'`
		if [[ ${run_status} == "bbrplus" ]]; then
			run_status=`lsmod | grep "bbrplus" | awk '{print $1}'`
			if [[ ${run_status} == "tcp_bbrplus" ]]; then
				run_status="BBRplus启动成功"
			else 
				run_status="BBRplus启动失败"
			fi
		else 
			run_status="未安装加速模块No acceleration module installed-bbr+"
		fi
	fi
}


check_sys
check_version
[[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && [[ ${release} != "centos" ]] && echo -e "${Error} This script does not support the current system! ${release} !" && exit 1
start_menu
