#!/bin/bash

source ./ENVSETTINGS
APTINSTALL=""
cd ~

echo "Docker ..."
if [ ! -x /usr/bin/docker ]; then
	echo -e "   ${RED}not found${NC} - starting installation!"
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh > /dev/null
else
	echo -e "  ${GREEN}OK${NC} - already installed."
fi

echo "Docker Compose..."
if [ ! -x /usr/local/bin/docker-compose ]; then
	echo -e "   ${RED}not found${NC} - starting installation!"
	sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
else
	echo -e "  ${GREEN}OK${NC} - already installed."
fi


cd ~
# git clone https://github.com/jitsi/docker-jitsi-meet/releases/latest && cd docker-jitsi-meet
wget https://github.com/jitsi/docker-jitsi-meet/archive/stable-5142.tar.gz && tar -zxf stable-5142.tar.gz && cd docker-jitsi-meet-stable-5142
cp env.example .env
./gen-passwords.sh
sed -i 's/#PUBLIC_URL.*$/PUBLIC_URL=$JITSIHOSTNAME/' .env
sed -i 's/#ENABLE_LETSENCRYPT=1/ENABLE_LETSENCRYPT=1/' .env
sed -i 's/#LETSENCRYPT_DOMAIN=meet.example.com/LETSENCRYPT_DOMAIN=jitsi.thomascarduck.de/' .env
sed -i 's/#LETSENCRYPT_EMAIL=alice@atlanta.net/LETSENCRYPT_EMAIL=thomas.carduck@gmail.com/' .env
sed -i 's/#JVB_ENABLE_APIS=rest,colibri/JVB_ENABLE_APIS=rest,colibri/' .env
sed -i 's/HTTP_PORT=8000/HTTP_PORT=80/' .env
sed -i 's/HTTPS_PORT=8443/HTTPS_PORT=443/' .env
sed -i 's/TZ=UTC/TZ=Europe\/Berlin/' .env

mkdir -p ~/.jitsi-meet-cfg/{web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}
docker-compose up -d


	
