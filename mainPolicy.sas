/* ����ɮ׸��| */
%let libData = D:\Dropbox\Andy\AOL�ҵ{���q\�p�⭱�V����\��F�B�]�F�B����\data;
/* ��ƪ�ͦ����| */
libname libTable 'D:\Dropbox\Andy\AOL�ҵ{���q\�p�⭱�V����\��F�B�]�F�B����\sas7bdat';

/*���V���ƭp���`�{��*/
%include 'func.sas';

/* �T�t�C�ӭ׽Ҧ��Z���H�D��X�� */
%person_score();

/* ����t */
%let depart = policy;
/* ���۲έp */
/* ���סG required subject */
%let req_list = "���|��Ǭ�s��k" "����F��" "���@�F��" "���إ���˪k�P�F��" "�q�Ƭ�s��k�]�@�^" 
				"�q�Ƭ�s��k(�@)�G" "�q�Ƭ�s��k�]�@�^�G��¦�έp���R" "����F�v��Q�v" "�]�Ȧ�F" 
"�H�Ʀ�F" "��v�F�v��Q�v" "��F�۲z" "�a��F��"  "�D��Q��´�޲z" 
				"�F�v��" "��F��" "��F�k";
/* ��סGelective subject */
%let elect_list = "���@�ưȪv�z�ɽ�" "�k�Ǻ���" "���@�޲z���" "�g�پ�" "���|��Ǹ�ƳB�z�P�{���]�p�ɽ�" 
						"�F�v�o�i�z��" "�F���Z�ĺ޲z" "���@�A�Ⱦǲ߻P���|���h" "��ڬF�v�g�پ�" "���|�P�벼�欰" 
						"�F�v���Ǿɽ�" "�]�F��" "�x����׻P�欰" "�F������" "�F���W��" 
						"�H�O�귽�M�D" "�����޲z" "�C��B���~�P�F�v" "���@�F���W�۾�Ū" "�F���P���~"
					 	"���D�F�v�P�j���C��" "���|�зs�P���|���~" "�F������" "�F�v���|��" "�C��P���N" 
						"�⩤���Y�P��ڬF�v" "�F�v���ǦW�ۿ�Ū" "�һͲz�׻P���" "���D�P���|" "���q�Ч�"
					 	"���N�լd�P���R" "�q�Ƭ�s��k�]�G�^" "�q�Ƭ�s��k�]�G�^�G�F����Ƥ��R" "��´�z�׻P�欰" "�D�F����´"
					 	"���|���~" "���|���~�P���q�Ч�" "�q�l�ƬF��" "�F�����R" "�ڬw�ΦX�ɽ�" 
						"�H�O�귽�޲z" "���F��" "����F�v��ץv" "�j���ظg�ٰ�" "�x�W�F�v�o�i"
					 	"���k���n" "���|��" "�����P�F�v" "�Ȭw�q�v�P�F�v" "��|�k�פ��R"
					 	"���t�P�����t�F��" "�ڬw�g�ٻP�f����X" "���@�޲z" "�޲z��" "����o�i�F��" 
						"�F����w�L�{" "�߲z��" "�зN���" "�����F" "�F�ҧQ�q����P�F��"
						"�ߪk�{��" "�F�v�g�پ�" "����F�v" "��F����" "��F�޲z�M�D" 
						"�U��H�ƨ��" "�H�s���Y" "ĳ�|�F�v" "�H�O�귽�o�i" "�a��]�F�M�D" 
						"�����ѻP" "�x�W���@��F�M�D" "���D�F�v�P�j���C��" "��F�ǦW�ۿ�Ū" "�H�O�W��"
					 	"�������|�ɽ�" "���t�F���P�F�v" "�x�W���@�F���M�D" "���y�F�v�g�٤Τ��@�F��" "���|��Ǭ�s��k��" 
						"��´�g�پ�" "��Ƭ�s��k" "�`��g�پ�" "��N�U�إD�q" "�F����P"
						"��F���s�M�D" "�⩤���Y�M�D";

%course_ori(&depart, &req_list, &elect_list, 3);

/* �C��ǥͤ��ƭp�� */
%spawn_radar_score(&depart, &req_list, &elect_list);

/*�C�L doc �ɮ�*/
%output_doc(&depart, &stu_list, &stu_num);
