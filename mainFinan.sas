%include '.\func_store\func.sas';

/*�]�F�t*/
%let depart = finan;
/* ���סG required subject */
%let req_list ="�έp��" "����g�پ�" "�`��g�پ�" "�f���Ȧ��" "�ұo�|�z�׻P���" 
				"���|�k" "�L�n��" "�g�پ�" "�|�p��" "�Өƪk"
                "�]�F�ǡ]�@�^" "���ŷ|�p��" "���O�|�z�׻P���" "�]���|�z�׻P���";
/* ��סGelective subject */
%let elect_list = "���k���n" "�g�ټƾ�" "���Ųz�׻P�޲z" "��ڪ��Ĳz�׻P�F��" "�����g�ٻP�F��" 
						"�p�q�g�پ�" "�]�F�ǡ]�G�^"  "���Ĩ�׻P���" "�����|�p" "�欰�]�F��"
                       	"���|�w�����(�@)" "����:�z�׻P�ʲz" "�w��z�׻P���" "�]�F�ǦW�ۿ�Ū" "��گ��|"
                        "�ɧ��z��" "������|���" "���@���" "�]�Ⱥ޲z" "�����įq���R" 
						"�]�ȳ�����R" "�a��]�F" "���|�z�׻P���" "�]�Fĳ�D�P�n������" "�����]�F"
                        "�]�F�j����" "��ڪ��ıM�D" "������|���(�@)" "���|�w����׻P�F��(�@)" "������|���(�G)"
                       "�]�F���Ĺ�Ȥ��R" "���|�w����׻P�F��(�G)" "�]�F���Ĺ��" "���@�ưȱM�D" "�]�F�j����";

/* �ͦ��ҵ{���V�� */
%course_ori(&depart, &req_list, &elect_list, 3);

/* �C��ǥͤ��ƭp�� */
%spawn_radar_score(&depart, &req_list, &elect_list);

/*�C�L doc �ɮ�*/
%output_doc(&depart, &stu_list, &stu_num);
