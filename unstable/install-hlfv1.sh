ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
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

# bring down any running fabric
./fabric-dev-servers/teardownFabric.sh

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f || echo 'All removed'

# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh

# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
# docker exec composer cp -R /etc/playground/creds /home/composer/.hfc-key-store
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �A:Y �<K���u��~f��zVF���٭�L�׫I}{&�0IQ�VS_�;��)�$Q�H6I��cl.�����)G���$G9�-�1� �$�)@�KA��������q��Qݢ�^������>jk� Iꚉ�"N��6R��ӡr���h4�|�����*"��!����EF�d��E�A��i��h@x�2ıl�w^��h#Ô5�!�K��D�X��� �:a<���7�e�Tq�.[�Fy(vq]o�#CA�.2����rAuͰL%�x7Nĉ�ο�nRǲ��C�Z 6��e���璙�C�����'�m�G��j��$�`hYA����S:bː%��=�MPî�+=7[p�#�3��y2%C�`�D@0�v�cr�8��s�c�t� M��R�4Å
��!ZJ<���H0]�-L�6���%�� Bq
HV�� ���ь62���'m����od(�]C��s,�h"u��q<�¿�������x�z"�T�p��r
jhꙄ�7�$_.���Dg���,KǬJ�&�a�'z���q
��^AZ:!Ӫ��V��`"�5��&G��e�	��Y]O�B�g��X�4�1mYT.ib��ne�xry�R���I��'Y�f\O3w�?A��,�˺7{6�ߴ_���I>�F����z�8'��p@?#�;e�c�'�a2J\��7�ɖ���-�o!�hk�J+J�����k�p�?r��S��?�R�SCR���*ʭσ-Y�D��-���4�T7)�VO��@V(�mh��6F�Ac����=I
M�섓��}��������BP7a��>�;�	��~^ _��珡��>rP��#��A�sp���i:~�P_� Vؠ:Rǽ{\>]̠#c��:qq�:u&��3����5��E��G�ɥ �U��Y�	E��XJ�qeV8az�X�uٝϼ��eL��+L{���ܳ���Cm��=U�`�ܒ�:z��c�}�+����i�2u��"�98�|r��a�iu<���m�^�~�.��G��vrxok�qj���<P(��
MM��Wh�d�57s�_B?����\�w�+l�K��\�~���>�#��PV�i�#x�/��0�[�C��L^6	�wM��-��G�N 7(/=�<:��eá�l��)J����Iyve�l���y����^Ή�IQn��P��:�?Q"���WQV㿩�	a_uJm��-���㾜��Y9_)���0x��܁���O�g��u2ŝ��*[�Iߘ�����Ttg�WQv��v������޽�_I����]����a�����?D��,���U�7o��V"Sz�
H�-UBY��(0�ԑ'N7���#^2�����-�/H��bo�3�:����"����Ք]����?��7D��'�Tl3������)�I����Ω+og�;�;����(��<�V��)8&�[0e�-o�fd�5�di��j& �3�ge��)��}�w#�?����;�wo?_~q�a��(����I�)e�gU�T��s{�'[f��5 (�p������9:�X~�\���h���l���x��zf�٩<�oY�K�3!�s��p6�k`�x'#��d��������1����	���?yB���vO�a?�O���[	?�	�m ��)\nG�Kg���4�P[���/�P��-)H:}��3�M���ź��.�Si3��T�_�"��Ķ��y�>�˟�������U�����p�������?��	�$w����:����8٘*!w��U���_��5�`ô 2��ꆌ�:�@�p(�lb88��/������	b����r���DNMrO��nς�%8���.�y2����^����0�u�F�{���SvpQ��M���?��}��C�������F���̾0��Į�^-��ԡ�����#�N���Hs�v�;<�ģϢ� �O�Q�{�y�$�U:IH�B����W����^�����Q��M���?�\�����_E�����¾�6崘S�BC���±~KdwϏc.���0�r<Y�$������!�������eÀ>�m�ٖ��]�>p(4����lBU��� Q}CI����W�>o�7ތ�T�ܭ�^I�����������bߑmgĶ(/��7sK���`0Yu��kO�&�{H]�iq�c)�/�q�#��5�?VDá䭛~魄o_4~L!��V��n�z�]�u&޻��3�I^��	�mÀ�
��؅	./�:b"K
��
W;rך�`�����P���	�0u./}�g�uBx��]��������F�6-�I��M���^:�5��s�'/�<V������o�]��i�@���d,���y%���j������~��
9�}��?����+*��G�9�]�����??����.g���Zd��a�s@�r �d+�ub�oED:#�V��!�H8m�a)FJa)$�a��]	��Z�����?��N���y���?��g?��?��:�΂�7����|��<���������W�\���g7��S�m���O}����������0\*��,W2�K�[�L���,K��.mg���{]��62Y����	���>W�L�&+��}�
��CH��isF�鞔�����v���5���^קk|�hs�F�Z,&@���Ұ�H��T�|�i��b�ǩ2>��\�e��6����d��1f�GDAg�*l~/l�L�I�FӽZ0�N�I��b��v�*͊R�*kd���ٕA<Z�&�N�x����g�P�ܯ���8ۜ�1A����Cw�,]��,b�KD�a\������L8)�|'���=MJ��3qI�.6xF���`Ok�124��D��
�)��z7Q.	Ӊ^��]"�SͰ��v�{4hT{Z̚����t��)���f��38�ʊb5�"��QЃ�H��Hd�DPk<�p��i������(��ҴYOi��}4g�N��t-T���)Ej��#<ށ�IL�g�U~�����U1&��z��2�6k�$٧+^�$$��MfR@&GJ�5��$����&���Tu�U� �ɪ�q���W�%mb���3>��O��%�"���)ߗ�u|�1ag��G�! Z�
|�����=��z�Q������5Tz|�a'i�-�٤Ш��%����t�ʍ�
k�U�<�V�m�/��36lD- �+��|��a�nw��3��ci��+�¨��z��K�X�0��!���L���C �z�^�����;g���88攴e�JZ���U�ڙY�3��F���@�9�t1�窬ذ�k
�F��68�N�8]�=X��A���c �nQfX&WV%9Y��M!���� _H�:	z/yT�Dƅc�ƈ����b�������t��h���+N�x�MO���P$�G�dӴ��j���qk��l��љ.�����&�V5�:����E
�l_D���8�+�3�T�T��rc9�ö��;��r3�����H��;����k%���M��٠Y��g=�$� +�r�$�B����th�(P�+-�=h5�����Gd$�L�RM��VL�]���P�W��9%	�"{9Ϛ,�F�Yj�E5Ȁ\�J�ŸF��)Ϻ�;w���g�G��`r���4��(���l�.כG�d�MŸlFh���^.�%�=LPx6�:�a����Q��jJ�\��~"�S�7�,�R��rH��*�i��l6��ǒ���l�r)X*Vg]�ڱ�P=V��4WeF�%�ꤝ�r�zA��L�(�#ĶMe+M}��V�r�B�j֕l��j���<-V鲪N)���ʒ6�t"Z��J�Y�5�(ë5Q;���x��Қ掆|�&]e��:�J�8��&�!��|J���a�Y�k�<��z���t��U��6e�lQ��˕�eI�26*fI��-UC�$A7��M�PnF廣�9��j�H0��R��̌�����q����͎x4��CGf�A(�u9e�zyY�LSt$d45�����TnJE�l ����,��^02�Ƒ}(��6�n���o�c��n%"�(�B���E�7P��(���CC�X����Y/%�{b3ENsT8_�/S�.g��l���b9������3�!�A͐-d��{�O��w�w��>�|��������*���'�İ?\�s���j��Z%UB�U�K���9�.#ZR���Imd�>�} ޣ"��\����]�v~�SSdi����c�}Z��nъ�U������Jȴ��{3}�WH}��5H5G�0Ց��}�)��>t�)�3��=�w��_}�K򓯾��a��������o�����w�0��ga�**r�������a��ӱ�o)�%̼bf1�g�������X�������,���x����&�T���w)}~�' ���5�?�-��[
��>�V^����n����	��K����/yn�N;�[�/Bw�W���/����TUn|>N���d�L�/�6`�x����je�	<&�h���"�4�Z�������0?�s*9�p�)h�"}���Vԑ��Ku��m�	^���4�,�9�������U�_��	!��28l/밂rG�p�Lc5�Xp�Lc�����}�{X3��q�0��?��%ƕ�,'(BC����"5���b���ᆩ�]e��~CԔ���v�.�K�6,@(;�)�d+$X��(#!�H1l`T��v�_��.פ�wu�}�N=|��������x�HD��Y%J�-6`bZ���YV�U�N�C/�~�E4�Ķ�Fu����
*��~�Z�K�r�n�iG�R�ʂ7T�Xveq%>��6�Yց��j^�b|#��֭����-�l7�A��T��0#�2F&��b�XH��Z0j�U�f;�$�D��Y*�pE"����?��6�Iڇ)���(u"���Y�֜%\�����x4��J(���H�q�-ȚT�;�7.����SL�N�x ��ȕ�����zJ�/�(�o���Z1ٽb�3=�
t��}p�5��;|����W:�F���հ�w��[���;����5,,x�~z<iD�;��S��4Z�p#=����͙����:G��=V����m΄����"��X��歠�Sd��v$k�;*Kg�u_��Ɏz����ɦ�s>��phs�q�QaѬ4Lp��4KrI0(YL�pGt1�l{����%ùj��&��$�w�!�}!бΐ+_�P��K0T�Nu�ki՞9���O�D�(�2�*O�(nfx��&���x͈�n��c��(�,��1��i���"���l
M�
2g�AD5�vyVbҢ�LŻ\D <�EM�֮c��4�!�v5���D����	�Q����{�R����]� �׃\rp���
zw���&k��2<?M��d������S���G�3���8���ڗ�/n�zg}S�۰���읝���l^�0�zj���j��~T�������Ϝ}n�澂��]?����$����~U��O?��w�����������9�F_[V���Sǻ����ϱkۣ��z�k�2^��g���__�M����������W�V��������=���?L~��?������A����?OB�KB��h�ݷ>���[��}�_u�7�V�e��w���$���k������o�O�Ϝ4?��?����[�8q�/���	����g��v��v��N�	�@� ���a��i���� ��v��la�<:�2�x�oT��0P����cASZ�tξzS@���'}2��n������7�>�	M���3 j�3 S�`*� � �q�8�G�H>"j �`������2��4-�fx[���, , kf�p �`��#��>b	L+s���n�#\k�|���'�|���m�}n� �8:��0/�ϸ;�E|����q
���	��~��������w��n:����!˭��k\<|W����ikd��%/����$��K9�Jo�Co����t���=��H��xyl�?���i�i�?�~�U2��Wޑ�~���w�0-���^��T��p�=��K_���Fs~�}F#븮�h��P�2�:�к�Y�e`8����(°J",��Y�BH�Ei�$)����Y�5�_/����d�~L��g���kX�c�گ����r2���.X������u}�7`���_x��rs3���Xuc���{�����ڷ�9Q�I�˘��r\�2��R�Ŝ�ϿA^/��Z���+yU*�i�߶��*�z�6���Q�lZ���z��o�&N�-���?x��3�����d�ҫ>)y�U[�\zG�LN)y�dB�>m�u6O�=��%��{���w�l#ow�-�N.��7ﾕ���_=�X��߁W�"G��vK{���=�xzޥ�]���`7�6n��H���8��;�� n{��e�݃ט���*�M$���C��tнb�l�~�>a\D7�����7<r�Gz�]V����<u7ܶӭ� �sҥ sJJH�ҥT��bA�l����~ٔT)���ts�pI�dF̤�T�ͤߚ]�0ܴ�1<�F�h�_+F��]A_^���~�����?��6��/��d����r{,�4�n(�ҩ��p�fz�����X:�W2��\,)q����R]�����o�ե�Kq�m��y��Ĵ_��˛	���D��OAw\|@<�W/)�;\q��&���²�]��w�p��x��&��r��n���F�j�#���]<�r�7�>͜kβȒ��e�����������.��Z_��{���������ªy�P(�s	Փ�7��0-m�J����}�6�����Q����L��w)�?����R{�/ğ�>�P��F����6���,�a��o8�����q[-jͦ��l��t��MZ6���v�}��z�S@���S�N���b��N7Vzک3�h��~�<����D��
�����g��8�ah� ������g��(�b������jx��q|���������I��H����qy4v���m}�AIz�/ (J!�'��}��i��m��*w���(�[����S�Z������4B ���9����;���#a����������N��4B�X��0��(��P��Q�b�$���"e"d�DM�"L��E�(���y�<Wg}a��o��E�D��;��$A�s��p��T]���u��J�� ��iF�%��J¼j+#<kM�(;�w�R
fT?)��������Ŭ�mpR�U�
�݄�J��)����2�J�c'��F�9>b�r�9�"�BcVT��(ږL�:��(�wSfO�Rt�h��웝�/���SWtH�������v�_����7�`����?����IӀ������`iթk�e"�J��!�S�� kȚ�fܔ5�Ԓ ��4zh�c@����6p��������0�?���	����T��w� N�P����?�� p��/��i�{W��S�l�rb��g��@��9]~�;�c�G���O�:�^�z�����\�v\ɭ��J��E.�ogˡc�˯ϖC��Z���8Wl,M���V����������x6��,r'q�b�w�S��k�*ǹ�U��6/d]��X���;1B�ꝱb�G38�u<�΄x�$d[��VQ�T��w1�rn�SqjыyUjrmMc%H��1^�p/J�H���X>�yN�;7e:�T��l�÷�ܼ�D��Vy�B�0�)�<7�o�_G�?��A��?� X�O׀�. ��e�a�=X�C��� p���aA(�0�2��0���_�? ���q:�����������P�?��q2�� �G� �������8N���I�N�aX��z�u�H��[g��,a��u��:�Q�����z}�5H��x"�����G���8�%�Q+�6*Y�S}'iT�<�/r\l��p~�v�[����&�V�h�b�@.e�)���~\-G�2�N�h��1�^�G�J�s�S��>>���9N�-̢*ĚM���j���E����tv��?�`����?���'�
����?'���? �����@�{~���������0�?��q:�������
���8������3�:���$a"�f�c�C=��n��Ol�o�C�k����*��ޖ�r�+�}]i
U�*ϻ)���H3�3hF2�h���%./�;�:�#���$J�r�v�Ff2a��"�\�P�Y���Q
��.\�䰟�c��&l�O�¥�f}���vɷ�y��3���{���Uv��C|�(��Dny��J���ȍV�U��\�!��A=�p�&;�^���2���B�EI��Ÿ��dx�S閴��N�H)��G����by<YІB�\���]��l��t��s�d�M����fӕb�!(r���u)�$R/�V��F'�qQ�#�
�C�.Ƈ/�޿�0� �����������_���8N��`�?,����O0��������<�����;^��0������*�@�=�h�G����? ���@����?��!��_x���`4��뚎��(������Z����[:�"K�$�"L�E,�4Y�fI��@��gG���wS��;�� pD���HK�p8L�U�\+5�,����fԣô���"�tI���(����NFhuD�Q�қ6m��ֆ6D$[�{.V��	}Z�3ź�3"RZ�8$&�V1��Y1Jf�C�.5��A��G�Sʿ=2��u
�������_ x���:���{|��(���a�����_O����w�R����?����??B��4�O������+�" ������!7��������89 ��?5���������FhaX��X�^�4Rg4��P�C'X��2h��u]�pg	Ʋ��2������"(�?n�������M#9�6�FU	mTAP�b$��F=��g.����Q��:�;,҄���>��l.���͍D:�H|�k�-"�C�)��U�UMF̑'�"NSG³b��3����Z��>a�1� �����O���?��� ����C��8	�?�a����`�X�������_������_	��!l���*���2��U�+��1e�,Ю)�6�/rkm)	ݴ��U�^FE�˯
�c�Xi~��*�J�͢��T��z�4�V+�83�"�Ԃ[���}�XJ�jޱ�wl����15V�	.�zP� q�RAͩ��ZʦH�@��g�Z���{ݦ���QnyN�\�P-�\?ެ�RKM��WK���ͤ��+�:�fjҫ����6Kۖ9"���D�Ry�0i�� ��J�#'��m	n3<�V8$3�f�Y-�B�n�����J]�O	�vQ��ִ^qYCY�\S���2n���	�&���j��2Id��U��Ή��nrN]�-xG�2�
��\U�ȶx�O��z+�Ӓ�ZA��xW�3���H4Y!�if�;�h"�w�CB��2'���5�C�,��<��xOC��I��|���8�O�V�(ڜ�0�ɋ�L�K�����Q����fҳ~uɕ��\몱h������'���v'��_��
��:������,p�P���_<��?����o�����c<��f�RRV�"�8���{��/[CYh�;�u�7 m�<4L�Z�1n�]�$���y5�����{�I��l�^�ލ�qY!�Il�;�gvgg����1���Q�=��w7X��������j����E�)H@� �?��HćE��"� ?��l)"E��#$�#po�c���3ZϮp��j��=�}ι��9u�|�ă !�B�5�/;��>�F�t�_���?�F�U>�I4��b��
�Yl�O���lt�˦�oPh0I�b���Z��)=zV<p8 ��� &�����˯��Tۃb�Ro���j�
7����F�?H;fT?�i�������e��6���+���3`TOD�<]���ȝ���1�5�������@��c��q����t_�?'�}O����[�{ �?u�����_������[z ����}K��߱�;���������(
����KR���A��I��G�sI��ߑ��t�~������R�#�;�#�|��A���N����.���4��{<����>�-�b���E�
4�&�(7%�t���}MJ�>A����D��(�e����q�l��#�}���0������h�$�4��ȇ�T����MEDݬ��k�x�G����5.�5=i����>F�|�M0Mz�5�D�
�(6V��}!\�d�:�p?�ݖ�4��q�C2�|r����r���qѴ2�"o��)�ZSV�]��Jg��H�]�(�WB��/!}�E�.�D�7[ |�e�T�)������pݐU���@�W�.0E�� ]|�h�@�Ύt6���΂}�(3,�� �j
;q�3��&�}�d8�Ϛ��6�O��NC6�}�.��[�k��4����(��MM������e�nM2g�mX�vL�qW�P\8��]x� M���fZ���^��c��9mC��f-K?JϺAQ����oϟl C<艦U�%\'t;����*P�9��[��w�~�.�Ė�������K'#wa�lńwQA����Ǵ�k��0*A"J2���7D]�Fe^�
r��r�g����:�b!	� Q�BK�]1�!�"6$��3V9�[�śx]�)�7�f�VK�k�6�����UȚTAt}�g׊�G�������h��s�\�?a����������H��ɫ�}4���Y�ޣ�� G���t\uY� �QEk�x����3��3��6�DNk\u���X�E��A���Vn,�(�t�A�v�_�I�i�h�'�A�ݹۅg�.|�u�t��w��p�7��t���S��p�>N�E���&I��/#�$��My푍+k������c������F�lz�n���#a���x���M����^^��x/]�5���|���@� +�"��G����Y�����t��f������_{�+o}�_~�����N7��a���'�#�� ����{?~|=��<�;�c_~��=èڡ��'F�,ܖ�0���mn0�����8�b-!�,�d;>H:����Γ���Ly�>	��!+`����K�߹@���r�@��C��0Q'<�T��ꍶ�D,4̳��/G��zn��V�[&���6(v��0,5ك>hG�l�2.Q�|����9�O2Ud�1Y8�Y@�`5J|��? È��j�I���)s�B28�d�� �̀���D{�V�p>W�|g;S��lJ��h�](8)ѩ�ZZ�k��*ť4=r�kR�ܯ���|),�y���щ��ۮ�9&Lh�ӌ{ط�8�p��X�W��c�:���È�r�r��8�K2���ђ�����bed�pm�Lk j��p��fX B/�r�^�z� �MƝH���J�
��kB;�C3Az��6�R�KI�_���I��m�#l�㉔R
�l�|��͎{���e��JA*lE�|@��q��^��2Vp��2��6�����~�	����=����zE��Q֟�E�|@6��a����9���Ez���n*�N�S�rH++�|���> ��_d��#d)��,���v�?b%�VM����x���:�˖�YjBTş�X���u�T��p)�d�V��\��7T_�+��Qt������*ɒYQ�h2R�4�L&}��W��d9�{"���	�*C*��!�/Ɠj����f @�{јV�#�n�Ő6����J�{өap�\:*��b7[+�ʹ�O��BS1��E��q�2<Y��#K{d�Q��Hf�!�(���y ��ֈ�RcOZ��n�^x	��E�)����a�XE�?(Z�q�����DȸҡR@Ky·,�VZV�(㥌����h6���kB�<�,���`OD�lx���}q���0)U�HF���;!>$���'Y$��-����Q�_(=4��`����.��q+ZH��Z��<t���dOC�#�92�#��&�m\a�eۦ�����_{��ְ+��#km<�}r�Uz^��'�&�C��.�YǞ\����bW9�o�����'��%���M�Y�����1���5� /�'CȆ&kjFSda�=�=�bA�-FQ&�/�gB�BN4-C�-�&����!�#�f�,�t[Ǯ�GMM�� .p�M^�ا�kk`����C^�m|>M�|q�cO�}����an����&tJ�"7�c�ƞ��W�۱��|��0ӌE��.������5F��ZL:|�e��R��jX��	T��d^�\�u �cH)�^���L���� _zz�y��:��u�����8/+��s��=�x,=�x,��!��o��`h��F���~���c�=�xl���Vr���ұHarhؗ�ł��8���c�C��p��f����8���Z���{�A��T�K'��s�JgXa��G�@�W��Tv/�웩�Rd,LF�0�챂WJ�~�	�����n��d���vel$�F����m&&����3Ѡ�C��t7f��&��p3�	�#񔬘#z��Ǜ��������ƁdV.��N�����X*���t�F¯���N�4��ФJ�w��6}�Rg{<�c��'�A\
�-c��H�DR��S�{k���	�sI6+�\\$N%�Cq8�q��+%��}
��^.�!yh*�,֘�L+� ��&�|v��صy��2�L��)ay����Z���O��<�"a9���?��U���r��T#�4Y�0�����/?
A ĕ�r��a�ĕG'r�6#�Օ"̒Rd�U��F&J��a-P�p�<�{�+XV�d���
�2�A�f��(Mg�eeL�P�{d6r��("�i�b57�@���Y�69�c4�?��FC_��U3
�ťH���9��U��Յ���z� �~_HQ��vE+FD��8�H�ܩr�")QR'_�*�Tj-��|\i��*���`�6���B6Er�B�Od�!�l�k�a��˭Ծ�E7��yV4k�j1���ӌ[nWY�ԫ]W���p���F�~<����2Ϲ���+��VRɭ�f����j�0o�1�lɪ����`�[[���0=� �>�h2��!��h�U{
<1��tۮ�s����QF�48�Vð5p%c<^߽V��*/ѣ�!��x{{h.�g���w��{�������o��/������O_î����Tw﷿�����?�����;E��:����8���:����Ў��$��������7���|�O�旱����x��z�����o�������~?�� �� ~���È߯���+z��-^V���]�q�����J��O�����W��k��3��~ā8�8�\;���>\v������v:������&�v:V�݊�(������v:������l�k��-/���9�*Wq���!�zX�M�]��>s�C��=p�g��{�:[c�9�����	�a���#�9~�)�1�:~q8�q��.�#y���pf�_,|fs���|3�h[�of�����of�p����������2�̹y��p�P�����:��Cg�{�_:_�5��䟓�t�϶&�;�+@�+�D���I�~y$�����^F"n�&��Q5��S!�۷�3:/�?Ӓ[x	�
���u�[�5-r�x51�zx��f�=S�m�&n_|/�e����N{| ٦�ϴ�]�FuچV�x��@��Ws�-���w�]��fH�23�D<I�#;p��
EU�lG����l}��IS��f�d����Ѐ��A�}7��5�5Ӑ�Ѩ޳��k6<8�E �b����<ϻ� ���o�F��B,],�e&�cR�x$��sx(�
��t
�bq&UŹx*|�j�~ġ�4L��ذ�-/�KC�0uQ��� ��J=^qI����hte��	�@�(rW�&!���uD ���vb3�| E��m�
��٪nm�ߛ'P���]^(C�geMs��i�|�m�-�+���,cWn5����%�%Q�Yh �PQ�yج
��N�� *LO���L����z�o�xh�v	S�z���&�-�i���eҳ5|Kn,�"�Ŝ�8�cb���n�����C!3f;9��zs~�L�$��dt�h%윭���`>d8܂��[��	gwE������|��E����.2�nmZ�����+x�WL6(7�I�7��G��w�F#d�D�B&��0ke뭷�<�]�p�����-{E5u��V0!L�q����H�,ƛ� �g�~M�.�1MGqLpv��ٜvx�!χ{g�i�h�#l.����h!��l�w{��6ǳ'0����7�.~�WGw ��;߀�g@���14��;h�ЃM�͞:Y���t���8f!~�B7sk3�+ʄ���CU[��^2]K�<�"4�0AL��ih ��O�
�v4u��a����6"�hݶ�;1Eu���0��v%ؚ�`
y������Y��ޓ6'�,9����ݱ{l�$@�fc�ec�m>�ML�c����[YU]���`��RVVeV���sN��f�:b�ߚ�F9���Q�w�$�"�^��h1��w%v�5|��Vi�����S���srb�$@���C������D� �lj������36�;E���S�����B�| �> �d�u=����qL�x}h��W�Wߕ��ѩ#�=+7rZ�3�%���R|���/��`sw��A_����������Fh�![<Y�?�'<��'���ϺȀ���t�������a���k%qI�D�_^��
�R�5�_@�W/�yN���}X:] Ɓ]^� л���h�t!z��$���J|��o���߳��u��ϑw"8FXG^��kɖ53%?��V���]��XaS���]ejN��`SlwEuq�	4��'�	���{hY�O`\�< ���<c��4��NIr�:0������	?�����X�
�'QTx���Tǩ���g�l�4!���;ÿwv�yH�"��\�q�ڝ� �p��N��ޱ���`נ^��h����C9���Ň�N��^6�y]/2�7q�E��/C��"��3�6/���]��Ő��7I�H���O|��X�v���~&������]��!����*<�~����hU9�'� �I]����G瓻�\�;�θS���z�}�E��`��/�_�o�q�!��a?��0����VQ�#���%2�f��g��_!�Q}>�܊G^�;���}�ѯoQ/�J�ճ_��!BD(@��!�/��Pa��{B�ר�RAEw*�'n-��	�9䅸��	K�tj8,^�`��h�]B�2K�L]b�#��C�ן����7򿼔�B�_�}�7`�_������kr����Weq���b�c5�T��Y��s�r_���dj/�o�i���vZ��T4�
O��ӊ�u�q���M��w�#)K�Uw��.�����ZB����W�ץ��؆�B��^9�k��)k\AVp'5�S��ř�����h��H(�,�<#��K����Q9��=n�o�'��.�c�(v�n�$��n�Αkqr�۟C��DB"�Iٝ�
���6�0oƘ��'�&��L�NIҖ��.Ť��O0�Ы�8>Ҭ)D����'�|���:�9CN`��#��h
Z�����թ6@������_B.R`��FcRq��xϴTń�}��>!TC��] �f�h:���
����8�H���PT7���Qwµ���y�>�J�s���� �:N�P���*��udp�h�&0≯.���O�Q!�!Տ�T�t���Dz�"����	j¥`���4�^��� U���|�>��,���3=����L�t1($!���-qx�B�h��;w4H���^ť�P���?�S��G�+�%��,�z���D��~�p$���ƛ�=�W���t ς-Y��m���P���8���jA��Odg/�Q��J�/A䒷�$c�s�F��bՔKۤe�/��_(LX�H���P|�_�&�5`�&�B/�	%p^'lRd8�G����d@����8�)W�1'Qd��WiN+,�.��MKё�C���l�31���{ȧ�F$����.!�22|���x�e�#�T���в�ʻ��\�J�c����r�h������)#7��U�����^�m��Y�9�Lc��F|܌��E~IiF"��&�	B�YMD�_�:yܐ�r��$����LI�؋���������I���W)f�
$T�fW�_�ErkrH.��,]dd	�t�kS�.��"�@�Q��k0C�VQ�)���9HFXp�o�_k:�V{��5 ��w�a��~���T�0&������a�ʟZ��ߍ�5�9���I@k.:=,�|W~ԕDL��\�'I�5�ҺӀC8�3��:�a�}���ya�)Y0�h�ѓV�,u�{�]�x��$o5�O��' )��:�����' ����d���?��M�Ʌ24���o���,�������q ���'C���-3�T��U��t��]q��H���c�@��dD�S7�����bhR,\��u�ӝ?$�>&��#�� �ܽa�3�:F�8���Z_f�4��%-��Ϟ:N��0����q�/W��]'E�f�׿�����58��bH�,�>�����L�"��s��}��5ׅ�{�Z��+��[JPr���G'f��-o%GA~���I��>
�g}���T0��!ɚ��zw��y�3���~<ϟ��2����ؔ�l�st_#��q�s\}�9���ԑ=D:�]�_�-}J�K�N���.ZE
����qn��4�O&�������Q��g�R�s�4�#�^�<�hy�X�dE`Ș�5w)���m��8x� G��E	�zđ+��j`h�˦GE�@���[��/�
@�ĳ"CC������';+d?MrV���7�j��g0E�:Tav�s���>Q�@��M�hQ��0�^�x��m��ɹyuG`�a��6t""��;��������r��52�T�J9��B2s?U��5L�/P(���a�#IA>j�WNѴJ��u@�����Z���B
E�^Y)�ˈ���=1�'����|BJ��\D�̈́���CnC�� ���=8;j+��7uV�apW~�M�"���w�}V��jx$��[H�N��dQ�Ĭ���;��M�Xp8����]"���G��Gze)b�o�\*��-k��vkwR�^^ ���;-�Q�p{��<fm��~/�4X�y��>��'ܯ����RLs��4��o��|����1�R!��(�c��W���loN�q=��?�������<�&x�(�7\w�	�F�"�����C��᠖�;#�EO����5�<�a;��,R��{`��-���Ya�#ºG���2�i����e`�!dDf�e��[� ���Ͽd����/�U-���e�������&2sh��o�*en�z� �O)���W�m>�'��>.�
]&��iH��r߸�s��h�ƒ���@����>'?)}o���'N��W8��W\��u�tʯ�1�� MH��cYVk����҈O��hA���)��~@�����l�jt��la���©�,��=��?t����EJƶe������"R�(F��f=f�
?��3�ʜk�gjD3������0��찛o��  ���(2���&������Y":]��p�*��ӴfhT]���~�a�K_��",�R~��3��P��%/u�8�[�䍗7~:}��^�Lx
v�*�-t�WF�?�[�v����l��j>��]MHV��������m�p �M���!�6�Jn`Ƕa�Y���xǃ�����6��p��"Oa��]t�
h���+�q� <^�묺B��R
�n����I_돕�LOb�0�t�.�;N��Qu�O��t����P<5+�R�U�z/f{����t	���-�_`�}@�?�ͮ��c���t�.�����������0�ǫ������?x�/S�n��ȋ�������[��2��8 �J�����N��?������y�����^$^��;y'z|��^�y�ݷ��C��׿�O�%���.2�����&'0�l��ωa��f�?�[��%-f���g���_�e��?���1���s���5^�u=-)��Q�\.'䤂��(i]+�d�Y����͋���RV��;�%�
��������tV�v�W,��jV�\i���E�J�T�F��~;�H+˭j�^筹s�g^e
�Uyq�}��ӭ�SK(��f��4��I��r�l[�O %��O�e����ջ�z;�L��}�>�\	[��|3s4q��{�Hۅ�u�����uz��z�Ү=T����^�n>g��U�d�C�&�F�Fe�����Gk����R��/�2a��e�?�������,�`��Ƕ�۠�E!"�c��X`��߽q �L�����#��B&-����q �j2�j2�jr�W�7�2�m����C�_��q@��������������/����ٜ���9���r �������_`�������u����iO��fG����q>�<ex�:��{���uW~�!p�u"*�~M@�����?���Dm��O���f���6��JMA�P�//���Z�V����c��mG6�:͋�,Q%)�zu6��^��w��B��͋�YM����3�s{��]������XO���	B��"�
H�/����:�=��V�[�	��-mY-O��\��'B�r��<�g�����Q�$�*r��[�&�ȝÄܺ��f�<����,�3��Tn������0S廙I�{f�S�ę�>���ǭ�r����nƵ�յ���L�]��ޱ�<<DSj����J�s�I�����\�?���vۜd�r�\?,,��\#�W�����⡾����B#��N�R�z<�>��6�B.����q@����7���X�����m���z����1���?+�olE����V�g�V�����m������x�?���[,�����V�v��� n�����.`����M�v���`c�?kH�n:+��+)�W���l���39I�f��ͥ���TI���&d���K������)��_v����������I��=��nZ�r:rN��J�Ծ���g-�jO������?&�Γ�Ը�>d���㣫V�)?�����xz�??N��z50��N�~��M,�8���Q�Q.͍I�+v��1ߝOGu��c�������?6q�v��v��>��������lP��-@[ [���?�����a���v���������,�����6�v���`s��w�� 6[���?6�w�G��?�RzX9��$6�&�,����_>���߽� �*7+�.����#wJ=�NZ����f�4;-�r��?˗����y�6���+��z.�6���0�v������En����iA��;��Y�r�5,��&�	�LݡU8�HJ��c��x����<��U��K�'�@�n��9�cv[J�Z�Gp�"�r`H}&Wd�������+�c��1S{��)"?/=��ĳ��T�f��|28/��JyM�.WJ5�_�����IGy,����3a��
����X.M筓���<�m��\^������S��Vk|c\�f7��m��;����ʙt3�������a�?v��� n�����]������m��g�l6��Y�;`+�V����?��������������3��c�m����/��w^����r���o��y���q ����������o��'f"����_,���_�+Y5�)���E�+5��i�����.h�����/d�,_��j���Y� �
٬��S>����7����?�4��b�W��q��Uˏ����[����^i��䇩r���ǳ���sk�|^7�������f��^�iKם�v3|�������FL��u�gb��О.��K��8;��W�C�?,��ǳk�t�_��ԜI��;������߲u�� ���	|���b�����"���z��Ed.�c�m���l��?���X���?�Ͷ�m%���7�|����۠�E���l���X F��H��Al��g���_�x����lX���Al��g���?-D����X`[�!��
|� f�QU%��� 	�(�)DE�z�Ϥ5M릻�B&����R����q��W�%��/xE����0�]��*���ru,�/���yk>+�Yͳ	$������e.��F�����..�F�.�J�$_-���ge�<t��g�I��F����}�y{b��=��E'd��dI�����Wݒ� �9	�ͨgb@]]���K�<�<~���DE��Q���J�´��d�'}l�q�}'p����)��xl��W*���(���:�WN������'!����?��NG�{���bGK'��Œ���_�X��(i���|���w�qL�1�������]�S`Z��R��}�<�E�šٗ;�J�ݨ:�B�Q���6�����Ϳ�n�ϗ�>�ء{�ʚ�cNǷsʾY�H�Y����<�
,|���BQ�gsx6�݉�g�R�!��|�+�(F�mոڌ���Uؙ^�|zп���{ceT�:�"C���,��|J9�è7��b�>�<M��6�nۮ�*d���Z����^m#1"��A"�:/�&Cm�G:��b'S6̷��F�r������W֨>������w������ȔU�j:߼k��:#O{�g������P�|�bW��-;F$����	9��g
�}�2W�a[��c9R�ߗ(r�l�Q��su^�"'T�|iU��p�h��m��9��6'9sfL�O|H�	Yf
9��sB�>����|y��}�iuR�b�r=�̧_{SI��5�2��̀*?~z�i�Fu�,Ί�T�k�N�2j��[�b��(�R��ϻv�_����+��� ^9��?��;	���<��_%������~~:	�=�K:�	��c������/_n�x|nY��ۇ�m�\K�s�k�_�?<���QΏ�e��@mim�r����J�%��U�\`�i�ʲŢ[�Ay^����Ƿ��*ε�4Vd���m�l�����jͺ���R箞{gG�ťͻ+��?6��Y���bV1���/:_�K��A��b��A��>u�����3Q�s7k�?��1ۙX���3V�������Yҿ��>/�f�a5��ps':�j�Ž���&5�UK%!�&���a�07'}��ﯦ���b>���?%�����S���������	���A���������+�������WK�����������o�'����~��w��SLǘ���)���#�������_A��#������?�t,����J%��)���?����U�R���^+��K��B&��R��U/�z��2�U<��J��� 6Hd�D4!Œ�����$$)��x�wOo��y��?��?�T��s�t@����(T����[�V��V��Urx+��f��T�Yi6��|H�6��i�����v3�7��R�!�i�V:�LF�Ar~��T;`D�_r��S��c?R��<|�Ro�w�X.��X1Ⱬ�g��6�..7c� ��K�K�_SUIČNߙ����]�_4�Y�0��_�I�(�̚��Y��>���'7 �O��o�ogC�e��.f#Ee��V6ME��'����QH%���H��⷇yk��gH_'�i���YַV��Z�J��Ģ��/�)}@MW�cq/�o����tm�[n��n��E��@D�DGt�F	�zd��s���76�J�`�[���+��� [-yLjJD�n��N�{ɛ�L�)������O�vE	�&�K؂c]3%z>V|��.�c�TrU�g2��g �~�3�<�B�Ea�E�̂x �=K��<�R�@E���9搈(d���t2��t4Lh���ԩlh�c֑~aTdr\%��3D�]G$K��buH��5�2�q�a]a+�(o,��,2G(,��*���BaxB㭇��Hhg�+/�|޵��`>�x*
����%�Y��d��2K�1�zEgv�^8�Z��JFW�@��u�Q �����;��ۋ�޸�.q�|��1y�ZP���,�k�V�/�&���W`9���:�1�n�Q���lՁ�V�[l�)8�篣4�o#4��+|�m��kL9�@�����`=D���C�v�q����<S��R�n���Nh�B�[ F���oDЪ�]�\���
��������M[��R+	8P4濭�<K�ۑ�ܼ�h����vT�B6\��IZ�7zt��i�L3�eu���FE4݊5]�F�#C�Mz4Df^�����>\��؆'������̺�p	t	�G_��K�o��z&i��'s���2$�9Q���~o��ssw�O�Oν��j�x�@�!k$�	BcAׁ�<@sm�f�Ԑ��/��H9��K�@3 H렵 ~bɊ�(��0y�4�UTK2�(!YE`z�I�*�Ի�d�9ÃBh�DH֎��0���v�e�R�7
l�����-�U���v��6.�%=�^��K][��\�����~n][�DZ~|[�Vh6*���D��ŋ`�.2��1Q#�L�^9LJ6Y+ y�`9�68�|�E�z�nI�����b��dZe���)Zj�|��mp�������<{��Ͻ�%�ՙ�b�ڬ7�a@Ut��#��U=�\k�-����ri�v`x��7�+��h3̹�dY�ۥ&/^6�K�,c"�H\��Y`�Z�*YX ���H.^XɅ�Ѥ����q�"Na�>�F߅F���+|˦!��֧wS޺�}��4&��\���]�o�i19�g�Y�>�h�˅�S��˥�������jpY���Cر]8	�I��%�%�+��2)�E%���Ie.�EvYxlQ�[L�gK�lJ��#�٠�l��WّV�%]R�f<�E?��x�`��<�1��oЍH;��8�� �Ar�N��L?kI����6���k��%؟�����*�M�ȫ	c/ф�0Є��0v��0��	�^U�_�	cߩ	������Nw?�E�?$�����}�sQ|��o&����������QR�7
���`	���G(��SFD�pr.ѭ�Q��t�c�3'���=F�ͭ�0)b�	��d�Ur�A�t�LX�*���5�D�q��G������G����������6�l6��XZ3��3#�J���l8�WfI���H����l@g{s�"z�LE�C#ahH�& �`f�XE]"SX3��0��lZ�ܛXK��6z��Tt��!��#�Ti���B��c�
ˣj�^��*�:�*"��A7�z�I0Z�Ou� �)㑔�d�xIZj6e���%Q�"tMN��DC8\�J�X6���>F��cٲe�z�pE�
�Ž��{�R$�"�v�|��S����:���ys���������ͦ#`5L�06�M=.�{c3�(z��"�Z��B�ST�	��(\oA�Ѣ�6�v�Cɪ�'�e�I
�0����nh"L2v<�w�˷.���cz,�n>���5t����h��Ϲ���9Հ[�);�9� ���QL�v�Ȭ{ڇ���B��'��L}�g���d�����\"�[[�jM] �'$A�6�D���rk^\�s��s%���9����	��vA2�H�QhdQ� c�ޑc6���A쾷#�����E���!�Ԝ����܆�>6�A�*�pC�/e@ ];�4���s����4���i�ٴY��b���D\y���� ������A���?���E"[�x��S�&��Ԙ�s�� 60��9�qA[����O��Ê���C���<1�˥�oK�p
��ʺ��\�7M%V�P�CKQpB$(��ϐ�_�mZ�k	�����F����]���[�M��`�h��{��a��5�`c�ۆ�!��&9otnׇ�8� e��n�����g��π9�"�E���ٵ)%{M�lU#�OTn�5HRp1�/�`�AP0�̝,��@f��7ԅ.�l�Oz��,�=���+3��AZ����'"�����<W�ű��"��
�t�U�=Sǒ��d����˻���p�ė�@�-�m=�\^{�D�@yۺSdŖ^�(/��F!S��Eykdh3�M�ahV�>8����쾣��LL�vL��q;��e�t7K��"��w2�Q�0�6S٪-o�S�KFu�BҮ`�$0Ǡ��a�K��8H�&6������C�V��6:hrr�<�\(����]�r��K�X�,����N�5}*�o��,χ.Vfg�Dۣ��Z�w���T$I?O�?�\�v�̺�ľR閹p��>��S���� �dO{ԁ�W����{v��G�O* [G�L�fљ [�ǜi�K�3�tgw1��#�9���i�t���z�Hris���$3����~��!��W�'���`�(�bd�Yd���E�%����M4�]06i
l@���L	�"[M�2`ƀ��������~=Gb��ҁ��r_��6�g����t�.ΰ*�g}����	��f��U ���=k$Xh,G�-�͍���:h���Z�tfS3�|l�+ ;�8#�	w��IP40\���?�z�/�LĂ�GI?�����`�w��=6��Q���d"��K�n9��6�q�v�w�?龫���m9�����g&6��A�oI��e��������d"���t���_�r�Mp��#i��w(�{z
M9� n,n�!���휑��xSݒ�7������"7+�%�nhx]�a8� /�(G~�5t���v\6�
���H�z�Mr��/������k�:��=J�`���vL�^YUu�yf/!k��fL������=�1\߷_my@��?��A�#0��; r�{�Lt|����dH�|��y�dU�V�6�g�D����>�����]��0'9iX�<��p��{&�woxH��{��%�#�����"�ws)r�h�؈�/}{�	!���N=$��UtGy5m��[���dj��O:��9J�n��Q��3��Y���E�=�ࠢ����EX�ӎ��;bE�Ǟ�\	pB#�m����Q1V���"V�W��A�<���/���ቑ�zӇ�{u����!bƯ��5�W���ek�3��v��K�h$��'�Nvw�\�G�O�s�-U��~�&�O�G��wq���GW��A$����H���7~�=������)�����GaG���"�}�c������?���]]�M��%�������f�߼`����V�Ӷ�0�}}�ي��`ҹ�pU{�i���2o����/�����*X�=J:U����q�Ɩ�7���?�>� �䖫���^����%gE��wQŹ��[Z]y.gH}�YPL X��C����|Ӯ������_o	��4���iLE|�usāg8j�p��B��J�R���h���X��nIP@�y/�#DM���f��>�cW�<O����'q�$�}b���5���?�n5
l��{%l	��)B�D+�`D�7o*]��v�Q<)�Эà��>�<�os�Vg=��: רV�7XhwW��?9�u]�u�1��M�^�Y�_L�������R�W��Y^������f��Y�y���/{� �W�4�GI'����;c{�X�$>�D߰r~��G��Q8ܛ�Jo�پaa��p���[s�B���$(��iD��=>�`���J�%^V,���#������?�2�K�����/��]]��V^�L��;�Nw��N���\D��j&���T��8��$�L��8���q'������E+��}��Ĳ� *VZu+H�]X��<�B !UZv�{s?f��i��R��M����������8����<�C	���Gq�d"R����4����}��/ª�����.�?;;�?�%P�B�ɵ��k��a�\<����Cx�<��?;a�0�`���ܱ��j�>�ǲ?Αٱά(���&u��Lq��/�����!�@ңɐ�h_w���a��5���t���J��?�	�L�?ً��Gr�P���b���f��p�m	IIғ�����D�Ԕ�A"�k2<���)���*�)���t��4ޖY-��g�6H<�y�I7iLiUd̦=��x���z�XZ����6��H0/�'�m"������"� �d0[큕f����Aӭ�����tߞ��ކd�x�\�9D�c�Jݓj��PZ�����Y���ʻ��XbۮW�mcb���jH{�l�8���+(��f�LZ��d���>NJ���S؎*-����
�����J��p����l����/���^G��y��X�?yo�?����O]��R� ���GrAo>���͝˻Wv>�[�����]=d��^A�Et����,b�����X� q#�nⲡ��5,��Z�I"V��-�ȓ�<�<�D�����	������/?��w���+�������[�_�߼��eh�)\����2�@��נ'���������ؗt���d�Ά��0tC^��-���%�W/or�s�X;�z�ۅ��t���?��8|�q9�{�9q��B�?_O*��u�mt��m
^ڴp�÷��i�������?~�ߞ��ۗ�x�?_�oO����_]gdLg���w���r����(���c���Ȣ�	�ϒ�_���v�������?����z�3����W��?�����O���>�w�J��U���[*��~~�ҍK	V��k)V\Km����v^z�$q�k%�aY&�!
9��v�\��v.���4�8�dɜE�5M"���,�!h�4IN����x�[�_���k���柼��Wo� [��N��V�?}���~���/�E�����7�2�囻��,�x��W���y��g��߾r��#�HmN@.�i��i`���p�h����Ţ�3-��ΐ���ю^��v9�6��,��B�s UY�'К&,�H�SӒ��_��`h╙�dE��:Ka��Υ8�g:6�u,���Z�
��혝�[��٢¶Lx&��V4�]��RϪ	�՘�RPʑ�X3-�Ve�a�GE� �-�&�U45f!����hJ�E����c]a�%�y!�T�8��l{�7	�h�<3f�e�o�	b��#A&6W�Z�bP�榲�A��ND%DG-�gM�=<w:=v e@U]Ϣh8q�b�jJ��4�1S�����Y�X
!�@��0l���X���Ef�o*A'�군vyA���!��P#d�!v���2���sj�v:�%YeY��#��D9΄r�"%Z�����$P��g)0@,e��n�]��ݪ�G�e0шj ���n{���"pC�'��~fHe�5<�'��Wo�"�Z0T�,��:�c&�ZPWN)��W�L\��B/���x?��e��.\��6?B�Ӷ���K�P��9$[����Ω��=w�����?q�TQf*U���(��wNI�� �kF����i���ip�Â��k?�yl��a�9^�E�؈�V,�0�A���TR�b��E|��X�2ܒ��]�T��>0�t�l[^��,�*J����H�Vĝinԏ!��x�'�E���ZmP�P��4�R��z�욋��S����<b*uR�(�-�x&J��nd�Q��j̔���(k�2���N9u�2�I�c��ڡ���� �U�2�q���_*-���I1���1͛-�ծr�\��F������,�%�3�/�l<��ҰFy�Y�6i�9(�"�<����x�e�!1�y �����|Yt�m�Jք��x��j}+#�Z�Z7��VN�F%V�ftl�h�a46�j�zC�jV�btF$ǫ��M����A[��f�� ���Ѡq�YN��'��&Y���.�q��vY5����|�q%_ɲա��Y�q��Ai�/�
JM�:��Pu(���٭cd��[X�1��1���g�k�K����k���di��*4h:��H/>����K��^]�����R�4����� IXu!x`YS�FR�\���2�. :���+`�%�,D����l4f��b���p�$=*�U]��PEofHUz�6���\��k�J��jSm�}*�kQjY��F&�&&Ja*��%h#�	[�h��,Ft ��j�Y�S����n��ߜg�f�6���h��eivB�#�E���Us$�ƭQsz�:��u9��.AZ�~u8'��+p b��4�T�R ՄM'ٔ�+�(��9䀨�7N	 :*P� @�'�%�x-Fe8���k�0P[&����x^j�Rwg2��F_��C���,1R"	��x��$Ɯ�!����u��s�"����<�����c���@�$6�Hf^����ą�W���myy#1�����\f~a�����K ���	rw��![W���M<��|%�y��k��1��@�[��%�?r��G��C�vr����O�秷>�w���������u����߿��<�x���{�K�g+ќr��"+|�@���y��SD6��=��~�����u�E!���}WV���v[3�a#7Ul	������u��t���xl(3��Uņ�̠�P��Js�jMˏ�x�8ES��ow���f���J�C�L�V_t��nX��i㽔�,p)��~M�"H�u2t���O��0W�����SKF8�Ϝ�c{��;���!�l�(U�L(�v?����V�Ȍ��!�X�9��p(�A�f�Pɺ�Q�g��ZŞ"�����R��jl���w���:U��e��W�v;�g�>�P7���� 7G1��aT�9W��NKX4.�A��	aU�F�A�?U��G5f���J'�ё4�H˦^P���h��ZX�\2�f��*��l-;m��z'��fو���d��5��b~�:yB�Q�L��<i5�e��W;�/u�$WX��>K5���kR�)�o*{P����E��f�g6[�ӛ��������S;��;c9y㡎������(�����"m�������o�Zk�7o�z��c�_?bj���	���LէA~�vidV�]L(����n{[q (n;!����Zv�hz�*��
�/��
�n`�(�@G���|��'M���D�Y�.S[ (*�� H6�;K0���,�����E��܀V��B"A�!h�L�'����-_�U�v��X覧��3$�K�X��AM��~ԎA=��$��:6u<=��.w�l����G:E�j)1֞��()<APlHp'���l�2��r��Z�FM$�<>i�CC�a����� >��ieOr#' &���Ug���X3���.Ba��W��Wd}�XA˄$An�	�%��P$2eeD�OG��(��I���e�fVy�����L�����|��x���gɽo����(�&��o�*(�<`��yT L�%�����<X���PwH�U���d�V����l��̔�\�0+����)Ţ՜��&�m?R�yR�Z��!��Z+���`qZ3��y -X�O��͔�|/������l��FNN�MDz�rYR�����o��X����)Z�;վ�����Qb�ճK$�]aƩ�}2�y���@��1��	��0_�/�\�s|���:��:��:���u��h��Ѫ�X��b��b�����_8�K)�X�#�Y����	L��N�b�w�����?��G8g�FThk�HD��!�$\�|&��T���MZU��=o�3�[�y�D�
�|�uU�i�"��#��3��TF�d��=ʹ��.�q�R�u��(�
G�x a��@�̓r=�m�-��L��A�Fb�*ןL�y��z�fE����O{�V""]f�|win?7�(���m��!=��1^iR3��0�� �!�p��X�&�� r.�+�֕��2�f|"���D�����
�e��(��'w.��G��O�O���� �y������9�h�8�MDS��ǔ�?�ww���ڣp*˱߀�@O����ݦ�^�҃�e7��g�k;ЍW_�&�ܫ�>���V4�O����!�I�c�c�{{�	�y"�(����<�M|��`:�;��|H����/Y4c�v�)��j�p�^�n$z8=?!�a8����;)].I��.�%�P�%E���������p�\��qLI�V�Z,�"$�%��9��R��|H�������Q0
F�(#	  '��9  