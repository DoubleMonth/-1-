function  f_calculateGradient( r_fileName )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
samplingTime = 1; %%����ʱ��
path = pwd;
%% �����ʾ��Ϣ
disp(strcat('���ڴ���',r_fileName));
disp('���Ժ�......');
%% ����Excel���
[excelData,str] = xlsread(r_fileName,1);               %��ȡԭʼ���ݱ��е����ݣ�strΪ���ݱ��е��ַ���dataΪ���ݱ��е�����
[excelRow,excelColumn] = size(excelData);        %%��ȡ���ݱ��е����и���
value =  zeros(excelRow,4);                      %����һ����Ӧ������1�еľ������ڴ洢����������
invalidDataNum = zeros(1,4);                     %��¼���ݱ�ǰ����Ч���ݵĸ�����
[m,n] = size(str);                              %% ���ݱ����ַ��ĸ���
needStr = {'����','�ۼ����','GPS����','GPS���','GPS����'}; %% �����¶���Ҫ��������
needStrStationIn_value = zeros(1,5);                        %% ����������ԭʼ���ݱ��е�λ��

%% �ҳ���Ҫ����������ԭʼ���ݱ��е�λ��
for i = 1 :n                        
    for j = 1: 5
        if strcmp(str(1,i),needStr(1,j))>0
            needStrStationIn_value(1,j) = i-1;      %% -1����Ϊ��ԭ���ݱ��е�һ��Ϊʱ�䣬MATLAB��ȡ�����ݾ�����û����һ�С�excelData��������������ԭʼexcel��һ�У���һ�С�
        end
    end
end
format short g                                      %%������ʾ��ʽ
%% �Ǳ��ټ����¶�
for row_x = 1: excelRow - 1
    gpsElevationDiffe = excelData(row_x+1,needStrStationIn_value(1,5)) - excelData(row_x,needStrStationIn_value(1,5));
    speedSum =  excelData(row_x+1,needStrStationIn_value(1,1)) + excelData(row_x,needStrStationIn_value(1,1));
    if speedSum == 0                                                        % speedSum=0ʱ����ĸΪ0����Ч����
        if invalidDataNum(1,1) == 0                                         % ��û�м�¼��Ч���ݸ���ʱ��Ч���ݵ�λ�����0
            value(row_x,1) = 0;
        else
            value(row_x,1) = value(row_x-1,1);                          %��¼��Ч���ݸ���������һ�����ݽ������
        end
    else                                                                   %��Ч����
        if invalidDataNum(1,1) == 0                                        
            invalidDataNum(1,1) = row_x;                                  %��û�м�¼��Ч����ʱ��¼����Ч���ݵĸ���
        end     
        mid_value_2 = asind(gpsElevationDiffe/(speedSum/2*samplingTime/3600*1000)); 
        if isreal(mid_value_2)                                              
            podu = tand(mid_value_2) *100;
            value(row_x,1) = abs(podu);                                       %д�������
        else
%             value(row_x,1) = value(row_x-1,1);                         %%���ָ���ʱ��Ϊ���ݳ���ʹ����һ���������
        end
    end
end
%% �ۼ���̼����¶�
for row_x = 1: excelRow - 1
    gpsElevationDiffe = excelData(row_x+1,needStrStationIn_value(1,5)) - excelData(row_x,needStrStationIn_value(1,5));
    accumulativeMileageDiffe =  excelData(row_x+1,needStrStationIn_value(1,2)) - excelData(row_x,needStrStationIn_value(1,2));
    if accumulativeMileageDiffe == 0                                        %%�ۼ���̲����0���������ʱʹ����һ�е����ݽ������
        if invalidDataNum(1,2) == 0                                         % ��û�м�¼��Ч���ݸ���ʱ��Ч���ݵ�λ�����0
            value(row_x,2) = 0;
        else
            value(row_x,2) = value(row_x-1,2);
        end
    else   
        if invalidDataNum(1,2) == 0                                         % ��û�м�¼��Ч���ݸ���ʱ��Ч���ݵ�λ�����0
            invalidDataNum(1,2) = row_x;
        end
        mid_value_2 = asind(gpsElevationDiffe/accumulativeMileageDiffe/1000); 
            podu =  tand(mid_value_2)*100;
            value(row_x,2) = abs(podu);                                         %д�������
    end
end
%% GPS���ټ����¶�
for row_x = 1: excelRow - 1
    gpsElevationDiffe = excelData(row_x+1,needStrStationIn_value(1,5)) - excelData(row_x,needStrStationIn_value(1,5));
    gpsSpeedSum =  excelData(row_x+1,needStrStationIn_value(1,3)) + excelData(row_x,needStrStationIn_value(1,3));
    if gpsSpeedSum == 0                                                    %%�ٶȻ����0���������ʱʹ����һ�е����ݽ������
        if invalidDataNum(1,3) == 0                                         % ��û�м�¼��Ч���ݸ���ʱ��Ч���ݵ�λ�����0
            value(row_x,3) = 0;
        else
            value(row_x,3) = value(row_x-1,3);
        end
    else   
        if invalidDataNum(1,3) == 0                                         % ��û�м�¼��Ч���ݸ���ʱ��Ч���ݵ�λ�����0
            invalidDataNum(1,3) = row_x;
        end
        mid_value_2 = asind(gpsElevationDiffe/(gpsSpeedSum/2*samplingTime/3600*1000)); %% ע���޸Ĳ���ʱ��
        if isreal(mid_value_2)                                              %%���ָ���ʱ��Ϊ���ݳ���ʹ����һ���������
            podu =  tand(mid_value_2)*100;
            value(row_x,3) = abs(podu);                                        %д�������
        else
%             value(row_x,3) = value(row_x-1,3);
        end
    end
end
%% GPS��̼����¶�
for row_x = 1: excelRow - 1
    gpsElevationDiffe = excelData(row_x+1,needStrStationIn_value(1,5)) - excelData(row_x,needStrStationIn_value(1,5));
    gpsMileageDiffe =  excelData(row_x+1,needStrStationIn_value(1,4)) - excelData(row_x,needStrStationIn_value(1,4));
    if gpsMileageDiffe == 0                                                %%�ٶȻ����0���������ʱʹ����һ�е����ݽ������
        if invalidDataNum(1,4) == 0                                        % ��û�м�¼��Ч���ݸ���ʱ��Ч���ݵ�λ�����0
            value(row_x,4) = 0;
        else
            value(row_x,4) = value(row_x-1,4);
        end
    else   
        if invalidDataNum(1,4) == 0                                        % ��û�м�¼��Ч���ݸ���ʱ��Ч���ݵ�λ�����0
            invalidDataNum(1,4) = row_x;
        end
        mid_value_2 = asind(gpsElevationDiffe/gpsMileageDiffe/1000); 
            podu = tand(mid_value_2)*100;
            value(row_x,4) = abs(podu);                                        %д�������
    end
end
%% �˲��㷨--ȥ��>0.2��<-0.2�����ݣ�����һ���������
for i = 1:4
    for j = 2:excelRow
        if value(j,i)>40||value(j,i)<-40
            value(j,i) = value(j-1,i);
        end
    end
end
i = find('.'==r_fileName);
imname = r_fileName(1:i-1); %% imnameΪ������׺�ļ����� 
outFile = strcat(imname,'_output');
if exist(outFile)   %% �������output�ļ��У���ɾ��
     rmdir (outFile,'s');
end
mkdir(outFile);%% ����һ��Output�ļ���
cd(fullfile(path,outFile));       %%����outputĿ¼
poduFile = strcat(imname,'_caiji.xlsx'); %%��ɴ�excle�ļ�����podu�ļ���
value_2 = value(max(invalidDataNum(:)):excelRow,1:4);                               %%ȡ����������Ч���ݣ�������Ч����
colname={'���','�Ǳ��ټ����¶�','�ۼ���̼����¶�','GPS���ټ����¶�','GPS��̼����¶�','����','��ʻ����'};    %%����ÿһ�е���������
warning off MATLAB:xlswrite:AddSheet;   %%��ֹ����warning���� 
xlswrite(poduFile, colname, 'sheet1','A1');
xuhao = linspace(1,m-max(invalidDataNum(:)),m-max(invalidDataNum(:)));
xlswrite(poduFile, xuhao', 'sheet1','A2');                %%���
% xlswrite(poduFile,str(max(invalidDataNum(:))+1:m,1), 'sheet1','B2');              %%ʱ��
xlswrite(poduFile,abs(value_2), 'sheet1','B2');                    %%����������ȡ�ۼ���̼����¶�

licheng=zeros(m-max(invalidDataNum(:)),1);
sudu=zeros(m-max(invalidDataNum(:)),1);
for i = 1:m-max(invalidDataNum(:))-1
    sudu(i,1)= excelData(max(invalidDataNum(:))+i,needStrStationIn_value(1,1));
    licheng(i,1) = (excelData(max(invalidDataNum(:))+i,needStrStationIn_value(1,2))-excelData(max(invalidDataNum(:))+1,needStrStationIn_value(1,2)))*1000;
end
sudu(m-max(invalidDataNum(:)),1)= sudu(m-max(invalidDataNum(:))-1,1);
licheng(m-max(invalidDataNum(:)),1) = licheng(m-max(invalidDataNum(:))-1,1);
xlswrite(poduFile,sudu, 'sheet1','F2'); %% �ٶ�
xlswrite(poduFile,licheng, 'sheet1','G2'); %% ��ʻ���

% delete(fh);
%% ���ݴ�����ϣ������ʾ��Ϣ
disp('���ݴ�����ϣ���鿴��ǰ�ļ����µ�');
disp(poduFile);
cd ..       %%�˳�outputĿ¼

end

