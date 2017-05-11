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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� -Y �][s�L��k~��ݼ��i��j7GQQADq׮g� ����CM&�I&��0���LM��iX�V?�{Ѹ�.^E7n��!��S��i����$���_PEH��C9'0�K����<�:]�I��%MW��G�,�^���3�G��'~�NB{1�۫q�H�S\.�R�E�'����^�.�?�!]ʿ\(׾�\!-�!��o��mF��9^L?�S� ��O��g}AQ
��T��Ԟgx�E��{/�_�������1%Q�q(�%\���"��� p���G	�X�
p�G(����p�.��~V�r!���Sě�'���G�������8QVZ�����b�!Z�<H��<�DQjݔl%����،`��"4Ǟ� �z:�er6�fuj�H����U	�X�z���@4z�)5�F��%\no)��(�C�  vo7-��K�!�V7����'0���d5�(G��`(�t�*�b��}�+���.�w��?�����7���nc��s���(�?�F����'�ϋ��H
��ͽ�+
�0xx|2�����X*Qж� `	K �����-�����p"6!Le��Dn��n�=й�e�5��5r�����k�/n�	��\C0�1'C�\Z[�loa�V@�T 2x��es7�;��ݪ����%��&��j����;7w����|)C��=ث���XK��<m���ԉ�=M��-��Ӊ,3�Pu5�c튘ł����9�s泑�[��y51Cs�E���>r���Z�I�O�vj��S9�x��Vm��b�_�̝旷�����h:iw4�����X帬�������,�-b�Zt-I�s<�	��%ơ��FVϛ���R��6�F��ߙ�jq�7� c=eOp[��d���iF���ʄ,���b̸��@ �Cᚮ��y�V�U~*C��yB��9�ku�X���ph(AT�	�v��P����t�\�%k�=��˅:�\Aت�����)��۪�����6�i��a�q�"�)a�l�q��E@	��ھ�U#3i)�h���'�Ooֲ��gim8Se��dy��[S?�����&/��q�,��
����x������I/�_>R��7/���<\,=L��/ ��I�������"�I���Xⷠ�_������_J����K����?�����5��'ђ��?��Sx��>G�_�-݀?E��]�����8N������k��v��6l ۭVx7��٬�d��?R�#S�psUK3�?�fY��fo/j~���9��aRj��9&c��*��|����a�Z�;��{К8�G�̏^�'����7���GC�UA�����BT3�Ӕ<M�}��iY_�O������`?4M<s[�_����_���#����f���	)�"i�J▐7��v�M��]�V;��h�[ķ&-�]I#�t*�0q�Դ6�S��]I$�]�n+�#L�	���?���21ρN\?;�x��qZ�v���0<�J�3��XIW���t���?�� ��I֫��5��J�lޥW��k/��4���Tj�^wLfJ��;���,�I.Wzu�w;��iʲM!��!Z�
�d���������ߵ_c�W�/����I�%�GJ�_>C�������5��h�[���r����/��?��O�]n$������R��"�'���I�.���gi�f�ň��ǶI��)�B]�B<�`Y�����w]7��%r>��6˰>Z>"X���;�����p/��)<��Ft�KD�X�Ř������m3���RC�l����M��Q��%簺��\��@7s�8��aoW�y����^��!�n8�6�j*��rt_�Řݛ�zX>�w-�����/_����Ȓ�����r��/'\,�P���i�_���	��E�2���	�J!���o�%��16��������Юoh�a8�zn��z̰J"��H��>��,IR��/ ������-��"p���b¶�/�˖jy��9�5�&k{�9Ҳ]��{m��(3Rx��C	��YԬ�jB���7��^d�� �=ц�<Ì��p7=��sD��s?�̳A���=n4�L?�RjFm����������������O��Q���"�s�����B��I��0}�gͅ��u�E�g���
���Oŕ�ﱟ�qZy<�~ָ��5a�@?�i��}>�VC��}>�
:.W?m�.�P�Kգl�X�*����d6A(M(t���P�(�k�-qN�^���t;�Ȅ�嘑���5V���5������T���$c%�[\���+-4���AToO�v�Z�d��<�q�698���\<�ә�y�\����4<�TXR�q�7khǵ�6�+��1��L�Ak����nm�dd�h�U�$m��5F�t�4��!�Ќ�@{����5�xO.b|[$����1���ޜV��]��׬�mdJ�-FI]j����y����4��Y�'��M�Y'��LW|X���{�����pp�t��?]��[.���׎��_�p����\�/�$��6|9������-%���%)���E���%�/������om�p�+��\�-$�g�����=�1+��
�{�8��g�}��L
�M�G(L�LV.@�q��>��&<�?�C�f	��f�M����O�FFm���xT팥�5�z&h�{����֡�c��$a��:�9^g�f�����6z���@M�(���\A:,S�h�x�y��ǽ���[�b��ȜpĮ��3Ԧ�*$�waATf\��7�Οf���yo��"��]�i�K~�7�����B6ڬ�u���ZsaOԺ��==�Z�l%�#JH#�R6P8K���!�@B�<���/�W_����9~������.�I�|�[1����0x������_J����K�����d��z��W��(Y���?!�����Ӿp|��|�c!��'}�p�/�l6�t�"����4e�"����Q~�d�b4�z�WF�.!�w��+�R�����FG��MM
�Y8�XOh-Ҧg	].g�@޻0�]������ߕbl��ab4���fj���ޢ�����k_r̩�ȸA'�����S��������F=�j#�v�P�q�{5~A��O��)�
�/��3�������������)��_9�W����W��ό�)��B�A����?8R��E�������B��Zc��-��jC QG�����0�~����������~z�WIy���ö�е��>�C�f���2MWv�4=D���o��7P �{�-���uB��2NMt��較�Dm�V��Lwx����h#!U#���^"MD��6ծ2ۓUH)n���Dы�/T��X�A&�ǡ�s
�9D���9�uMSO#r*C@�I\�g���ϫ d�S�Є�L�@�5��]*J�LWJ�N�pj�x'��u��1)d�X"�~t�i=���N��r~K}0�mfoB
���a�s�f�V6�a��lEts����ί���D��}7Q�Z<�/�h�Yv!���*������d�?3��\�+"�ψ�)��TJ����K�����d�?3��*��"P����?���4B�����yNٔK�(M�(M�Iظ�9���Q��HsmǣHE�����߅"���-�%���BpA���D�tT��95��,	�e���6[0R�&?�7�3Z�NhA�3Z/&��2��Zx�;��\��q���������c�Gq�z�<'~J�@��`�[�������A��lƮ�~�*�F��xn����h����B?��I��k�2�Eܠ��-rc��}���،�h1��S%��ME���w<���U��\��Zo����(Y��u��FH�����iyǝ��k%Un��?�uT�]Un����T0���w�|6>Nl�*�ǽ������+7N�o���7����x�[��f��������g���~/V�x�'w{��
׾{��ܿ��~�}�[���o�uA�E�N[��wM�k�- ���~Cn���,}��*]U4jm��A�����+=�t�V[x�EQ����r��r;�vc�<h�ݎ"|k�~�y����/[0O�w�Y�������k���ڳ��=��I����V��o:�������'�,?��A�~X��n<�~��We���y��������4������E�t��q�G�
��^��4q�p�����d��nϤ�ݪ=M<���D�y����K�~�ϊ}�;�^��i��O{�ͯ��c�;��P�"���u��ŷ�N�|�E�=�{` �˶ā�m����ɦ���i+-��z1�~�ax�+xc'p�^�'&u�>U��/;b�os�~���Yy�m�{<8��˓�����u�*�k�u��k{�j��ۺ,h�s��s�8�u��o���8·'��9!�&�!���1�?*��`� ��L�4���&�`�c`;���$����`��������}�~��Ǻ�J��4DL��Z<&��(�$Ã6xA�@$�F/E⁐S�m�8Ơ:���"��Υ?�B��m�h90�ʨXti1 k��f�j�M�9��m�C�G�`�� �(e�RA��`�9E��j��la˪�b���lz#Y5�(���X������u����4eU7Um���8#5V������)�<�H"9�!���H��U����ҥ"Wbڂ��n紓�4�9�kZͅQW�Mi�<"�*��@�t6V{qֈ�;|�1�j1^j2zE��5��%�C7N��Fh�,GS�����0�E�e�6�ȵ���F&��pzmpꚃS�������+�~ЧS�D��u�wĎ�_h
L��Ķza��z�������]��{X�*���n���4��_�2�#t4���P'/Z5f�	c�b�����Xmʣ��=�֋3�LY*��u�6Ij�D�[%���J��օ&HN��B�M,��4�NQGG� �U�J3BB{/�I�
Y猋?R.�T����E�j
b?�T�dE?�f��4:b����?%�{?�e�ֹ�iזmؼ�dU�1�)ڃ�uA��n�{|n ���WR?h�?�1'��IЧɌn��,�O�
�긴���ӭr�'-q�6'+�xh��'�
s�����K���kѡ�>.��ƅ,�����9++qE���
�{�O=��oN�.�L�����UHxD�]�>��cG��?�~�տ�i�����O������+/���_�a=b����
H��9l�D-������v�vO��p��t\��M�x\E����������ApH�ޡ��)W�?��ڞ>SJ|����~��]z�/��^��
L:]{��~nw��Џ�Л 0��C�<����vm��Y��g�g������H�^VKj�����;�����O�ޠ�ź�Pݬ峛�N�.Yf�t����`�NֺamQW�����b:���!��0����[1?}���3�Oʓ��(�\�T��Rxd�`{0������L�a���L@�,�16����j��n��q��^�D�:�꧉tv�F=�j��������F�ı�z�cB�7�'�4SkwZ��g)O3G�`��)�\/N'i���r����d�6l�z��%��~����G������RM�����e��h�����ok���ay3'I"�0i��tRR�	G��j�Ga>X�mG���wx'&4�1���$*4p��b)��J��K�����"���	E����	eW�1��O��M�w'��)Q�Έ
�f2��8%�Z3���Ш�G6em=ڰ��[_-l�\r<�`�m^�6�#��ܤ$��Q�W=^�l���(�p9�*�Ȭk���^W����£��c�N!��(�,�ᬈx���p�d0�\2��Dn}�d���s~m���d��&՚	�x- t~5�xqo8�`+D�	���`I�|�H��|�:�:��h�+w�6�Z)��J&1�׏U����ƙ�:��d߅l��jy��-4d��k:\�*�D,�s}��A�G�i)T�]�팶�*ù{�\k=�d2/�"���숰���Զ�"��k����59M��a�.08��B�͒��q����J3�c^@9K�-�HD���o�l5$�=9�8��u4�ESi�w���in(QN��d��O� 1|o�J��X��p�{Aا�������n��+�CV�X��>����b>����8U�V��P�pG]�:��Nmn�LĚq�خ�8ǠÖ����J¡.f2��U������_e�,I��Q�M{b=��<�υ\-V�D0����c���K]ͺcl����m|P`�F��K�=�h�\���U�1ņ+@���~	��ޔ�	tZ�
T��g�%@�4튥�DC��)��٥�BJ����иk@�r�ҍ#n�d�����t�Cu��!����l��"�hϻ�x%*���T=�Ow3����{l��c��U��"e�-P����R݅��h���(�,�i� �n�a��G�������*d<N�݌s\�dφ�ǚdV�l���/1��B�~$(��0���)����~ s��F^g ��y6��)��٥���΁��u7�ң����t����Yw��38�r&�v:���nĸ�� �\x�'�%V���ˑ�:�@2Rf���;"�v-���XM����L�mw>��aL���Vܙ�*
'��G��+�5h:��=�r��q��Gi������E��o��*t|�����S�SWk�����Ⱥ�V��Н���V����q\���AQQ��}�t��X�k*� +� ��aL!�ɊT�_f���TW�p��k�m9�or�*t�EA4D���>�De�AwCGW����/"�/_��i5&�4t|�v��4d΃^��f�JQ9ttL>b\����fȌ*�e�Wq�q�ρ�X���Ű�+�� -������5Dh�eQ�^�ɐ: �C��>�o#�_q���a���U�U�䀘��C��
����m&������s�i�q�Ʊ�k�xIA��N�=S��Q�9&�-�>�.[ �g�0t�*xf��1��`��=,���}��G������ò�ˌ��"i���$��#L-�/F�|��H��z�L�s���/E��^��`����pT`�֔e�����������To�=�h�*����"Q)+Q���$�o5�(썖�d�Fyx�7;\�ɔ���D�3���=	�sQ�����LC��B�^�!�X���0Hv:��T�\�SHG���(E9Rig:
�r�:���Q,D�����ˊ=���t���E,�L~���X�zI��ԛ]�3�B��T��M�S6��3'竹T���D0[��#xl_<,�8L���Ǟ��l�oWN�}�N�L�]��v��E�m�8���|��\�4��"�Y�-�����Ĕ��(���'˜���	pl��k�����b/��P�C�'H��t�w@pW���\U�z=A��7�0�]o<���7/��i�~�[�>��?�ҫ}�ݏCG��}�&�7��f�ٲ0Q}��ؑ��:��?�-��yC
��Y^x�?}����џ���ɣ��N=��S{幯�H���!��!�||'�����W~�sE�*�<L'��5��[����Ǯ|��{���X��;�����=�I���'
����e+��,����iR;Mj�I0i&��|�{���5�f@ڤv��N��i�l��v+P;�̷��|��{ U���q-�0�3uN��]D7�b��[��:�c�[ȟ�<]��&��<ӭ3y�T�U��30��4���3���5�n��p��N��,�̜3�j�̘ifZ��3c�i7 g��}�!�Fd���0�Bk��m^_��>�9��_jL�
�m��,f1�Y�r˖�!qc_  