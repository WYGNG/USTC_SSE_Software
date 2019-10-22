function [changed_serial_CRC] = en_CRC(changed_serial, info, k, G, word_size)

% some settings SHIT
info_length = length(info)*8;
bits_in_one = floor(log2(k+1));
[~, CSlen] = size(changed_serial);
changed_serial_CRC = zeros(1, CSlen);
[len_G, ~] = size(G);
message_len = word_size-len_G+1;
words_num = floor(info_length*k/bits_in_one/message_len);
% words_num = floor(info_length/message_len);


% divide blocks, doublt it
for index_d = 1:1:words_num
    C1 = zeros(word_size,1);
    pos_ori = (index_d-1)*message_len+1;
    pos_chg = (index_d-1)*word_size+1;
    changed_serial_CRC(1, pos_chg:pos_chg+message_len) = changed_serial(1,pos_ori:pos_ori+message_len);
    C1(1:message_len, 1) = changed_serial(1,pos_ori:pos_ori+message_len-1)';
    t=C1(1:word_size-message_len+1,1);%8=n-k;eg.n-k+1=9;  t为 n-k+1--1的向量
    for j=word_size-message_len+2:word_size
        t=mod((t+t(1)*G),2);
        t=[t(2:word_size-message_len+1);C1(j,1)];
    end
    t=mod((t+t(1)*G),2);
    C1(message_len+1:word_size,1)=t(2:word_size-message_len+1);%2-9,共8位
    changed_serial_CRC(1, pos_chg:pos_chg+word_size-1) = C1';
end
changed_serial_CRC(1,index_d*word_size+1:CSlen) = changed_serial(1, index_d*word_size+1:CSlen);


% info_CRC_serial = reshape(C1,1,word_size*word_num);
