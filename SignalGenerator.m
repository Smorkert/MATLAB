%Sample Rate (Hz):
Fs = 44100;
%Bit Depth:
B = 16;
%length of sample (sec.):
l = .0046;
%Frequencies-to enter multiple: f = [440,523.2574,659.2694];
f = [440];
%Add noise
dB = 0;
%Attenuation Factor (0-1)
a =.1;
%signed or unisgned (0:unsigned, 1:signed)
sign = 0;


%Start of Algorithm-------------------------------------------
t = [0:(1/Fs):l-(1/Fs)];
y = [];
Xn = 0;
for i = 1:length(f)
    y = [y;sin(2*pi*f(i)*t)];
    Xn = Xn + y(i,:);
end

%Add noise
Xn = Xn + rand(1,length(t))*(dB*length(f));

if sign == 0
    A = 2^(B)*a;
    %Float version for error calculation
    fXn = map(Xn, min(Xn), max(Xn), 0, (2^B)-A);
    %scale
    Xn = round(map(Xn, min(Xn), max(Xn), 0, (2^B)-A));
else
    A = 2^(B-1)*a;
    %Float version for error calculation
    fXn = map(Xn, min(Xn), max(Xn), -(2^B/2)+A, (2^B/2)-A);
    %scale
    Xn = round(map(Xn, min(Xn), max(Xn), -(2^B/2)+A, (2^B/2)-A));
end

plot(Xn);

%Write to file
fileID = fopen('data_in.txt','w');
fprintf(fileID,'%d \n',Xn);
fclose(fileID);

