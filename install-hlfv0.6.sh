(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� -Y �[o�0�yxᥐ�p�21�BJ�AI`�S��&�Ҳ��}v� !a]�j�$�$r9�o���c���M;�� ���������u�]�w��;EE�&���۽v�[�N�/� ����I��� Ԣ(|(�ս��OI!�P�K�ޮ_D�Ȇ�t��5��Ԧo  ��@	lw!�.t6s��#��S>]��^�ɷz-�b�"���G/��>��H���l�O|��Q4�gײ�k��9�C���kEb��LF�ֳ|G�EK�iȿs!~S�<��ol�	E[���E�Hm�oV:R5�\Ȳf�cM����Pǲ!���Z�Ռ$b�P�sc���I�8.�0��s��܊ȭ8HQ'��|b*�JVc�z9���t< ɫp,>OM�T`A�*NkxFo�U��6B�GKmjܕ��J���B��(6K�;ёWM6�ǻ�ӵoI�62����\C�-ׅ�4mЈ\C��h�?p ��L��i�&��VU<�LE��4>�߿�еv$�S��W�/�K�j��<�,���G�l�ꤊ#u~3�H������ u;�}h��Y���0�K�lݗZ��oy�؏��S�#��~�
o��7����^�~���V����4�6��!�\�qC�dYnT�d��-
��!��:��6��'_���Rq=��T��q��+�bU�B7�}�Pl�,�"ϗD�O�X$Ϲ���B�s�yS�-�CY!�&�Q�-?|��n��W/�O����`0��`0��`0��`0���O*�� (  